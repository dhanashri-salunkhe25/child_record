import 'package:flutter/material.dart';
import '../services/sync_service.dart';
import '../services/database_service.dart';

class SyncStatusScreen extends StatefulWidget {
  const SyncStatusScreen({super.key});

  @override
  State<SyncStatusScreen> createState() => _SyncStatusScreenState();
}

class _SyncStatusScreenState extends State<SyncStatusScreen> {
  final SyncService _syncService = SyncService();
  final DatabaseService _databaseService = DatabaseService();
  Map<String, dynamic> _syncStatus = {};
  bool _isLoading = true;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadSyncStatus();
  }

  Future<void> _loadSyncStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final status = await _syncService.getSyncStatus();
      setState(() {
        _syncStatus = status;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading sync status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Status'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSyncStatus,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSyncStatus,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildConnectionStatus(),
                      const SizedBox(height: 20),
                      _buildSyncStatistics(),
                      const SizedBox(height: 20),
                      _buildSyncActions(),
                      const SizedBox(height: 20),
                      _buildESignetStatus(),
                      const SizedBox(height: 20),
                      _buildSyncHistory(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildConnectionStatus() {
    final isConnected = _syncStatus['isConnected'] ?? false;
    
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isConnected 
                ? [Colors.green[50]!, Colors.green[100]!]
                : [Colors.red[50]!, Colors.red[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              size: 40,
              color: isConnected ? Colors.green[600] : Colors.red[600],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isConnected ? 'Connected' : 'Offline',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isConnected ? Colors.green[800] : Colors.red[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isConnected 
                        ? 'Internet connection available for sync'
                        : 'No internet connection. Data will sync when connected.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isConnected ? Colors.green[600] : Colors.red[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatistics() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sync Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Total Children', _syncStatus['totalChildren']?.toString() ?? '0'),
            _buildStatRow('Total Health Records', _syncStatus['totalRecords']?.toString() ?? '0'),
            _buildStatRow('Pending Upload', _syncStatus['unuploadedRecords']?.toString() ?? '0'),
            _buildStatRow('Last Sync', _formatLastSyncTime()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncActions() {
    final isConnected = _syncStatus['isConnected'] ?? false;
    final unuploadedRecords = _syncStatus['unuploadedRecords'] ?? 0;

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sync Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isConnected && unuploadedRecords > 0 && !_isSyncing
                    ? _performSync
                    : null,
                icon: _isSyncing 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync),
                label: Text(_isSyncing ? 'Syncing...' : 'Sync Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _validateCredentials,
                icon: const Icon(Icons.verified),
                label: const Text('Validate eSignet Connection'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildESignetStatus() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'eSignet Integration',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildESignetInfoRow('API Endpoint', 'https://api.esignet.gov.in/child-health'),
            _buildESignetInfoRow('Authentication', 'Bearer Token'),
            _buildESignetInfoRow('Data Encryption', 'AES-256'),
            _buildESignetInfoRow('Sync Frequency', 'Manual/On-demand'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Data is encrypted before transmission to eSignet for secure health record management.',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildESignetInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncHistory() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Sync Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSyncHistoryItem(
              'Health records synced',
              '2 records uploaded to eSignet',
              '2 minutes ago',
              Icons.cloud_upload,
              Colors.green,
            ),
            _buildSyncHistoryItem(
              'Connection established',
              'eSignet API connection successful',
              '5 minutes ago',
              Icons.wifi,
              Colors.blue,
            ),
            _buildSyncHistoryItem(
              'Data encryption completed',
              'Health records encrypted for transmission',
              '5 minutes ago',
              Icons.security,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncHistoryItem(String title, String subtitle, String time, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatLastSyncTime() {
    final lastSync = _syncStatus['lastSyncTime'];
    if (lastSync == null) return 'Never';
    
    try {
      final dateTime = DateTime.parse(lastSync);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      } else {
        return '${difference.inDays} days ago';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<void> _performSync() async {
    setState(() {
      _isSyncing = true;
    });

    try {
      final success = await _syncService.syncData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Sync completed successfully' : 'Sync failed'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        
        _loadSyncStatus();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  Future<void> _validateCredentials() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final isValid = await _syncService.validateESignetCredentials();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isValid ? 'eSignet connection validated' : 'eSignet connection failed'),
            backgroundColor: isValid ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Validation error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 
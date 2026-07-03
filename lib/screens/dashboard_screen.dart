import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/sync_service.dart';
import '../widgets/simple_app_icon.dart';
import '../widgets/app_bar_icon.dart';

import 'children_list_screen.dart';
import 'add_child_screen.dart';
import 'sync_status_screen.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  final DatabaseService _databaseService = DatabaseService();
  final SyncService _syncService = SyncService();
  Map<String, dynamic> _statistics = {};
  User? _user;

  late AnimationController _mainController;
  late Animation<double> _fadeWelcome;
  late Animation<Offset> _slideWelcome;
  late Animation<double> _fadeStats;
  late Animation<Offset> _slideStats;
  late Animation<double> _fadeQuick;
  late Animation<Offset> _slideQuick;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeWelcome = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    );
    _slideWelcome = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    ));
    _fadeStats = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
    );
    _slideStats = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    ));
    _fadeQuick = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    );
    _slideQuick = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));
    _mainController.forward();
    _loadStatistics();
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  Future<void> _loadStatistics() async {
    final stats = await _databaseService.getStatistics();
    setState(() {
      _statistics = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            AppBarIcon(size: 24),
            SizedBox(width: 8),
            Text('Child Health Record'),
          ],
        ),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => _showSyncDialog(),
            tooltip: 'Sync Data',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadStatistics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity: _fadeWelcome,
                child: SlideTransition(
                  position: _slideWelcome,
                  child: _buildWelcomeCard(),
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeStats,
                child: SlideTransition(
                  position: _slideStats,
                  child: _buildStatisticsCards(),
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeQuick,
                child: SlideTransition(
                  position: _slideQuick,
                  child: _buildQuickActions(),
                ),
              ),
              const SizedBox(height: 20),
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddChildScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Child'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.blue[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const SimpleAppIcon(size: 80),
            const SizedBox(height: 16),
            FutureBuilder<User?>(
              future: Future.value(_user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final user = snapshot.data;
                final displayName = user?.displayName;
                final email = user?.email;
                return Text(
                  'Welcome, ${displayName ?? email ?? 'Surveyor'}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              "Let's check on the health of the children in your care.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Total Children',
          _statistics['totalChildren']?.toString() ?? '0',
          Icons.child_care,
          Colors.green,
        ),
        _buildStatCard(
          'Health Records',
          _statistics['totalRecords']?.toString() ?? '0',
          Icons.medical_services,
          Colors.orange,
        ),
        _buildStatCard(
          'Pending Upload',
          _statistics['unuploadedRecords']?.toString() ?? '0',
          Icons.cloud_upload,
          Colors.red,
        ),
        _buildStatCard(
          'Sync Status',
          'Online',
          Icons.wifi,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              'View Children',
              Icons.people,
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChildrenListScreen()),
              ),
            ),
            _buildActionCard(
              'Add Health Record',
              Icons.add_chart,
              Colors.green,
              () => _showAddRecordDialog(),
            ),
            _buildActionCard(
              'Sync Status',
              Icons.sync_alt,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SyncStatusScreen()),
              ),
            ),
            _buildActionCard(
              'Vaccination Schedule',
              Icons.schedule,
              Colors.purple,
              () => _showVaccinationSchedule(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.medical_services, color: Colors.blue[600]),
            ),
            title: const Text('Health records synced'),
            subtitle: const Text('2 records uploaded to eSignet'),
            trailing: Text(
              '2 min ago',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSyncDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Data'),
        content: const Text('Do you want to sync all pending health records with eSignet?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              _showSyncProgress();
            },
            child: const Text('Sync'),
          ),
        ],
      ),
    );
  }

  void _showSyncProgress() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Syncing data with eSignet...'),
          ],
        ),
      ),
    );

    _syncData();
  }

  Future<void> _syncData() async {
    final success = await _syncService.syncData();
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Sync completed successfully' : 'Sync failed'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
    
    _loadStatistics();
  }

  void _showAddRecordDialog() {
    // Navigate to children list to select a child for adding health record
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChildrenListScreen()),
    );
  }

  void _showVaccinationSchedule() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vaccination Schedule'),
        content: const Text('Vaccination schedule feature will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 
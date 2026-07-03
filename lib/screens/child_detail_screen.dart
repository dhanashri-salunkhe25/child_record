import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/child.dart';
import '../models/health_record.dart';
import '../services/database_service.dart';
import 'add_health_record_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChildDetailScreen extends StatefulWidget {
  final Child child;

  const ChildDetailScreen({super.key, required this.child});

  @override
  State<ChildDetailScreen> createState() => _ChildDetailScreenState();
}

class _ChildDetailScreenState extends State<ChildDetailScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<HealthRecord> _healthRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHealthRecords();
  }

  Future<void> _loadHealthRecords() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');
      final records = await _databaseService.getHealthRecordsByChildId(widget.child.id!, user.uid);
      setState(() {
        _healthRecords = records;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading health records: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.child.name),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(),
            tooltip: 'Edit Child',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadHealthRecords,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChildInfoCard(),
                const SizedBox(height: 20),
                _buildHealthSummary(),
                const SizedBox(height: 20),
                _buildGrowthChart(),
                const SizedBox(height: 20),
                _buildHealthRecordsList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addHealthRecord(),
        icon: const Icon(Icons.add_chart),
        label: const Text('Add Health Record'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildChildInfoCard() {
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
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue[100],
              child: widget.child.photoPath != null
                  ? ClipOval(
                      child: Image.asset(
                        widget.child.photoPath!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.child_care,
                            size: 40,
                            color: Colors.blue[600],
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.child_care,
                      size: 40,
                      color: Colors.blue[600],
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.child.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Age: ${_calculateAge(widget.child.dateOfBirth)} years'),
                  Text('Gender: ${widget.child.gender}'),
                  Text('Parent: ${widget.child.parentName}'),
                  Text('Contact: ${widget.child.contactNumber}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSummary() {
    final latestRecord = _healthRecords.isNotEmpty ? _healthRecords.first : null;
    
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (latestRecord != null) ...[
              _buildSummaryRow('Latest Visit', _formatDate(latestRecord.visitDate)),
              _buildSummaryRow('Weight', '${latestRecord.weight?.toStringAsFixed(1)} kg'),
              _buildSummaryRow('Height', '${latestRecord.height?.toStringAsFixed(1)} cm'),
              _buildSummaryRow('Temperature', '${latestRecord.temperature?.toStringAsFixed(1)}°C'),
              if (latestRecord.heartRate != null)
                _buildSummaryRow('Heart Rate', '${latestRecord.heartRate} bpm'),
            ] else ...[
              const Text('No health records available'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthChart() {
    if (_healthRecords.length < 2) {
      return Card(
        elevation: 3,
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          child: const Center(
            child: Text('Add more health records to see growth chart'),
          ),
        ),
      );
    }

    final weightData = _healthRecords
        .where((record) => record.weight != null)
        .map((record) => FlSpot(
              record.visitDate.millisecondsSinceEpoch.toDouble(),
              record.weight!,
            ))
        .toList();

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weight Growth Chart',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: weightData,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthRecordsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Health Records',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_healthRecords.length} records',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_healthRecords.isEmpty)
          Card(
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(16),
              child: const Center(
                child: Text('No health records available'),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _healthRecords.length,
            itemBuilder: (context, index) {
              final record = _healthRecords[index];
              return _buildHealthRecordCard(record);
            },
          ),
      ],
    );
  }

  Widget _buildHealthRecordCard(HealthRecord record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: record.isUploaded ? Colors.green[100] : Colors.orange[100],
          child: Icon(
            record.isUploaded ? Icons.cloud_done : Icons.cloud_upload,
            color: record.isUploaded ? Colors.green[600] : Colors.orange[600],
          ),
        ),
        title: Text(
          _formatDate(record.visitDate),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (record.weight != null) Text('Weight: ${record.weight} kg'),
            if (record.height != null) Text('Height: ${record.height} cm'),
            if (record.temperature != null) Text('Temperature: ${record.temperature}°C'),
            if (record.vaccinationName != null) 
              Text('Vaccination: ${record.vaccinationName}'),
            if (record.diagnosis != null) Text('Diagnosis: ${record.diagnosis}'),
            Text(
              record.isUploaded ? 'Synced' : 'Pending sync',
              style: TextStyle(
                color: record.isUploaded ? Colors.green[600] : Colors.orange[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => _showRecordDetails(record),
        ),
      ),
    );
  }

  String _calculateAge(String dateOfBirth) {
    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      final age = now.year - birthDate.year;
      if (now.month < birthDate.month || 
          (now.month == birthDate.month && now.day < birthDate.day)) {
        return (age - 1).toString();
      }
      return age.toString();
    } catch (e) {
      return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _addHealthRecord() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddHealthRecordScreen(child: widget.child),
      ),
    ).then((_) => _loadHealthRecords());
  }

  void _showRecordDetails(HealthRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Health Record - ${_formatDate(record.visitDate)}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (record.weight != null) Text('Weight: ${record.weight} kg'),
              if (record.height != null) Text('Height: ${record.height} cm'),
              if (record.headCircumference != null) 
                Text('Head Circumference: ${record.headCircumference} cm'),
              if (record.temperature != null) Text('Temperature: ${record.temperature}°C'),
              if (record.heartRate != null) Text('Heart Rate: ${record.heartRate} bpm'),
              if (record.bloodPressureSystolic != null) 
                Text('Blood Pressure: ${record.bloodPressureSystolic}/${record.bloodPressureDiastolic} mmHg'),
              if (record.vaccinationName != null) 
                Text('Vaccination: ${record.vaccinationName}'),
              if (record.symptoms != null) Text('Symptoms: ${record.symptoms}'),
              if (record.diagnosis != null) Text('Diagnosis: ${record.diagnosis}'),
              if (record.treatment != null) Text('Treatment: ${record.treatment}'),
              if (record.medications != null) Text('Medications: ${record.medications}'),
              if (record.notes != null) Text('Notes: ${record.notes}'),
              if (record.doctorName != null) Text('Doctor: ${record.doctorName}'),
              if (record.hospitalName != null) Text('Hospital: ${record.hospitalName}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    // Implementation for editing child information
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit functionality will be implemented here'),
      ),
    );
  }
} 
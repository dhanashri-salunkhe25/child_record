import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/child.dart';
import '../models/health_record.dart';
import '../services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddHealthRecordScreen extends StatefulWidget {
  final Child child;

  const AddHealthRecordScreen({super.key, required this.child});

  @override
  State<AddHealthRecordScreen> createState() => _AddHealthRecordScreenState();
}

class _AddHealthRecordScreenState extends State<AddHealthRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;

  // Form controllers
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _headCircumferenceController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _bloodPressureSystolicController = TextEditingController();
  final TextEditingController _bloodPressureDiastolicController = TextEditingController();
  final TextEditingController _vaccinationNameController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();

  DateTime _visitDate = DateTime.now();
  DateTime? _vaccinationDate;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _headCircumferenceController.dispose();
    _temperatureController.dispose();
    _heartRateController.dispose();
    _bloodPressureSystolicController.dispose();
    _bloodPressureDiastolicController.dispose();
    _vaccinationNameController.dispose();
    _symptomsController.dispose();
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _medicationsController.dispose();
    _notesController.dispose();
    _doctorNameController.dispose();
    _hospitalNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Health Record - ${widget.child.name}'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVisitInfoSection(),
                      const SizedBox(height: 20),
                      _buildMeasurementsSection(),
                      const SizedBox(height: 20),
                      _buildVitalSignsSection(),
                      const SizedBox(height: 20),
                      _buildVaccinationSection(),
                      const SizedBox(height: 20),
                      _buildMedicalSection(),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildVisitInfoSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visit Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Visit Date'),
              subtitle: Text(_formatDate(_visitDate)),
              trailing: const Icon(Icons.edit),
              onTap: () => _selectVisitDate(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Physical Measurements',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monitor_weight),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _heightController,
                    decoration: const InputDecoration(
                      labelText: 'Height (cm)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.height),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _headCircumferenceController,
              decoration: const InputDecoration(
                labelText: 'Head Circumference (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.circle),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalSignsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vital Signs',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _temperatureController,
                    decoration: const InputDecoration(
                      labelText: 'Temperature (°C)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.thermostat),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _heartRateController,
                    decoration: const InputDecoration(
                      labelText: 'Heart Rate (bpm)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.favorite),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _bloodPressureSystolicController,
                    decoration: const InputDecoration(
                      labelText: 'BP Systolic',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.bloodtype),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _bloodPressureDiastolicController,
                    decoration: const InputDecoration(
                      labelText: 'BP Diastolic',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.bloodtype),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccinationSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vaccination',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _vaccinationNameController,
              decoration: const InputDecoration(
                labelText: 'Vaccination Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.vaccines),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Vaccination Date'),
              subtitle: Text(_vaccinationDate != null 
                  ? _formatDate(_vaccinationDate!) 
                  : 'Not specified'),
              trailing: const Icon(Icons.edit),
              onTap: () => _selectVaccinationDate(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _symptomsController,
              decoration: const InputDecoration(
                labelText: 'Symptoms',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.sick),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _diagnosisController,
              decoration: const InputDecoration(
                labelText: 'Diagnosis',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.medical_services),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _treatmentController,
              decoration: const InputDecoration(
                labelText: 'Treatment',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.healing),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _medicationsController,
              decoration: const InputDecoration(
                labelText: 'Medications',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.medication),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _doctorNameController,
                    decoration: const InputDecoration(
                      labelText: 'Doctor Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _hospitalNameController,
                    decoration: const InputDecoration(
                      labelText: 'Hospital Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_hospital),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Save Health Record',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _selectVisitDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _visitDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _visitDate = picked;
      });
    }
  }

  Future<void> _selectVaccinationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _vaccinationDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _vaccinationDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  double? _parseDouble(String? value) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value);
  }

  int? _parseInt(String? value) {
    if (value == null || value.isEmpty) return null;
    return int.tryParse(value);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');
      final record = HealthRecord(
        userId: user.uid,
        childId: widget.child.id!,
        visitDate: _visitDate,
        weight: _parseDouble(_weightController.text),
        height: _parseDouble(_heightController.text),
        headCircumference: _parseDouble(_headCircumferenceController.text),
        temperature: _parseDouble(_temperatureController.text),
        heartRate: _parseInt(_heartRateController.text),
        bloodPressureSystolic: _parseInt(_bloodPressureSystolicController.text),
        bloodPressureDiastolic: _parseInt(_bloodPressureDiastolicController.text),
        vaccinationName: _vaccinationNameController.text.isNotEmpty 
            ? _vaccinationNameController.text.trim() 
            : null,
        vaccinationDate: _vaccinationDate,
        symptoms: _symptomsController.text.isNotEmpty 
            ? _symptomsController.text.trim() 
            : null,
        diagnosis: _diagnosisController.text.isNotEmpty 
            ? _diagnosisController.text.trim() 
            : null,
        treatment: _treatmentController.text.isNotEmpty 
            ? _treatmentController.text.trim() 
            : null,
        medications: _medicationsController.text.isNotEmpty 
            ? _medicationsController.text.trim() 
            : null,
        notes: _notesController.text.isNotEmpty 
            ? _notesController.text.trim() 
            : null,
        doctorName: _doctorNameController.text.isNotEmpty 
            ? _doctorNameController.text.trim() 
            : null,
        hospitalName: _hospitalNameController.text.isNotEmpty 
            ? _hospitalNameController.text.trim() 
            : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _databaseService.insertHealthRecord(record);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health record added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding health record: $e'),
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
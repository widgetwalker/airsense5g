import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:air_quality_guardian/app/routes.dart';
import 'package:air_quality_guardian/core/constants/aqi_constants.dart';
import 'package:air_quality_guardian/core/utils/validators.dart';
import 'package:air_quality_guardian/presentation/providers/auth_provider.dart';
import 'package:air_quality_guardian/data/models/simple_health_profile.dart';

class HealthFormScreen extends StatefulWidget {
  const HealthFormScreen({super.key});

  @override
  State<HealthFormScreen> createState() => _HealthFormScreenState();
}

class _HealthFormScreenState extends State<HealthFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _outdoorHoursController = TextEditingController();

  String _selectedGender = 'Male';
  List<String> _selectedConditions = [];
  String _selectedActivityLevel = AqiConstants.activityModerate;
  double _sensitivity = 3.0;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;

  @override
  void dispose() {
    _ageController.dispose();
    _outdoorHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Profile'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Age
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age',
                prefixIcon: Icon(Icons.cake_outlined),
                helperText: 'Enter your age (1-120)',
              ),
              validator: Validators.validateAge,
            ),
            const SizedBox(height: 16),

            // Gender
            DropdownButtonFormField<String>(
              initialValue: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                prefixIcon: Icon(Icons.wc_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
                DropdownMenuItem(
                    value: 'Prefer not to say',
                    child: Text('Prefer not to say'),),
              ],
              onChanged: (value) {
                setState(() => _selectedGender = value!);
              },
            ),
            const SizedBox(height: 16),

            // Health Conditions
            Text(
              'Health Conditions',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                AqiConstants.conditionAsthma,
                AqiConstants.conditionCOPD,
                AqiConstants.conditionHeartDisease,
                AqiConstants.conditionAllergies,
                AqiConstants.conditionDiabetes,
                AqiConstants.conditionNone,
              ].map((condition) {
                final isSelected = _selectedConditions.contains(condition);
                return FilterChip(
                  label: Text(condition),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (condition == AqiConstants.conditionNone) {
                        _selectedConditions = selected ? [condition] : [];
                      } else {
                        if (selected) {
                          _selectedConditions
                              .remove(AqiConstants.conditionNone);
                          _selectedConditions.add(condition);
                        } else {
                          _selectedConditions.remove(condition);
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Activity Level
            DropdownButtonFormField<String>(
              initialValue: _selectedActivityLevel,
              decoration: const InputDecoration(
                labelText: 'Activity Level',
                prefixIcon: Icon(Icons.directions_run_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'Sedentary', child: Text('Sedentary')),
                DropdownMenuItem(value: 'Light', child: Text('Light')),
                DropdownMenuItem(value: 'Moderate', child: Text('Moderate')),
                DropdownMenuItem(value: 'Active', child: Text('Active')),
                DropdownMenuItem(
                    value: 'Very Active', child: Text('Very Active'),),
              ],
              onChanged: (value) {
                setState(() => _selectedActivityLevel = value!);
              },
            ),
            const SizedBox(height: 16),

            // Pollution Sensitivity
            Text(
              'Pollution Sensitivity: ${_sensitivity.toInt()}/5',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Slider(
              value: _sensitivity,
              min: 1,
              max: 5,
              divisions: 4,
              label: _sensitivity.toInt().toString(),
              onChanged: (value) {
                setState(() => _sensitivity = value);
              },
            ),
            Text(
              _sensitivity <= 2
                  ? 'Low'
                  : _sensitivity <= 4
                      ? 'Medium'
                      : 'High',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 16),

            // Outdoor Hours
            TextFormField(
              controller: _outdoorHoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Average Outdoor Hours per Day',
                prefixIcon: Icon(Icons.wb_sunny_outlined),
                helperText: 'Optional (0-24)',
              ),
              validator: Validators.validateOutdoorHours,
            ),
            const SizedBox(height: 24),

            // Notification Preferences
            Text(
              'Notification Preferences',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive alerts on your device'),
              value: _pushNotifications,
              onChanged: (value) {
                setState(() => _pushNotifications = value);
              },
            ),
            SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive alerts via email'),
              value: _emailNotifications,
              onChanged: (value) {
                setState(() => _emailNotifications = value);
              },
            ),
            SwitchListTile(
              title: const Text('SMS Notifications'),
              subtitle: const Text('Receive alerts via SMS (Premium)'),
              value: _smsNotifications,
              onChanged: (value) {
                setState(() => _smsNotifications = value);
              },
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('SAVE PROFILE'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedConditions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select at least one health condition'),),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final healthProfile = SimpleHealthProfile(
      age: int.parse(_ageController.text),
      gender: _selectedGender,
      healthConditions: _selectedConditions,
      activityLevel: _selectedActivityLevel,
      pollutionSensitivity: _sensitivity.toInt(),
      outdoorHoursPerDay: _outdoorHoursController.text.isNotEmpty
          ? double.parse(_outdoorHoursController.text)
          : null,
      notificationPreferences: {
        'push': _pushNotifications,
        'email': _emailNotifications,
        'sms': _smsNotifications,
      },
    );

    final success = await authProvider.saveHealthProfile(healthProfile);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Health profile saved successfully!')),
      );
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

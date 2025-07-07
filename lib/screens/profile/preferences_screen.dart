import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/gradient_button.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  RangeValues _ageRange = const RangeValues(18, 35);
  double _distance = 25;
  String _interestedIn = 'Women';
  bool _showOnlyVerified = false;
  bool _showRecentlyActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discovery Preferences'),
        actions: [
          TextButton(
            onPressed: _savePreferences,
            child: Text(
              'Save',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Age Range', _buildAgeRangeSlider()),
            const SizedBox(height: 32),
            _buildSection('Maximum Distance', _buildDistanceSlider()),
            const SizedBox(height: 32),
            _buildSection('Show Me', _buildGenderSelection()),
            const SizedBox(height: 32),
            _buildSection('Additional Filters', _buildAdditionalFilters()),
            const SizedBox(height: 40),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildAgeRangeSlider() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_ageRange.start.round()} years',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              Text(
                '${_ageRange.end.round()} years',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RangeSlider(
            values: _ageRange,
            min: 18,
            max: 65,
            divisions: 47,
            activeColor: AppTheme.primaryColor,
            inactiveColor: AppTheme.primaryColor.withOpacity(0.3),
            onChanged: (values) {
              setState(() => _ageRange = values);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceSlider() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Distance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '${_distance.round()} km',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Slider(
            value: _distance,
            min: 1,
            max: 100,
            divisions: 99,
            activeColor: AppTheme.secondaryColor,
            inactiveColor: AppTheme.secondaryColor.withOpacity(0.3),
            onChanged: (value) {
              setState(() => _distance = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildGenderOption('Women', Icons.female),
          const SizedBox(height: 12),
          _buildGenderOption('Men', Icons.male),
          const SizedBox(height: 12),
          _buildGenderOption('Everyone', Icons.people),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = _interestedIn == gender;
    
    return GestureDetector(
      onTap: () => setState(() => _interestedIn = gender),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppTheme.accentColor : AppTheme.textTertiary.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.accentColor : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              gender,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppTheme.accentColor : AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.accentColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.infoColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFilterToggle(
            'Show only verified profiles',
            'See profiles with verified badges',
            _showOnlyVerified,
            (value) => setState(() => _showOnlyVerified = value),
          ),
          const SizedBox(height: 20),
          _buildFilterToggle(
            'Show recently active',
            'Prioritize users active in the last week',
            _showRecentlyActive,
            (value) => setState(() => _showRecentlyActive = value),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterToggle(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.infoColor,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return GradientButton(
      text: 'Save Preferences',
      width: double.infinity,
      onPressed: _savePreferences,
    );
  }

  void _savePreferences() async {
    try {
      final preferences = {
        'ageRange': {
          'min': _ageRange.start.round(),
          'max': _ageRange.end.round(),
        },
        'maxDistance': _distance.round(),
        'interestedIn': _interestedIn,
        'showOnlyVerified': _showOnlyVerified,
        'showRecentlyActive': _showRecentlyActive,
      };
      
      final response = await ApiService.updateSettings(preferences);
      
      if (response['success'] && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferences saved successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to save preferences'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving preferences: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _showAge = true;
  bool _showDistance = true;
  bool _showOnline = true;
  bool _allowLocationSharing = true;
  bool _showInDiscovery = true;
  bool _allowProximityAlerts = true;
  String _profileVisibility = 'Everyone';
  String _messagePermissions = 'Matches Only';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Safety'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Profile Visibility',
              'Control who can see your profile information',
              [
                _buildToggleItem(
                  'Show my age',
                  'Display your age on your profile',
                  Icons.cake,
                  _showAge,
                  (value) => setState(() => _showAge = value),
                ),
                _buildToggleItem(
                  'Show distance',
                  'Display distance from other users',
                  Icons.location_on,
                  _showDistance,
                  (value) => setState(() => _showDistance = value),
                ),
                _buildToggleItem(
                  'Show online status',
                  'Let others see when you\'re active',
                  Icons.circle,
                  _showOnline,
                  (value) => setState(() => _showOnline = value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Discovery Settings',
              'Manage how you appear to others',
              [
                _buildToggleItem(
                  'Show me on ConnectSphere',
                  'Appear in other users\' discovery',
                  Icons.visibility,
                  _showInDiscovery,
                  (value) => setState(() => _showInDiscovery = value),
                ),
                _buildDropdownItem(
                  'Profile visibility',
                  'Who can see your full profile',
                  Icons.people,
                  _profileVisibility,
                  ['Everyone', 'Matches Only', 'Friends Only'],
                  (value) => setState(() => _profileVisibility = value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Location & Proximity',
              'Control location-based features',
              [
                _buildToggleItem(
                  'Allow location sharing',
                  'Enable location-based matching',
                  Icons.my_location,
                  _allowLocationSharing,
                  (value) => setState(() => _allowLocationSharing = value),
                ),
                _buildToggleItem(
                  'Proximity alerts',
                  'Get notified when matches are nearby',
                  Icons.notifications_active,
                  _allowProximityAlerts,
                  (value) => setState(() => _allowProximityAlerts = value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Communication',
              'Manage who can contact you',
              [
                _buildDropdownItem(
                  'Who can message me',
                  'Control who can send you messages',
                  Icons.message,
                  _messagePermissions,
                  ['Everyone', 'Matches Only', 'No One'],
                  (value) => setState(() => _messagePermissions = value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Data & Security',
              'Manage your data and account security',
              [
                _buildActionItem(
                  'Download my data',
                  'Get a copy of your ConnectSphere data',
                  Icons.download,
                  () => _downloadData(),
                ),
                _buildActionItem(
                  'Delete account',
                  'Permanently delete your account',
                  Icons.delete_forever,
                  () => _showDeleteAccountDialog(),
                  isDestructive: true,
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String subtitle, List<Widget> items) {
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
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildToggleItem(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: value 
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: value ? AppTheme.primaryColor : Colors.grey,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildDropdownItem(
    String title,
    String subtitle,
    IconData icon,
    String value,
    List<String> options,
    ValueChanged<String> onChanged,
  ) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) onChanged(newValue);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isDestructive 
              ? Colors.red.withOpacity(0.1)
              : AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : AppTheme.primaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDestructive ? Colors.red : AppTheme.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              const Text(
                'Your Privacy Matters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'We take your privacy seriously. You have full control over your profile visibility and data sharing. Learn more about our privacy practices in our Privacy Policy.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Read Privacy Policy →',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data download request submitted. You\'ll receive an email shortly.'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion process initiated.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
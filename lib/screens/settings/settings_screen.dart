import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'notification_settings_screen.dart';
import 'privacy_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSettingsSection(
              'Account',
              [
                _buildSettingsItem(
                  Icons.person_outline,
                  'Personal Information',
                  'Update your profile details',
                  () {},
                ),
                _buildSettingsItem(
                  Icons.photo_library_outlined,
                  'Photos',
                  'Manage your profile photos',
                  () {},
                ),
                _buildSettingsItem(
                  Icons.tune,
                  'Discovery Preferences',
                  'Age range, distance, and more',
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              'Privacy & Safety',
              [
                _buildSettingsItem(
                  Icons.security,
                  'Privacy Settings',
                  'Control your privacy and visibility',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrivacySettingsScreen()),
                  ),
                ),
                _buildSettingsItem(
                  Icons.block,
                  'Blocked Users',
                  'Manage blocked contacts',
                  () {},
                ),
                _buildSettingsItem(
                  Icons.report,
                  'Safety Center',
                  'Report issues and get help',
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              'Notifications',
              [
                _buildSettingsItem(
                  Icons.notifications_outlined,
                  'Push Notifications',
                  'Manage your notification preferences',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                  ),
                ),
                _buildSettingsItem(
                  Icons.location_on,
                  'Proximity Alerts',
                  'When friends are nearby',
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              'App Preferences',
              [
                _buildSettingsItem(
                  Icons.palette_outlined,
                  'Theme',
                  'Light, dark, or system',
                  () => _showThemeDialog(context),
                ),
                _buildSettingsItem(
                  Icons.language,
                  'Language',
                  'Choose your preferred language',
                  () {},
                ),
                _buildSettingsItem(
                  Icons.storage,
                  'Storage',
                  'Manage app data and cache',
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              'Support',
              [
                _buildSettingsItem(
                  Icons.help_outline,
                  'Help Center',
                  'Get answers to common questions',
                  () {},
                ),
                _buildSettingsItem(
                  Icons.feedback_outlined,
                  'Send Feedback',
                  'Help us improve ConnectSphere',
                  () {},
                ),
                _buildSettingsItem(
                  Icons.info_outline,
                  'About',
                  'App version and legal information',
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
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
        const SizedBox(height: 12),
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

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
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
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppTheme.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showLogoutDialog(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Log Out',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.auto_mode),
              title: const Text('System'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
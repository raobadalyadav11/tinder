import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _newMatches = true;
  bool _messages = true;
  bool _superLikes = true;
  bool _proximityAlerts = true;
  bool _hangoutInvites = true;
  bool _activitySuggestions = false;
  bool _marketingEmails = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Push Notifications',
              'Get notified about important activities',
              [
                _buildToggleItem(
                  'New Matches',
                  'When someone likes you back',
                  Icons.favorite,
                  _newMatches,
                  (value) => setState(() => _newMatches = value),
                ),
                _buildToggleItem(
                  'Messages',
                  'New messages from your matches',
                  Icons.message,
                  _messages,
                  (value) => setState(() => _messages = value),
                ),
                _buildToggleItem(
                  'Super Likes',
                  'When someone super likes you',
                  Icons.star,
                  _superLikes,
                  (value) => setState(() => _superLikes = value),
                ),
                _buildToggleItem(
                  'Proximity Alerts',
                  'When matches are nearby',
                  Icons.location_on,
                  _proximityAlerts,
                  (value) => setState(() => _proximityAlerts = value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Social Features',
              'Stay updated on social activities',
              [
                _buildToggleItem(
                  'Hangout Invites',
                  'Invitations to group events',
                  Icons.event,
                  _hangoutInvites,
                  (value) => setState(() => _hangoutInvites = value),
                ),
                _buildToggleItem(
                  'Activity Suggestions',
                  'New activities near you',
                  Icons.explore,
                  _activitySuggestions,
                  (value) => setState(() => _activitySuggestions = value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Marketing',
              'Promotional content and updates',
              [
                _buildToggleItem(
                  'Marketing Emails',
                  'Tips, features, and promotions',
                  Icons.email,
                  _marketingEmails,
                  (value) => setState(() => _marketingEmails = value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Notification Style',
              'How you receive notifications',
              [
                _buildToggleItem(
                  'Sound',
                  'Play notification sounds',
                  Icons.volume_up,
                  _soundEnabled,
                  (value) => setState(() => _soundEnabled = value),
                ),
                _buildToggleItem(
                  'Vibration',
                  'Vibrate for notifications',
                  Icons.vibration,
                  _vibrationEnabled,
                  (value) => setState(() => _vibrationEnabled = value),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildQuietHoursSection(),
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

  Widget _buildQuietHoursSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bedtime,
                  color: AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quiet Hours',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Pause notifications during these hours',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTimeSelector('From', '22:00'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimeSelector('To', '08:00'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(String label, String time) {
    return GestureDetector(
      onTap: () => _selectTime(label),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectTime(String label) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      // Handle time selection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label time updated to ${picked.format(context)}'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    }
  }
}
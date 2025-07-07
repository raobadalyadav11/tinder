import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHelpSection('Getting Started', [
            'How to create a profile',
            'Setting up your preferences',
            'Adding photos',
            'Writing a great bio',
          ]),
          _buildHelpSection('Matching & Swiping', [
            'How matching works',
            'Understanding super likes',
            'What happens when you match',
            'Managing your matches',
          ]),
          _buildHelpSection('Safety & Privacy', [
            'Staying safe while dating',
            'Reporting inappropriate behavior',
            'Blocking users',
            'Privacy settings',
          ]),
          _buildHelpSection('Account & Billing', [
            'Managing your account',
            'Subscription options',
            'Canceling subscription',
            'Account deletion',
          ]),
          const SizedBox(height: 32),
          _buildContactSupport(),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        children: items.map((item) => ListTile(
          title: Text(item),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        )).toList(),
      ),
    );
  }

  Widget _buildContactSupport() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryLight],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.support_agent, color: Colors.white, size: 50),
          const SizedBox(height: 16),
          const Text(
            'Still need help?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Contact our support team',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }
}
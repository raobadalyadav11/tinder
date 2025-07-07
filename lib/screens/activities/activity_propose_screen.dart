import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';

class ActivityProposeScreen extends StatefulWidget {
  final Map<String, dynamic>? activity;

  const ActivityProposeScreen({super.key, this.activity});

  @override
  State<ActivityProposeScreen> createState() => _ActivityProposeScreenState();
}

class _ActivityProposeScreenState extends State<ActivityProposeScreen> {
  final _messageController = TextEditingController();
  final List<String> _selectedMatches = [];
  
  final List<Map<String, String>> _matches = [
    {'name': 'Emma', 'avatar': 'https://picsum.photos/100/100?random=m1'},
    {'name': 'Sarah', 'avatar': 'https://picsum.photos/100/100?random=m2'},
    {'name': 'Jessica', 'avatar': 'https://picsum.photos/100/100?random=m3'},
    {'name': 'Lisa', 'avatar': 'https://picsum.photos/100/100?random=m4'},
    {'name': 'Anna', 'avatar': 'https://picsum.photos/100/100?random=m5'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.activity != null) {
      _messageController.text = 'Hey! Want to join me for ${widget.activity!['title']}? It looks amazing!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Propose Activity'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.activity != null) _buildActivityPreview(),
            const SizedBox(height: 24),
            _buildMatchSelection(),
            const SizedBox(height: 24),
            _buildMessageSection(),
            const SizedBox(height: 32),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityPreview() {
    final activity = widget.activity!;
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(activity['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['location'],
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      activity['rating'].toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      activity['price'],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Matches',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Choose who you want to invite',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _matches.length,
          itemBuilder: (context, index) {
            final match = _matches[index];
            final isSelected = _selectedMatches.contains(match['name']);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.secondaryColor.withOpacity(0.1) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppTheme.secondaryColor : Colors.grey.shade200,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(match['avatar']!),
                ),
                title: Text(
                  match['name']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                subtitle: const Text('Online now'),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedMatches.add(match['name']!);
                      } else {
                        _selectedMatches.remove(match['name']!);
                      }
                    });
                  },
                  activeColor: AppTheme.secondaryColor,
                ),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedMatches.remove(match['name']!);
                    } else {
                      _selectedMatches.add(match['name']!);
                    }
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMessageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Message',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Add a personal touch to your invitation',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Message',
          hint: 'Write something nice...',
          controller: _messageController,
          maxLines: 4,
          prefixIcon: Icons.message,
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return GradientButton(
      text: 'Send Invitation${_selectedMatches.isNotEmpty ? ' (${_selectedMatches.length})' : ''}',
      width: double.infinity,
      gradientColors: [AppTheme.secondaryColor, AppTheme.secondaryLight],
      onPressed: _selectedMatches.isNotEmpty ? _sendInvitation : null,
    );
  }

  void _sendInvitation() {
    if (_selectedMatches.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invitation sent to ${_selectedMatches.length} match${_selectedMatches.length > 1 ? 'es' : ''}!'),
        backgroundColor: AppTheme.secondaryColor,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
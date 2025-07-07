import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../providers/feedback_provider.dart';

class ReportScreen extends StatefulWidget {
  final String userName;

  const ReportScreen({super.key, required this.userName});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _detailsController = TextEditingController();
  String _selectedReason = 'Inappropriate behavior';
  bool _isLoading = false;

  final List<String> _reasons = [
    'Inappropriate behavior',
    'Fake profile',
    'Harassment',
    'Spam',
    'Nudity or sexual content',
    'Violence or threats',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report ${widget.userName}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why are you reporting this user?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ..._reasons.map((reason) => _buildReasonTile(reason)),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Additional Details',
              hint: 'Please provide more information...',
              controller: _detailsController,
              maxLines: 4,
              prefixIcon: Icons.description,
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Submit Report',
              width: double.infinity,
              isLoading: _isLoading,
              onPressed: _submitReport,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonTile(String reason) {
    return RadioListTile<String>(
      title: Text(reason),
      value: reason,
      groupValue: _selectedReason,
      onChanged: (value) => setState(() => _selectedReason = value!),
      activeColor: AppTheme.primaryColor,
    );
  }

  void _submitReport() async {
    setState(() => _isLoading = true);
    
    try {
      final feedbackProvider = Provider.of<FeedbackProvider>(context, listen: false);
      final success = await feedbackProvider.reportUser(
        'user_id_placeholder',
        _selectedReason,
        _detailsController.text.trim(),
      );
      
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report submitted successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(feedbackProvider.error ?? 'Failed to submit report'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }
}
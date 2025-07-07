import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/gradient_button.dart';

class BlockConfirmationScreen extends StatelessWidget {
  final String userName;

  const BlockConfirmationScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Block User')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(Icons.block, color: Colors.red, size: 50),
            ),
            const SizedBox(height: 32),
            Text(
              'Block $userName?',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'They won\'t be able to find you on ConnectSphere or send you messages. They won\'t be notified that you blocked them.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 40),
            GradientButton(
              text: 'Block User',
              width: double.infinity,
              gradientColors: [Colors.red, Colors.red.shade400],
              onPressed: () => _blockUser(context),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void _blockUser(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$userName has been blocked'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
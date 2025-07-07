import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/theme/app_theme.dart';
import '../../services/permission_service.dart';
import '../../widgets/gradient_button.dart';
import '../auth/login_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _isLoading = false;

  final List<Map<String, dynamic>> _permissions = [
    {
      'icon': Icons.camera_alt,
      'title': 'Camera',
      'description': 'Take photos for your profile',
      'color': AppTheme.primaryColor,
    },
    {
      'icon': Icons.photo_library,
      'title': 'Photos',
      'description': 'Choose photos from gallery',
      'color': AppTheme.secondaryColor,
    },
    {
      'icon': Icons.location_on,
      'title': 'Location',
      'description': 'Find matches nearby',
      'color': AppTheme.accentColor,
    },
    {
      'icon': Icons.notifications,
      'title': 'Notifications',
      'description': 'Get notified about matches',
      'color': AppTheme.infoColor,
    },
    {
      'icon': Icons.contacts,
      'title': 'Contacts',
      'description': 'Find friends on ConnectSphere',
      'color': AppTheme.successColor,
    },
    {
      'icon': Icons.mic,
      'title': 'Microphone',
      'description': 'Send voice messages',
      'color': AppTheme.warningColor,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 40),
              Expanded(
                child: _buildPermissionsList(),
              ),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.primaryLight],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Icon(Icons.security, color: Colors.white, size: 50),
        ),
        const SizedBox(height: 24),
        const Text(
          'Permissions Required',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'We need these permissions to provide you with the best experience',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsList() {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: _permissions.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildPermissionItem(_permissions[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPermissionItem(Map<String, dynamic> permission) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: permission['color'].withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: permission['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              permission['icon'],
              color: permission['color'],
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  permission['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  permission['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.textTertiary,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Column(
      children: [
        GradientButton(
          text: 'Grant Permissions',
          width: double.infinity,
          isLoading: _isLoading,
          onPressed: _requestPermissions,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => _navigateToLogin(),
          child: Text(
            'Skip for now',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _requestPermissions() async {
    setState(() => _isLoading = true);

    try {
      final granted = await PermissionService.requestAllPermissions();
      
      if (granted) {
        _showSuccessDialog();
      } else {
        _showPartialPermissionDialog();
      }
    } catch (e) {
      _showErrorDialog();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.successColor),
            SizedBox(width: 8),
            Text('All Set!'),
          ],
        ),
        content: const Text('All permissions granted successfully. You can now enjoy the full ConnectSphere experience!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToLogin();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showPartialPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppTheme.warningColor),
            SizedBox(width: 8),
            Text('Some Permissions Denied'),
          ],
        ),
        content: const Text('Some features may not work properly without all permissions. You can grant them later in settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToLogin();
            },
            child: const Text('Continue Anyway'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _requestPermissions();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Error'),
          ],
        ),
        content: const Text('An error occurred while requesting permissions. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToLogin();
            },
            child: const Text('Skip'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _requestPermissions();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
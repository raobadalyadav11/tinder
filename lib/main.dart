import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/main_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/swipe_provider.dart';
import 'providers/hangout_provider.dart';
import 'providers/map_provider.dart';
import 'providers/feedback_provider.dart';
import 'utils/location_helper.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize services
  await _initializeServices();
  
  runApp(const ConnectSphereApp());
}

Future<void> _initializeServices() async {
  try {
    // Initialize notification service
    await NotificationService.initialize();
    
    // Initialize location helper
    await LocationHelper.requestPermission();
    
    print('Services initialized successfully');
  } catch (e) {
    print('Error initializing services: $e');
  }
}

class ConnectSphereApp extends StatelessWidget {
  const ConnectSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => SwipeProvider()),
        ChangeNotifierProvider(create: (_) => HangoutProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'ConnectSphere',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: const SplashScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const MainScreen(),
              '/signup': (context) => const SignupScreen(),
            },
          );
        },
      ),
    );
  }
}

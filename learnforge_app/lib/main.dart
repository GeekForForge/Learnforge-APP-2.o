import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Hive with error handling
    await _initializeHive();

    runApp(const ProviderScope(child: LearnForgeApp()));
  } catch (error, stackTrace) {
    // Handle initialization errors gracefully
    _handleInitializationError(error, stackTrace);
  }
}

class LearnForgeApp extends StatelessWidget {
  const LearnForgeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LearnForge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Force dark theme as per your design
      // Router configuration
      routerConfig: appRouter,

      // Additional customization
      restorationScopeId: 'learn_forge_app',

      // Global error handling for the MaterialApp
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Ensure consistent text scaling
            textScaleFactor: MediaQuery.of(
              context,
            ).textScaleFactor.clamp(0.8, 1.2),
          ),
          child: child!,
        );
      },
    );
  }
}

// Hive initialization with error handling
Future<void> _initializeHive() async {
  await Hive.initFlutter();

  // Optional: Register Hive adapters if you have any
  // Hive.registerAdapter(YourModelAdapter());

  // Optional: Open default box
  // await Hive.openBox('app_data');
}

// Error handling for initialization failures
void _handleInitializationError(dynamic error, StackTrace stackTrace) {
  // Log the error (in production, use a proper logging service)
  debugPrint('App initialization failed: $error');
  debugPrint('Stack trace: $stackTrace');

  // In a real app, you might want to show an error screen
  // or fallback to a basic app without Hive
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'App Initialization Failed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Please restart the application. If the problem persists, contact support.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

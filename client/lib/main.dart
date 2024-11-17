import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling any asynchronous code
  WidgetsFlutterBinding.ensureInitialized();

  // Create a provider container for managing state and dependencies
  final container = ProviderContainer();

  // Read the AuthViewModel notifier from the container
  final AuthViewModel notifier = container.read(authViewModelProvider.notifier);

  // Initialize shared preferences and fetch user data asynchronously
  await notifier.initSharedPreferences();
  await notifier.getUserData();

  // Run the app with an uncontrolled provider scope to manage the container
  runApp(UncontrolledProviderScope(
    container: container, // Pass the container to the app's widget tree
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the currentUserNotifierProvider to get the current user state
    final currentUser = ref.watch(currentUserNotifierProvider);

    return MaterialApp(
      title: 'Spotify Clone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      // Conditionally display the SignupPage or HomePage based on whether a user is logged in
      home: currentUser == null ? const SignupPage() : const HomePage(),
    );
  }
}

import 'package:auth_demo/branding_screen.dart';
import 'package:auth_demo/home_screen.dart';
import 'package:auth_demo/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'avatar_selection_screen.dart';
import 'login_page.dart';
import 'secrets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: Secrets.supabaseUrl,
    anonKey: Secrets.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // Check initial authentication state
    _isLoggedIn = Supabase.instance.client.auth.currentSession != null;

    // Listen for auth state changes (e.g., after OAuth login)
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      setState(() {
        _isLoggedIn = session != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // If user is logged in, show AvatarSelectionScreen. Otherwise, show BrandingScreen.
      home: _isLoggedIn
          ? const AvatarSelectionScreen()  // <--- your new flow
          : const BrandingScreen(),
    );
  }

}

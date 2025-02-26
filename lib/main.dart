import 'package:auth_demo/branding_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'secrets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Debugging: Print Supabase credentials (DO NOT DO THIS IN PRODUCTION)
  print("✅ Supabase URL: ${Secrets.supabaseUrl}");

  // Initialize Supabase
  await Supabase.initialize(
    url: Secrets.supabaseUrl,
    anonKey: Secrets.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BrandingScreen(),
    );
  }
}

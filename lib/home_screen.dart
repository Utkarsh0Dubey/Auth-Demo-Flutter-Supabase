import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the current session
    final session = Supabase.instance.client.auth.currentSession;
    // Extract the email or show a fallback message if null
    final email = session?.user?.email ?? 'No email found';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              // Optionally, add navigation logic here if needed.
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Logged in as: $email',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

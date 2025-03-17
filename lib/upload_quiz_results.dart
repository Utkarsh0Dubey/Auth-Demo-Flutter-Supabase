import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'secrets.dart'; // Contains your Supabase URL and anon key

class UploadQuizResultsScreen extends StatefulWidget {
  final Map<String, dynamic> answers;
  final String selectedAvatar;

  const UploadQuizResultsScreen({
    Key? key,
    required this.answers,
    required this.selectedAvatar,
  }) : super(key: key);

  @override
  State<UploadQuizResultsScreen> createState() => _UploadQuizResultsScreenState();
}

class _UploadQuizResultsScreenState extends State<UploadQuizResultsScreen> {
  bool _isLoading = true;
  String _message = 'Uploading quiz results...';

  @override
  void initState() {
    super.initState();
    _uploadResults();
  }

  Future<void> _uploadResults() async {
    final supabase = Supabase.instance.client;
    final quizData = widget.answers; // Adjust structure as needed
    final response = await supabase.from('quiz_responses').insert({
      'user_id': supabase.auth.currentUser?.id, // if linking to a user
      'selected_avatar': widget.selectedAvatar,
      'answers': quizData,
    });
    if (response.error == null) {
      setState(() {
        _isLoading = false;
        _message = 'Quiz submitted successfully!';
      });
    } else {
      setState(() {
        _isLoading = false;
        _message = 'Error: ${response.error!.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submitting Quiz'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _message,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // For example, pop back to a home screen or branding screen
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text('OK'),
            )
          ],
        ),
      ),
    );
  }
}

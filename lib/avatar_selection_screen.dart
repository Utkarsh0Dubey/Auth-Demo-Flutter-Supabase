import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class AvatarSelectionScreen extends StatefulWidget {
  const AvatarSelectionScreen({Key? key}) : super(key: key);

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen> {
  String? selectedAvatar;

  // A set of cartoon avatars with faces
  // (These URLs are from Flaticon - you can change to any other icons you prefer)
  final List<String> cartoonAvatars = [
    'https://cdn-icons-png.flaticon.com/512/4333/4333609.png',
    'https://cdn-icons-png.flaticon.com/512/4333/4333600.png',
    'https://cdn-icons-png.flaticon.com/512/4333/4333628.png',
    'https://cdn-icons-png.flaticon.com/512/4333/4333631.png',
    'https://cdn-icons-png.flaticon.com/512/4333/4333622.png',
    'https://cdn-icons-png.flaticon.com/512/4333/4333614.png',
    'https://cdn-icons-png.flaticon.com/512/4333/4333621.png',
    'https://cdn-icons-png.flaticon.com/512/4333/4333613.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Avatar'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildAvatarGrid(cartoonAvatars),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedAvatar != null ? _onContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text('Continue'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvatarGrid(List<String> avatars) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: avatars.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,   // 2 columns
        childAspectRatio: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final avatar = avatars[index];
        final isSelected = avatar == selectedAvatar;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedAvatar = avatar;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.amber, width: 4)
                  : null,
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(avatar),
            ),
          ),
        );
      },
    );
  }

  void _onContinue() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(selectedAvatar: selectedAvatar!),
      ),
    );
  }
}

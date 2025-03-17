import 'package:flutter/material.dart';
import 'upload_quiz_results.dart';

class QuizScreen extends StatefulWidget {
  final String selectedAvatar;
  const QuizScreen({Key? key, required this.selectedAvatar}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  final Map<String, dynamic> _answers = {};
  int _currentPage = 0;

  void _goToNextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishQuiz() {
    // Instead of a congratulatory dialog, navigate to the upload screen.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UploadQuizResultsScreen(
          answers: _answers,
          selectedAvatar: widget.selectedAvatar,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legendary Quiz'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.selectedAvatar),
          ),
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          GettingToKnowYouPage(answers: _answers),
          GettingToKnowYourHousePage(answers: _answers),
          GettingToKnowYourDevicesPage(answers: _answers, onFinish: _finishQuiz),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.green.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage > 0)
              ElevatedButton(
                onPressed: _goToPreviousPage,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                child: const Text('Previous'),
              )
            else
              const SizedBox(width: 100),
            if (_currentPage < 2)
              ElevatedButton(
                onPressed: _goToNextPage,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                child: const Text('Next'),
              )
            else
              ElevatedButton(
                onPressed: _finishQuiz,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                child: const Text('Finish'),
              ),
          ],
        ),
      ),
    );
  }
}

/// ------------------------
/// Section 1: Getting to Know You
/// ------------------------
class GettingToKnowYouPage extends StatefulWidget {
  final Map<String, dynamic> answers;
  const GettingToKnowYouPage({Key? key, required this.answers}) : super(key: key);

  @override
  State<GettingToKnowYouPage> createState() => _GettingToKnowYouPageState();
}

class _GettingToKnowYouPageState extends State<GettingToKnowYouPage> {
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD0F0C0), Color(0xFFFFF8E1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Getting to Know You', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text('What is your full name?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              onChanged: (val) => widget.answers['fullName'] = val,
              decoration: InputDecoration(
                hintText: 'Enter your full name',
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Text('What is your age?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              onChanged: (val) => widget.answers['age'] = int.tryParse(val) ?? 0,
              decoration: InputDecoration(
                hintText: 'Enter your age',
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Are you tech-savvy?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Yes'),
                  selected: widget.answers['techSavvy'] == true,
                  onSelected: (selected) {
                    setState(() {
                      widget.answers['techSavvy'] = true;
                    });
                  },
                ),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text('No'),
                  selected: widget.answers['techSavvy'] == false,
                  onSelected: (selected) {
                    setState(() {
                      widget.answers['techSavvy'] = false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------------
/// Section 2: Getting to Know Your House
/// ------------------------
class GettingToKnowYourHousePage extends StatefulWidget {
  final Map<String, dynamic> answers;
  const GettingToKnowYourHousePage({Key? key, required this.answers}) : super(key: key);

  @override
  State<GettingToKnowYourHousePage> createState() => _GettingToKnowYourHousePageState();
}

class _GettingToKnowYourHousePageState extends State<GettingToKnowYourHousePage> {
  final TextEditingController _roomsController = TextEditingController();

  @override
  void dispose() {
    _roomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFC8E6C9), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Getting to Know Your House', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text('How many rooms does your house have?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _roomsController,
              keyboardType: TextInputType.number,
              onChanged: (val) => widget.answers['numRooms'] = int.tryParse(val) ?? 0,
              decoration: InputDecoration(
                hintText: 'Enter number of rooms',
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Text('What is the primary color of your house?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                _colorChip('Red'),
                _colorChip('Blue'),
                _colorChip('Green'),
                _colorChip('White'),
                _colorChip('Yellow'),
              ],
            ),
            const SizedBox(height: 16),
            Text('Do you have a garden?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Yes'),
                  selected: widget.answers['hasGarden'] == true,
                  onSelected: (selected) {
                    setState(() {
                      widget.answers['hasGarden'] = true;
                    });
                  },
                ),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text('No'),
                  selected: widget.answers['hasGarden'] == false,
                  onSelected: (selected) {
                    setState(() {
                      widget.answers['hasGarden'] = false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorChip(String colorName) {
    return ChoiceChip(
      label: Text(colorName),
      selected: widget.answers['houseColor'] == colorName,
      onSelected: (selected) {
        setState(() {
          widget.answers['houseColor'] = selected ? colorName : widget.answers['houseColor'];
        });
      },
    );
  }
}

/// ------------------------
/// Section 3: Getting to Know Your Devices
/// ------------------------
class GettingToKnowYourDevicesPage extends StatefulWidget {
  final Map<String, dynamic> answers;
  final VoidCallback onFinish;
  const GettingToKnowYourDevicesPage({Key? key, required this.answers, required this.onFinish}) : super(key: key);

  @override
  State<GettingToKnowYourDevicesPage> createState() => _GettingToKnowYourDevicesPageState();
}

class _GettingToKnowYourDevicesPageState extends State<GettingToKnowYourDevicesPage> {
  final TextEditingController _tvsController = TextEditingController();
  final TextEditingController _smartphonesController = TextEditingController();

  @override
  void dispose() {
    _tvsController.dispose();
    _smartphonesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDCEDC8), Color(0xFFFFFDE7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Getting to Know Your Devices', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text('How many TVs do you have?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _tvsController,
              keyboardType: TextInputType.number,
              onChanged: (val) => widget.answers['numTVs'] = int.tryParse(val) ?? 0,
              decoration: InputDecoration(
                hintText: 'Enter number of TVs',
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Text('How many smartphones do you own?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _smartphonesController,
              keyboardType: TextInputType.number,
              onChanged: (val) => widget.answers['numSmartphones'] = int.tryParse(val) ?? 0,
              decoration: InputDecoration(
                hintText: 'Enter number of smartphones',
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Which brand of laptop do you use most?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              onChanged: (val) => widget.answers['laptopBrand'] = val,
              decoration: InputDecoration(
                hintText: 'e.g., Apple, Dell, HP, etc.',
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: widget.onFinish,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Finish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

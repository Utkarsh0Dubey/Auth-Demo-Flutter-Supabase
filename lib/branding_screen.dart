import 'package:flutter/material.dart';
import 'login_page.dart';

class BrandingScreen extends StatelessWidget {
  const BrandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyApp1());
  }
}

class MyApp1 extends StatefulWidget {
  const MyApp1({super.key});

  @override
  State<MyApp1> createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  @override
  void initState() {
    super.initState();
    // Navigate to the LoginScreen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSasNL92m6UIno6h69DOOOvAFAVidnMlVkNrmwIINL8CKRw4x1O7z1kg1stUBbeKX8S8Ic&usqp=CAU',
            ),
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ' N o v a L u m e  ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '  Power, Perfected ',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

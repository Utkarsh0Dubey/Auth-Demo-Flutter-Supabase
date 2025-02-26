import 'package:flutter/material.dart';
// Import supabase_flutter for both Supabase class and Provider
import 'package:supabase_flutter/supabase_flutter.dart';
import 'sign_up.dart';

// Simple HomeScreen to navigate to after successful login
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: const Center(
        child: Text(
          'Light Up Your Home!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  // Toggle show/hide password
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Normal Email/Password login
  Future<void> _login() async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // In supabase_flutter >=1.9.1, AuthResponse provides .user, .session, etc.
      if (response.session != null) {
        // Show success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
        // Navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        // If session is null, login likely failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please check credentials.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Don't resize the widget when keyboard appears
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSasNL92m6UIno6h69DOOOvAFAVidnMlVkNrmwIINL8CKRw4x1O7z1kg1stUBbeKX8S8Ic&usqp=CAU',
                  ),
                ),
              ),
            ),
          ),

          // Foreground scrollable content
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              padding: const EdgeInsets.only(top: 220, left: 40, right: 40),
              child: Column(
                children: [
                  // Title
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Email Field
                  _buildTextField(
                    label: 'Email',
                    icon: Icons.email,
                    hint: 'Enter your Email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 30),

                  // Password Field
                  _buildPasswordField(
                    label: 'Password',
                    icon: Icons.key,
                    hint: 'Enter your Password',
                    controller: _passwordController,
                  ),

                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        // Forgot Password logic
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // LOGIN button
                  _buildLoginButton(),

                  const SizedBox(height: 35),

                  // Sign Up prompt
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Elevated Sign Up Button
                  _buildSignUpButton(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------
  // Below are the helper widgets needed by the build()
  // ------------------------------------------------------

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 5,
          ),
        ),
        prefixIcon: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: _obscureText,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 5,
          ),
        ),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
            size: 20,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return InkWell(
      splashColor: Colors.black,
      onTap: _login,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 100,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Text(
          'LOGIN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

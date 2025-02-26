import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _signUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign Up Successful! Please log in.')),
        );
        Navigator.of(context).pop(); // Go back to login screen
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Up Failed: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 150, left: 40, right: 40),
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSasNL92m6UIno6h69DOOOvAFAVidnMlVkNrmwIINL8CKRw4x1O7z1kg1stUBbeKX8S8Ic&usqp=CAU',
            ),
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            const Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField('Name', Icons.person, 'Enter your Name', _nameController),
            const SizedBox(height: 20),
            _buildTextField('Email', Icons.email, 'Enter your Email', _emailController),
            const SizedBox(height: 20),
            _buildPasswordField('Password', Icons.lock, 'Enter your Password', _passwordController),
            const SizedBox(height: 50),
            _buildSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 5),
        ),
        prefixIcon: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildPasswordField(String label, IconData icon, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: _obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 5),
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

  Widget _buildSignUpButton() {
    return InkWell(
      splashColor: Colors.black,
      onTap: _isLoading ? null : _signUp,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text(
          'SIGN UP',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }
}

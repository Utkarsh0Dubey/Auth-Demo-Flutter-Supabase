import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'sign_up.dart';
// 1) Import the new AvatarSelectionScreen
import 'avatar_selection_screen.dart';

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

      if (response.session != null) {
        // Show success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
        // Navigate to AvatarSelectionScreen instead of QuizScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AvatarSelectionScreen()),
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

  // Google OAuth login
  Future<void> _loginWithGoogle() async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'authdemo://login-callback',
      );

      // Listen for auth state changes and redirect to AvatarSelectionScreen
      supabase.auth.onAuthStateChange.listen((data) {
        final session = data.session;
        if (session != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AvatarSelectionScreen()),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Login Failed: $e')),
      );
    }
  }

  // Facebook OAuth login
  Future<void> _loginWithFB() async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'authdemo://login-callback',
      );

      // Listen for auth state changes and redirect to AvatarSelectionScreen
      supabase.auth.onAuthStateChange.listen((data) {
        final session = data.session;
        if (session != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AvatarSelectionScreen()),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Facebook Login Failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Don't resize when keyboard appears
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
                  const SizedBox(height: 20),

                  // GOOGLE button
                  _buildGoogleLoginButton(),
                  const SizedBox(height: 20),

                  // FACEBOOK button
                  _buildTwitterLoginButton(),
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
  // Helper widgets
  // ------------------------------------------------------

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
  }) {
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

  Widget _buildPasswordField({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
  }) {
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

  Widget _buildLoginButton() {
    return InkWell(
      splashColor: Colors.black,
      onTap: _login,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
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

  // Google Login Button
  Widget _buildGoogleLoginButton() {
    return InkWell(
      splashColor: Colors.black,
      onTap: _loginWithGoogle,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(width: 10),
            Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Facebook Login Button
  Widget _buildTwitterLoginButton() {
    return InkWell(
      splashColor: Colors.black,
      onTap: _loginWithFB,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(width: 10),
            Text(
              'Sign in with Facebook',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

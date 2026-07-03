import 'package:child_record/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/app_logo.dart';
import 'dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _signInWithEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authService = Provider.of<AuthService>(context, listen: false);
      try {
        await authService.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        // Navigation is handled by the StreamBuilder in main.dart
      } on FirebaseAuthException catch (e) {
        final snackBar = SnackBar(
          content: Text(e.message ?? 'An error occurred'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithGoogle();
      // Navigation is now handled by the StreamBuilder in main.dart
    } catch (e) {
      // Handle error, maybe show a snackbar
      final snackBar = SnackBar(
        content: Text('Error signing in: $e'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppLogo(size: 120),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue managing child health records.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.blue[600],
                          ),
                    ),
                    const SizedBox(height: 48),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: 'Email'),
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter an email' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter a password' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              ElevatedButton(
                                onPressed: _signInWithEmail,
                                child: const Text('Login'),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _signInWithGoogle,
                                icon: SvgPicture.asset(
                                  'assets/images/google_logo.svg',
                                  height: 24,
                                ),
                                label: const Text('Sign in with Google'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const RegistrationScreen()),
                      ),
                      child: const Text('Don\'t have an account? Register'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:final_project/features/auth/presentation/pages/auth_services.dart';
import 'package:final_project/core/widgets/my_button.dart';
import 'package:final_project/core/widgets/my_divider.dart';
import 'package:final_project/core/widgets/my_textfield.dart';
import 'package:final_project/core/widgets/rectangle_tile.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  // text editing controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void login(BuildContext context) {
    Navigator.pushNamed(context, 'loginpage');
  }

  // Method to validate inputs
  String? validateInputs() {
    if (_usernameController.text.isEmpty) {
      return "Username cannot be empty";
    }
    if (_emailController.text.isEmpty) {
      return "Email cannot be empty";
    }
    // Simple regex for email validation
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(_emailController.text)) {
      return "Please enter a valid email address";
    }
    if (_passwordController.text.isEmpty) {
      return "Password cannot be empty";
    }
    if (_passwordController.text.length < 6) {
      return "Password must be at least 6 characters long";
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      return "Passwords do not match";
    }
    return null; // All validations passed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                "Sign up with",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontSize: 15,
                    fontFamily: 'Poppins-Regular',
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const RectangleTile(
                imagePath: 'lib/assets/images/google_logo_icon.png',
                buttonText: "Google",
              ),
              const SizedBox(height: 17),
              const MyDivider(),
              const SizedBox(height: 17),
              MyTextField(
                controller: _usernameController,
                labelText: "Username",
                hintText: "e.g. johndoe1",
              ),
              const SizedBox(height: 17),
              MyTextField(
                controller: _emailController,
                labelText: "Email",
                hintText: "e.g. johndoe1@gmail.com",
              ),
              const SizedBox(height: 17),
              MyTextField(
                controller: _passwordController,
                obscureText: true,
                labelText: "Password",
                hintText: "Enter your password",
              ),
              const SizedBox(height: 17),
              MyTextField(
                controller: _confirmPasswordController,
                obscureText: true,
                labelText: "Confirm Password",
                hintText: "Repeat your password",
              ),
              const SizedBox(height: 17),
              MyButton(
                backgroundColor: Colors.teal,
                buttonText: "Sign up",
                textColor: Theme.of(context).colorScheme.surface,
                onPressed: () async {
                  String? validationMessage = validateInputs();
                  if (validationMessage != null) {
                    // Show validation error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(validationMessage)),
                    );
                  } else {
                    // Proceed with sign up
                    await AuthServices().signUp(
                      context: context,
                      username: _usernameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      confirmPassword: _confirmPasswordController.text,
                    );
                    _usernameController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                    Navigator.pushNamed(context, 'loginpage');
                  }
                },
              ),
              const SizedBox(height: 17),
              MyButton(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                buttonText: "Already have an account? Log in",
                textColor: Theme.of(context).colorScheme.inverseSurface,
                onPressed: () {
                  login(context);
                },
              ),
              const SizedBox(height: 17),
            ],
          )),
        ),
      ),
    );
  }
}

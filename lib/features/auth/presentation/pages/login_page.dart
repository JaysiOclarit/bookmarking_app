import 'package:final_project/features/auth/presentation/pages/auth_services.dart';
import 'package:final_project/core/widgets/my_button.dart';
import 'package:final_project/core/widgets/my_divider.dart';
import 'package:final_project/core/widgets/my_textfield.dart';
import 'package:final_project/core/widgets/rectangle_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;

  // text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? validateInputs() {
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

    return null; // All validations passed
  }

  void signUp(BuildContext context) {
    // This is where you would put your sign up logic
    Navigator.pushNamed(context, 'signuppage');
  }

  Future<void> login(BuildContext context) async {
    // Show loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Attempt to sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // If successful, navigate to the homepage
      Navigator.pushReplacementNamed(context, 'homepage');
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      // Handle specific Firebase authentication exceptions
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided for that user.";
      } else {
        errorMessage = "An error occurred. Please try again.";
      }

      // Debugging print statement
      print("Error occurred: $errorMessage");

      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      // Hide the loading circle
      Navigator.pop(context);
    }
  }

  void forgetPassword() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              // Text Sign up with
              Text(
                "Log in with",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontSize: 15,
                    fontFamily: 'Poppins-Regular',
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(
                height: 15,
              ),
              // Google button
              const RectangleTile(
                imagePath: 'assets/images/google_logo_icon.png',
                buttonText: "Google",
              ),
              const SizedBox(
                height: 17,
              ),

              //divider with text "OR" in the middle
              const MyDivider(),

              const SizedBox(
                height: 17,
              ),

              //email label and textfield
              MyTextField(
                controller: _emailController,
                labelText: "Email",
                hintText: "e.g. johndoe1@gmail.com",
              ),
              const SizedBox(
                height: 17,
              ),

              //password label and textfield
              MyTextField(
                controller: _passwordController,
                obscureText: true,
                labelText: "Password",
                hintText: "Enter your password",
              ),
              const SizedBox(
                height: 10,
              ),

              // remember me checkbox and forgot password text
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Remember me
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                          activeColor: Colors.teal,
                          checkColor: Colors.white,
                        ),
                        Text(
                          "Remember me",
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        )
                      ],
                    ),

                    // Forgot Password
                    TextButton(
                      onPressed: forgetPassword,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontFamily: 'Poppins-Medium',
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 17,
              ),

              //Login button
              MyButton(
                  backgroundColor: Colors.teal,
                  buttonText: "Log in",
                  textColor: Theme.of(context).colorScheme.surface,
                  onPressed: () async {
                    String? validationMessage = validateInputs();
                    if (validationMessage != null) {
                      // Show validation error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(validationMessage)),
                      );
                    } else {
                      await AuthServices().login(
                          email: _emailController.text,
                          password: _passwordController.text,
                          context: context);
                    }
                  }),
              const SizedBox(
                height: 17,
              ),

              //Don't have an account yet? Sign up button
              MyButton(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                buttonText: "Don't have an account yet? Sign up",
                textColor: Theme.of(context).colorScheme.inverseSurface,
                onPressed: () {
                  signUp(context);
                },
              ),
              const SizedBox(
                height: 17,
              ),
            ],
          ),
        ),
      )),
    );
  }
}

import 'package:final_project/features/auth/presentation/pages/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _logout(BuildContext context) async {
    AuthServices authService =
        AuthServices(); // Create an instance of AuthService
    await authService.signOut(context: context);
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('User  Profile'),
            const SizedBox(height: 20),
            // Display the user's name if available
            if (user != null) ...[
              Text(
                'Welcome, ${user.displayName ?? user.email ?? "User "}!',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text(
                'Logout',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontFamily: 'Poppins-Bold',
                    fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

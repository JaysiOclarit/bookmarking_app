import 'package:final_project/features/auth/presentation/pages/auth_page.dart';
import 'package:final_project/features/bookmarks/presentation/pages/add_bookmark_page.dart';
import 'package:final_project/features/bookmarks/presentation/pages/collection_detail_page.dart';
import 'package:final_project/features/bookmarks/presentation/pages/edit_bookmark_page.dart';
import 'package:final_project/features/bookmarks/presentation/pages/home_page.dart';
import 'package:final_project/features/auth/presentation/pages/login_page.dart';
import 'package:final_project/features/auth/presentation/pages/sign_up_page.dart';
import 'package:final_project/features/bookmarks/presentation/pages/tab_bar_page.dart';
import 'package:final_project/core/theme/theme_provider.dart';
import 'package:final_project/core/utils/bookmarks/bookmark_provider.dart';
import 'package:final_project/features/bookmarks/presentation/pages/tab_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
            create: (context) => BookmarkProvider()..fetchBookmarks()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
        theme: Provider.of<ThemeProvider>(context).themeData,
        routes: {
          'loginpage': (context) => const LoginPage(),
          'signuppage': (context) => SignUpPage(),
          'homepage': (context) => HomePage(),
          'addbookmarkpage': (context) => AddBookmarkPage(),
          'tabbarpage': (context) => TabBarPage(),
          'editbookmarkpage': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return EditBookmarkPage(
              bookmarkId: args['bookmarkId'],
              collection: args['collection'],
            );
          },
        });
  }
}

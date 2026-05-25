import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'package:lumiere_flow/features/auth/presentation/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: LumiereApp()));
}

class LumiereApp extends StatelessWidget {
  const LumiereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lumière Flow',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Georgia',
      ),
      home: const AuthPage(),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/startup_page.dart';
import 'app/theme/app_theme.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FirebaseStartup());
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
}

class FirebaseStartup extends StatefulWidget {
  const FirebaseStartup({super.key, this.initialize = _initializeFirebase});

  final Future<void> Function() initialize;

  @override
  State<FirebaseStartup> createState() => _FirebaseStartupState();
}

class _FirebaseStartupState extends State<FirebaseStartup> {
  late Future<void> _initialization = widget.initialize();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(theme: AppTheme.light, home: const StartupPage());
        }
        if (snapshot.hasError) {
          return MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Não foi possível iniciar o ÁguaViva.'),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    FilledButton(
                      onPressed: () => setState(() {
                        _initialization = widget.initialize();
                      }),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const AguaVivaApp();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/router_provider.dart';
import 'providers/config_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: CreemosApp()));
}

class CreemosApp extends ConsumerWidget {
  const CreemosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final config = ref.watch(appConfigProvider);

    return MaterialApp.router(
      title: 'Creemos Santa Cruz',
      debugShowCheckedModeBanner: false,
      theme: config.toThemeData(),
      routerConfig: router,
    );
  }
}

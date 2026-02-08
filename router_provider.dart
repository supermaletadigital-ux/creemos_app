import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/acuerdo_screen.dart';
import '../screens/registro_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/news_feed_screen.dart';
import '../screens/admin_panel_screen.dart';
import '../screens/patria_asesora_screen.dart';
import '../screens/militantes_screen.dart';
import 'auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/acuerdo',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoginPage = state.matchedLocation == '/login';
      final isAcuerdoPage = state.matchedLocation == '/acuerdo';
      final isRegistroPage = state.matchedLocation == '/registro';

      // Permitir acceso a páginas públicas sin autenticación
      if (isAcuerdoPage || isRegistroPage) {
        return null;
      }

      if (!isLoggedIn && !isLoginPage) {
        return '/login';
      }
      
      if (isLoggedIn && isLoginPage) {
        return '/';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/acuerdo',
        builder: (context, state) => const AcuerdoScreen(),
      ),
      GoRoute(
        path: '/registro',
        builder: (context, state) => const RegistroScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/news',
        builder: (context, state) => const NewsFeedScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminPanelScreen(),
      ),
      GoRoute(
        path: '/legal',
        builder: (context, state) => const PatriaAsesoraScreen(),
      ),
      GoRoute(
        path: '/militantes',
        builder: (context, state) => const MilitantesScreen(),
      ),
    ],
  );
});

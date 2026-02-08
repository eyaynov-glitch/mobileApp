import 'package:go_router/go_router.dart';

import '../features/auth/auth_screen.dart';
import '../features/dashboard/student/student_dashboard.dart';
import '../features/splash/splash_screen.dart';

final GoRouter campusRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/student',
      builder: (context, state) => const StudentDashboardScreen(),
    ),
  ],
);

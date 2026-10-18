import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/account.dart';
import 'screens/auth.dart';
import 'screens/booking.dart';
import 'screens/explore.dart';
import 'screens/main_shell.dart';

Page<T> _buildTransition<T>({required BuildContext context, required GoRouterState state, required Widget child}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.04),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
      );
    },
  );
}

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const SplashScreen())),
  GoRoute(path: '/onboarding', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const OnboardingScreen())),
  GoRoute(path: '/login', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const LoginScreen())),
  GoRoute(path: '/signup', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const SignupScreen())),
  GoRoute(path: '/forgot', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const ForgotScreen())),
  GoRoute(path: '/otp', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: OtpScreen(next: s.uri.queryParameters['next'] ?? '/home'))),
  GoRoute(path: '/newpass', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const NewPasswordScreen())),
  GoRoute(path: '/reset-done', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const ResetDoneScreen())),
  GoRoute(path: '/home', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const MainShell())),
  GoRoute(path: '/areas', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const AreasScreen())),
  GoRoute(path: '/offers', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const OffersScreen())),
  GoRoute(path: '/search', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: SearchScreen(q: s.uri.queryParameters['q'] ?? '', filters: s.uri.queryParameters['filters'] == '1'))),
  GoRoute(path: '/map', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const MapScreen())),
  GoRoute(path: '/stay/:id', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: DetailsScreen(id: s.pathParameters['id']!))),
  GoRoute(path: '/gallery/:id', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: GalleryScreen(id: s.pathParameters['id']!))),
  GoRoute(path: '/reviews/:id', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: ReviewsScreen(id: s.pathParameters['id']!))),
  GoRoute(path: '/write-review/:id', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: WriteReviewScreen(id: s.pathParameters['id']!))),
  GoRoute(path: '/review-done', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const ReviewDoneScreen())),
  GoRoute(path: '/rooms/:id', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: RoomsScreen(id: s.pathParameters['id']!))),
  GoRoute(path: '/booking', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const BookingScreen())),
  GoRoute(path: '/confirmed', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const ConfirmedScreen())),
  GoRoute(path: '/pay-failed', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const PayFailedScreen())),
  GoRoute(path: '/payments', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const PaymentsScreen())),
  GoRoute(path: '/add-card', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const AddCardScreen())),
  GoRoute(path: '/booking/:id', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: BookingDetailsScreen(id: s.pathParameters['id']!))),
  GoRoute(path: '/change-dates/:id', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: ChangeDatesScreen(id: s.pathParameters['id']!))),
  GoRoute(path: '/edit-profile', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const EditProfileScreen())),
  GoRoute(path: '/settings', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const SettingsScreen())),
  GoRoute(path: '/terms', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const DocScreen(title: 'Terms of service', items: termsItems))),
  GoRoute(path: '/privacy', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const DocScreen(title: 'Privacy policy', items: privacyItems))),
  GoRoute(path: '/help', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const HelpScreen())),
  GoRoute(path: '/chat', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const ChatScreen())),
  GoRoute(path: '/notifications', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const NotificationsScreen())),
  GoRoute(path: '/offline', pageBuilder: (c, s) => _buildTransition(context: c, state: s, child: const OfflineScreen())),
]);

import 'package:go_router/go_router.dart';
import 'screens/account.dart';
import 'screens/auth.dart';
import 'screens/booking.dart';
import 'screens/explore.dart';
import 'screens/main_shell.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
  GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
  GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
  GoRoute(path: '/signup', builder: (c, s) => const SignupScreen()),
  GoRoute(path: '/forgot', builder: (c, s) => const ForgotScreen()),
  GoRoute(path: '/otp', builder: (c, s) => OtpScreen(next: s.uri.queryParameters['next'] ?? '/home')),
  GoRoute(path: '/newpass', builder: (c, s) => const NewPasswordScreen()),
  GoRoute(path: '/reset-done', builder: (c, s) => const ResetDoneScreen()),
  GoRoute(path: '/home', builder: (c, s) => const MainShell()),
  GoRoute(path: '/areas', builder: (c, s) => const AreasScreen()),
  GoRoute(path: '/offers', builder: (c, s) => const OffersScreen()),
  GoRoute(path: '/search', builder: (c, s) => SearchScreen(q: s.uri.queryParameters['q'] ?? '', filters: s.uri.queryParameters['filters'] == '1')),
  GoRoute(path: '/map', builder: (c, s) => const MapScreen()),
  GoRoute(path: '/stay/:id', builder: (c, s) => DetailsScreen(id: s.pathParameters['id']!)),
  GoRoute(path: '/gallery/:id', builder: (c, s) => GalleryScreen(id: s.pathParameters['id']!)),
  GoRoute(path: '/reviews/:id', builder: (c, s) => ReviewsScreen(id: s.pathParameters['id']!)),
  GoRoute(path: '/write-review/:id', builder: (c, s) => WriteReviewScreen(id: s.pathParameters['id']!)),
  GoRoute(path: '/review-done', builder: (c, s) => const ReviewDoneScreen()),
  GoRoute(path: '/rooms/:id', builder: (c, s) => RoomsScreen(id: s.pathParameters['id']!)),
  GoRoute(path: '/booking', builder: (c, s) => const BookingScreen()),
  GoRoute(path: '/confirmed', builder: (c, s) => const ConfirmedScreen()),
  GoRoute(path: '/pay-failed', builder: (c, s) => const PayFailedScreen()),
  GoRoute(path: '/payments', builder: (c, s) => const PaymentsScreen()),
  GoRoute(path: '/add-card', builder: (c, s) => const AddCardScreen()),
  GoRoute(path: '/booking/:id', builder: (c, s) => BookingDetailsScreen(id: s.pathParameters['id']!)),
  GoRoute(path: '/change-dates/:id', builder: (c, s) => ChangeDatesScreen(id: s.pathParameters['id']!)),
  GoRoute(path: '/edit-profile', builder: (c, s) => const EditProfileScreen()),
  GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
  GoRoute(path: '/terms', builder: (c, s) => const DocScreen(title: 'Terms of service', items: termsItems)),
  GoRoute(path: '/privacy', builder: (c, s) => const DocScreen(title: 'Privacy policy', items: privacyItems)),
  GoRoute(path: '/help', builder: (c, s) => const HelpScreen()),
  GoRoute(path: '/chat', builder: (c, s) => const ChatScreen()),
  GoRoute(path: '/notifications', builder: (c, s) => const NotificationsScreen()),
  GoRoute(path: '/offline', builder: (c, s) => const OfflineScreen()),
]);

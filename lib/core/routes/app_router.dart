import 'package:go_router/go_router.dart';

import '../../features/home/home_screen.dart';
import '../../features/stay_details/stay_details_screen.dart';

// Route names / paths in one place so we never hardcode strings in screens.
class AppRoutes {
  AppRoutes._();
  static const home = '/';
  static const stayDetails = '/stay/:id';
  static String stayDetailsPath(String id) => '/stay/$id';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.stayDetails,
      builder: (context, state) =>
          StayDetailsScreen(stayId: state.pathParameters['id']!),
    ),
  ],
);

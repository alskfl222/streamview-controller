import 'package:go_router/go_router.dart';
import '../login.dart';
import '../landing.dart';
import '../viewer/container.dart';
import '../404.dart';

final routerConfig = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/view',
      builder: (context, state) =>
          ViewerPage(uid: state.uri.queryParameters['uid']),
    ),
  ],
  errorBuilder: (context, state) => const UnknownRoutePage(),
);

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:streamview_controller/provider/user.dart';
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
      redirect: (context, state) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (userProvider.status == Status.authenticated) {
          return '/';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingPage(),
      redirect: (context, state) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (userProvider.status != Status.authenticated) {
          return '/login';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/view',
      builder: (context, state) =>
          ViewerPage(uid: state.uri.queryParameters['uid']),
    ),
  ],
  errorBuilder: (context, state) => const UnknownRoutePage(),
);

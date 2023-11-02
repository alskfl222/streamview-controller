import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:streamview_controller/provider/user.dart';
import '../login.dart';
import '../layout.dart';
import '../current/container.dart';
import '../todo/container.dart';
import '../viewer/container.dart';
import '../404.dart';

final routerConfig = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginWidget(),
      redirect: (context, state) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (userProvider.status == Status.authenticated) {
          return '/';
        }
        return null;
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Layout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const CurrentWidget(),
          redirect: (context, state) {
            final userProvider = Provider.of<UserProvider>(context, listen: false);
            if (userProvider.status != Status.authenticated) {
              return '/login';
            }
            return null;
          },
        ),
        GoRoute(
          path: '/todo',
          builder: (context, state) => const TodoWidget(),
          redirect: (context, state) {
            final userProvider = Provider.of<UserProvider>(context, listen: false);
            if (userProvider.status != Status.authenticated) {
              return '/login';
            }
            return null;
          },
        ),
      ],

    ),
    GoRoute(
      path: '/view',
      builder: (context, state) =>
          ViewerPage(uid: state.uri.queryParameters['uid']),
    ),
  ],
  errorBuilder: (context, state) => const UnknownRoutePage(),
);

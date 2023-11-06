import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:streamview_controller/provider/user.dart';
import '../login.dart';
import '../layout.dart';
import '../current/container.dart';
import '../todo/container.dart';
import '../viewer/todo.dart';
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
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
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
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            if (userProvider.status != Status.authenticated) {
              return '/login';
            }
            return null;
          },
        ),
      ],
    ),
    GoRoute(
      path: '/viewer',
      builder: (context, state) => const Layout(child: Placeholder()),
      routes: [
        GoRoute(
          path: 'todo',
          builder: (context, state) {
            final String date = state.uri.queryParameters['date'] ?? '';
            final String uid = state.uri.queryParameters['uid'] ?? '';
            return TodoViewerWidget(date: date, uid: uid);
          },
          redirect: (context, state) {
            final String? date = state.uri.queryParameters['date'];
            // final String uid = state.uri.queryParameters['uid'] ?? '';
            if (date == null || !isValidDateFormat(date)) {
              return '/404';
            }
            // 추가 리다이렉트 조건 검사
            return null;
          },
        ),
      ],
    ),
    GoRoute(
      path: "/404",
      builder: (context, state) => const UnknownRouteWidget(),
    )
  ],
  errorBuilder: (context, state) => const UnknownRouteWidget(),
);

bool isValidDateFormat(String date) {
  try {
    DateFormat('yyyy-MM-dd').parseStrict(date);
    return true;
  } catch (e) {
    return false;
  }
}

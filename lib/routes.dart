import 'package:go_router/go_router.dart';
import 'package:safmobile_portal/views/home_view.dart';
import 'package:safmobile_portal/views/docs_view.dart';
import 'package:safmobile_portal/views/search_result_view.dart';
import 'package:safmobile_portal/views/service_order_view.dart';

class Routes {
  static const String home = 'home';
  static const String docs = 'docs';
  static const String serviceOrder = 'so';
  static const String search = 'search';

  static GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/$docs/:uid/:ticketId',
        name: docs,
        builder: (context, state) => DocsView(
          uid: state.pathParameters['uid'] ?? '',
          ticketId: state.pathParameters['ticketId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/$search',
        name: search,
        builder: (context, state) => ViewSearchResult(
          ticketId: state.uri.queryParameters['ticketId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/$serviceOrder/:uid/:ticketId',
        name: serviceOrder,
        builder: (context, state) => ServiceOrderView(
          ticketId: state.pathParameters['ticketId'] ?? '',
          uid: state.pathParameters['uid'] ?? '',
        ),
      ),
    ],
  );
}

import 'package:go_router/go_router.dart';
import 'package:safmobile_portal/view_home.dart';
import 'package:safmobile_portal/view_invoices.dart';

class Routes {
  static const String home = 'home';
  static const String invoices = 'invoices';
  static const String serviceOrder = 'service';

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
        path: '/$invoices',
        name: invoices,
        builder: (context, state) => const ViewInvoices(),
      )
    ],
  );
}

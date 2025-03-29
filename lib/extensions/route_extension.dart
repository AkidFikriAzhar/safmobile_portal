import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension GoRouteExtension on BuildContext {
  goPush<T>(String route) => kIsWeb ? GoRouter.of(this).goNamed(route) : GoRouter.of(this).pushNamed(route);
}

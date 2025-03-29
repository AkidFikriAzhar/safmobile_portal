import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension GoRouteExtension on BuildContext {
  goPush<T>(
    String route, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    String? fragment,
  }) =>
      kIsWeb
          ? GoRouter.of(this).goNamed(
              route,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
              fragment: fragment,
            )
          : GoRouter.of(this).pushNamed(
              route,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );
}

import 'package:flutter/widgets.dart';

class AppRouter {
  final BuildContext _context;

  AppRouter.of(this._context);

  NavigatorState get _navigator => Navigator.of(_context);

  void clearStack() => _navigator.popUntil((_) => false);

  void pop<T>([T result]) => _navigator.pop(result);
}

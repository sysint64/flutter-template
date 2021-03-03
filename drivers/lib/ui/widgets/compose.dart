import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AppCompose extends StatelessWidget {
  final List<Widget Function(Widget child)> children;
  final Widget child;

  const AppCompose(this.children, {@required this.child});

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    for (final child in children) {
      result = child(result);
    }

    return result;
  }
}

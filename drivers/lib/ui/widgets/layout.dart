import 'package:flutter/material.dart';

class AppWidgetLayout extends StatelessWidget {
  final Widget child;

  const AppWidgetLayout({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      ignoringSemantics: true,
      child: Opacity(
        opacity: 0,
        child: child,
      ),
    );
  }
}

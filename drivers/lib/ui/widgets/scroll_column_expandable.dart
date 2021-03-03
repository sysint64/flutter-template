/// Original solution: https://stackoverflow.com/a/56327933/4626918
import 'package:flutter/material.dart';

class AppScrollColumnExpandable extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final VerticalDirection verticalDirection;
  final TextDirection textDirection;
  final TextBaseline textBaseline;
  final EdgeInsetsGeometry padding;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final ScrollPhysics physics;

  const AppScrollColumnExpandable({
    Key key,
    this.children,
    CrossAxisAlignment crossAxisAlignment,
    MainAxisAlignment mainAxisAlignment,
    VerticalDirection verticalDirection,
    EdgeInsetsGeometry padding,
    this.textDirection,
    this.textBaseline,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.physics,
  })  : crossAxisAlignment = crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.start,
        verticalDirection = verticalDirection ?? VerticalDirection.down,
        padding = padding ?? EdgeInsets.zero,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[const SizedBox(width: double.infinity)];

    if (this.children != null) {
      children.addAll(this.children);
    }

    return LayoutBuilder(
      builder: (context, constraint) => SingleChildScrollView(
        physics: physics,
        child: Padding(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraint.maxHeight - padding.vertical,
            ),
            child: IntrinsicHeight(
              child: SafeArea(
                top: safeAreaTop,
                bottom: safeAreaBottom,
                child: Column(
                  crossAxisAlignment: crossAxisAlignment,
                  mainAxisAlignment: mainAxisAlignment,
                  mainAxisSize: MainAxisSize.max,
                  verticalDirection: verticalDirection,
                  textBaseline: textBaseline,
                  textDirection: textDirection,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

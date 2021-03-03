import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:drivers/log.dart';
import 'package:uuid/uuid.dart';

abstract class ResourceLifecycle<T> {
  void init();

  void dispose();
}

class GetItSingletonResourceLifecycle<T> implements ResourceLifecycle<T> {
  final T _resource;

  GetItSingletonResourceLifecycle(this._resource);

  @override
  void init() {
    try {
      GetIt.instance.unregister<T>();
      log('RESOURCE', 'UNREGISTER RESOURCE $T');
      // ignore: empty_catches
    } catch (e) {}

    GetIt.instance.registerSingleton<T>(_resource);
    log('RESOURCE', 'REGISTER RESOURCE $T');
  }

  @override
  void dispose() {}
}

class GetItResourceLifecycle<T> implements ResourceLifecycle<T> {
  final T _resource;

  GetItResourceLifecycle(this._resource);

  @override
  void init() {
    try {
      GetIt.instance.registerSingleton<T>(_resource);
      log('RESOURCE', 'REGISTER RESOURCE $T');
    } catch (e) {
      GetIt.instance.unregister<T>();
      log('RESOURCE', 'UNREGISTER RESOURCE $T');
      GetIt.instance.registerSingleton<T>(_resource);
      log('RESOURCE', 'REGISTER RESOURCE $T');
    }
  }

  @override
  void dispose() {
    GetIt.instance.unregister<T>();
    log('RESOURCE', 'UNREGISTER RESOURCE $T');
  }
}

class AppResourceScope<T> extends StatefulWidget {
  final Widget child;
  final ResourceLifecycle<T> resource;
  final bool canPop;

  const AppResourceScope({
    @required this.child,
    @required this.resource,
    this.canPop = true,
    Key key,
  }) : super(key: key);

  @override
  _AppResourceScopeState createState() => _AppResourceScopeState();
}

class _NavigatorObserver extends NavigatorObserver {
  final BuildContext context;
  final String routeName;

  _NavigatorObserver(this.context, this.routeName);

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    log('NAVIGATOR_OBSERVER', route.currentResult);
//    if (!_canPop) {
//      Navigator.of(context).pop();
//    }
//
//    if (previousRoute?.isFirst == true) {
//      Navigator.of(context).pop();
//    }
//
//    if (!navigator.canPop()) {
//      log('NAVIGATOR_OBSERVER', 'NAME');
//      _canPop = false;
//      log('NAVIGATOR_OBSERVER', route.currentResult);
//      Navigator.of(context).pop();
//    }
//    log('NAVIGATOR_OBSERVER',log 'POP');
//    log('NAVIGATOR_OBSERVER', previousRoute.isFirst.toString());
//    log('NAVIGATOR_OBSERVER', previousRoute.toString());
//    if (!navigator.canPop()) {
//      log('RESULT', route.currentResult.toString());
//      Navigator.of(context).pop(route.currentResult);
//    }
//    if (route.isFirst) {
//      Navigator.of(context).pop();
//    }
  }
}

// ignore: unused_element
class _AppExperimentalResourceScopeState extends State<AppResourceScope> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  _NavigatorObserver _navigatorObserver;
  String _routeName;

  @override
  void initState() {
    super.initState();
    widget.resource.init();
    _routeName = Uuid().v4();
    _navigatorObserver = _NavigatorObserver(context, _routeName);
  }

  @override
  void dispose() {
    widget.resource.dispose();
    super.dispose();
  }

  Future<bool> _backPressed() async {
    if (_navigatorKey.currentState.canPop()) {
      await _navigatorKey.currentState.maybePop();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backPressed,
      child: Navigator(
        key: _navigatorKey,
        onPopPage: (route, result) {
          log('NAVIGATOR', 'POP');
          Navigator.of(context).pop(result);
          return true;
        },
        observers: <NavigatorObserver>[_navigatorObserver],
        onGenerateRoute: (_) => _ResourceRoute(
          canPop: widget.canPop,
          builder: (_) => widget.child,
        ),
      ),
    );
  }
}

class _AppResourceScopeState extends State<AppResourceScope> {
  @override
  void initState() {
    super.initState();
    widget.resource.init();
  }

  @override
  void dispose() {
    widget.resource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _ResourceRoute<T> extends MaterialPageRoute<T> {
  @override
  final bool canPop;

  _ResourceRoute({
    @required builder,
    @required this.canPop,
    RouteSettings settings,
    maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Future<RoutePopDisposition> willPop() async {
    if (canPop) {
      return RoutePopDisposition.pop;
    } else {
      return super.willPop();
    }
  }
}

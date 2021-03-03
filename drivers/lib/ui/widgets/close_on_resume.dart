import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CloseOnResume<T> extends StatefulWidget {
  final Widget child;
  final T result;

  const CloseOnResume({Key key, this.child, this.result}) : super(key: key);

  @override
  _CloseOnResumeState<T> createState() => _CloseOnResumeState<T>();
}

class _CloseOnResumeState<T> extends State<CloseOnResume<T>> {
  _LifecycleObserver _lifecycleObserver;
  bool _popped = false;

  @override
  void initState() {
    super.initState();

    _lifecycleObserver = _LifecycleObserver(
      onResume: () async {
        if (!_popped) {
          Navigator.of(context).pop(widget.result);
          _popped = true;
        }
      },
    );
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _LifecycleObserver extends WidgetsBindingObserver {
  final AsyncCallback onResume;
  final AsyncCallback onStop;

  _LifecycleObserver({
    this.onResume,
    this.onStop,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (onResume != null) {
          await onResume();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (onStop != null) {
          await onStop();
        }
        break;
    }
  }
}

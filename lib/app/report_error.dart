import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:drivers/dependencies.dart';
import 'package:drivers/log.dart';
import 'package:flutter_template/app/config.dart';
import 'package:flutter_template/git_revision.dart';

Future<void> reportError(Object e, StackTrace stackTrace) async {
  final config = resolveDependency<Config>();

  if (config.reportCrashes) {
    try {
      await FirebaseCrashlytics.instance.recordError(e, stackTrace);
    } catch (_) {
      log('report', 'Failed to report');
    }
  } else {
    debugPrint('REPORT EXCEPTION: $e');
    debugPrint(stackTrace.toString());

    final report = 'GIT REVISION: $gitRevision\n\n'
        'ERROR: $e\n\n'
        'STACK TRACE:\n$stackTrace';

    await Clipboard.setData(ClipboardData(text: report));
  }
}

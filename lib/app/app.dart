import 'package:drivers/dependencies.dart';
import 'package:drivers/exceptions/common.dart';
import 'package:drivers/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/config.dart';
import 'package:flutter_template/app/report_error.dart';
import 'package:flutter_template/layers/bloc/app/app_bloc.dart';
import 'package:flutter_template/layers/di/modules/adapters/domain.dart';
import 'package:flutter_template/layers/di/modules/adapters/ui.dart';
import 'package:flutter_template/layers/di/modules/network.dart';
import 'package:flutter_template/layers/di/modules/services.dart';
import 'package:flutter_template/layers/di/modules/states.dart';
import 'package:flutter_template/layers/di/modules/storages.dart';
import 'package:flutter_template/layers/di/modules/use_case_states.dart';
import 'package:flutter_template/layers/di/modules/use_cases.dart';
import 'package:flutter_template/layers/routers/router.dart';
import 'package:flutter_template/layers/services/errors.dart';
import 'package:flutter_template/layers/use_cases/app.dart';
import 'package:forms/strings.dart';
import 'package:get_it/get_it.dart';

Future<void> setUp(Config config) async {}

Future<void> setupDependencies(Config config) async {
  final sl = GetIt.instance;

  sl.registerSingleton<Config>(config);

  await setupNetworkDependencies(config);
  await setupStoragesDependencies(config);
  await setupServicesDependencies(config);
  await setupUseCasesDependencies(config);
  await setupUseCaseStatesDependencies(config);
  await setupStatesDependencies(config);
  await setupDomainAdaptersDependencies(config);
  await setupUIAdaptersDependencies(config);
}

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    debugPrint('${bloc.runtimeType} => Event: ${event.toString()}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('${bloc.runtimeType} => ${transition.toString()}');
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
    GetIt.instance<ErrorsService>().pushError(error, stackTrace);
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
  }
}

class MyApp extends StatefulWidget {
  final Widget home;

  const MyApp({
    @required this.home,
    Key key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _key = ErrorHandlerKey();
  AppBloc _appBloc;
  final _useCase = resolveDependency<AppUseCase>();
  final _errorService = resolveDependency<ErrorsService>();

  @override
  void initState() {
    _errorService.registerErrorHandler(
      _key,
      (e, stackTrace) {
        debugPrint(e.toString());
        debugPrint(stackTrace.toString());

        _appBloc.add(OnError(e, stackTrace));

        if (e is! LogicException) {
          reportError(e, stackTrace);
        }

        return false;
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _appBloc = AppBloc(
      AppRouter.of(context),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (context != null) {
          final config = AppConfig.of(context).config;
          _appBloc.add(
            OnSetEnabledDebugServices(isEnabled: config.debugServices),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _errorService.unregisterErrorHandler(_key);
    _appBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context).config;
    return BlocProvider<AppBloc>.value(
      value: _appBloc,
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return MaterialApp(
            localizationsDelegates: const [
              FormsStringsDelegate(),
              DriversStringsDelegate(),
              // GlobalMaterialLocalizations.delegate,
              // GlobalWidgetsLocalizations.delegate,
              // GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru'),
            ],
            // theme: AppThemes.materialAppTheme(state.colorScheme),
            home: widget.home,
          );
        },
      ),
    );
  }
}

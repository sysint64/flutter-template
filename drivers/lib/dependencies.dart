import 'package:get_it/get_it.dart';

T resolveDependency<T>({String instanceName}) =>
    GetIt.instance.get<T>(instanceName: instanceName);

void pushDependency<T>(T instance, {String instanceName}) =>
    GetIt.instance.registerSingleton(instance, instanceName: instanceName);

void removeDependency<T>(T instance, {String instanceName}) =>
    GetIt.instance.unregister(instance: instance, instanceName: instanceName);

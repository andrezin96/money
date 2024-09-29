import 'package:get_it/get_it.dart';

import '../modules/home/controller/home_cubit.dart';

abstract class Injector {
  T get<T extends Object>();
  void replace<T extends Object>(T instance);
}

class _GetItImpl implements Injector {
  _GetItImpl() {
    _register();
  }

  void _register() {
    GetIt.I.registerSingleton<HomeCubit>(HomeCubit());
  }

  @override
  T get<T extends Object>() {
    return GetIt.I.get<T>();
  }

  @override
  void replace<T extends Object>(T instance) {
    GetIt.I.unregister(instance: instance);
    GetIt.I.registerLazySingleton<T>(() => instance);
  }
}

final Injector injector = _GetItImpl();

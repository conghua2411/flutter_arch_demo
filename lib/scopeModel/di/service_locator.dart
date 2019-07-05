import 'package:flutter_arch_demo/data/ApiService.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton<ApiService>(() => ApiService());
}
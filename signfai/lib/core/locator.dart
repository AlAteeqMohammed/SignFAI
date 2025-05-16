import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefrence_repository.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPreferences);

  locator.registerLazySingleton<SharedPreferencesRepository>(
      () => SharedPreferencesRepository());
}

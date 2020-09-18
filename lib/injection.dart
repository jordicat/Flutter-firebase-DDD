import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_firebase_ddd_notes/injection.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
void configureInjection(String env) {
  $initGetIt(getIt, environment: env);
}

// ignore_for_file: non_constant_identifier_names

import 'package:envied/envied.dart';
import 'package:my_mvvm_app/src/config/env.dart';

part 'production_env.g.dart';

@Envied(name: 'Env', path: 'lib/src/config/.env.production')
class ProductionEnv implements Env, EnvFields {

  ProductionEnv();

  @override
  @EnviedField()
  final String BASE_URL = _Env.BASE_URL;

  @override
  @EnviedField(obfuscate: true)
  final String API_KEY = _Env.API_KEY;

  @override
  @EnviedField(obfuscate: true)
  final String API_SECRET = _Env.API_SECRET;
}

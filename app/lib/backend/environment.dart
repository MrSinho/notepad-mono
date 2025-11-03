import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'utils/utils.dart';



Future<void> loadEnv() async {
  await dotenv.load(
    fileName: ".safeEnv",
    isOptional: true
  );
}

String getEnvironmentParameterValue(String parameterName) {
  String? value = dotenv.env[parameterName];

  appLog(".env parameter $parameterName: $value");

  if (value != null) {
    return value;
  }

  value = String.fromEnvironment(parameterName, defaultValue: "");

  appLog("Environment parameter $parameterName: $value");

  return value;
}

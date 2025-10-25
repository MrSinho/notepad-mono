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

  value ??= String.fromEnvironment(parameterName, defaultValue: "");

  if (value == "") {
    appLog("Environment parameter $parameterName not found");
  }

  appLog("Parameter $parameterName: $value");

  return value;
}

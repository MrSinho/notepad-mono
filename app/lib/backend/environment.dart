import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'utils.dart';

String getEnvironmentParameterValue(String parameterName) {
  String? value = dotenv.env[parameterName];

  value ??= String.fromEnvironment(parameterName, defaultValue: "");

  if (value == "") {
    appLog("Environment parameter $parameterName not found", true);
  }

  appLog("Parameter $parameterName: $value", true);

  return value;
}

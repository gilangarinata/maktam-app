import 'package:maktampos/services/network_exception.dart';

class NetworkUtils {
  static String getErrorMessage(Object exception) {
    if (exception is ClientErrorException) {
      return exception.message;
    } else {
      return exception.toString();
    }
  }

  static int getErrorCode(Object exception) {
    if (exception is ClientErrorException) {
      return exception.code;
    } else {
      return exception.hashCode;
    }
  }
}

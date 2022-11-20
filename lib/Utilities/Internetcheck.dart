import 'dart:convert';
import 'dart:io';

class Utils {
  static Future<bool> checkInternetConnection() async {
    Future<bool> isRechable = Future<bool>.value(false);
    try {
      final response = await InternetAddress.lookup('www.kindacode.com');
      if (response.isNotEmpty) {
        isRechable = Future<bool>.value(true);
      }
    } on SocketException catch (err) {
      isRechable = Future<bool>.value(false);
    }
    return isRechable;
  }
}

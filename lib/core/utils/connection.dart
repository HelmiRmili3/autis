import 'package:connectivity_plus/connectivity_plus.dart';

class Connection {
  Future<bool> checkInternetConnection() async {
    // Check connectivity and handle the case where it returns a list
    List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    // If any of the results is not "none", there is an active connection
    return connectivityResult
        .any((result) => result != ConnectivityResult.none);
  }
}

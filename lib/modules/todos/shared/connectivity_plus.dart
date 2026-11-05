import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityPlus {
  Future<bool> cheackConective() async {
    final connectivity = await Connectivity();

    final List<ConnectivityResult> result =
        await connectivity.checkConnectivity();

    return !result.contains(ConnectivityResult.none);
  }
}

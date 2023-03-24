import 'package:ja/app/data/providers/device_provider.dart';

class DeviceRepository extends DeviceProvider {
  void toggleConnection() {
    if (isConnected.value) {
      disconnect();
    } else {
      connect();
    }
  }
}

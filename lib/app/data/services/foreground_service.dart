import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';

class ForegroundService extends GetxService{
  late RxBool isRunning;
  
  Future<ForegroundService> init() async {
    isRunning = (await FlutterBackgroundService().isRunning()).obs;
    return this;
  }

  void setRunning(bool value){
    if(value){
      start();
    }else{
      stop();
    }
  }
  
  void start() {
    FlutterBackgroundService().startService();
    isRunning.value = true;
  }
  
  void stop() {
    FlutterBackgroundService().invoke('stopService');
    isRunning.value = false;
  }
}
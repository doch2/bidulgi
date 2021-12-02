import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../cctv_controller.dart';


class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CCTVController>(() => CCTVController());
    Get.lazyPut(() => Dio());
  }
}

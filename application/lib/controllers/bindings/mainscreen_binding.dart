import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../schoolinfo_controller.dart';


class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SchoolInfoController>(() => SchoolInfoController());
    Get.lazyPut(() => Dio());
  }
}

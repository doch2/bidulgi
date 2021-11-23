import 'package:bidulgi/services/realtime_database.dart';
import 'package:get/get.dart';

class SchoolInfoController extends GetxController {
  RealtimeDatabase _realtimeDatabase = RealtimeDatabase();
  
  bool isCreateRefreshTimer = false;
  RxInt refreshTime = 0.obs;

  RxString temperature = "initData".obs;
  RxString humidity = "initData".obs;

  Future<void> refreshTimer() async {
    try {
      while (true) {
        await Future.delayed(
            Duration(seconds: 1),
            () async {
              if (refreshTime.value == 0) {
                temperature.value = getSchoolTemperature();
                humidity.value = getSchoolHumidity();
                
                refreshTime.value = 10;
              } else {
                refreshTime.value = refreshTime.value - 1;
              }
            }
        );
      }
    } catch (e) { //중간에 로그아웃 되서 타이머가 오류가 났을 경우
      isCreateRefreshTimer = false;
    }
  }
  
  getSchoolTemperature() => _realtimeDatabase.getSchoolTemperature();
  getSchoolHumidity() => _realtimeDatabase.getSchoolHumidity();

}

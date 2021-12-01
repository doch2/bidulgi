import 'package:bidulgi/services/firebase_storage.dart';
import 'package:bidulgi/services/realtime_database.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';

class SchoolInfoController extends GetxController {
  RealtimeDatabase _realtimeDatabase = RealtimeDatabase();
  
  bool isCreateRefreshTimer = false;
  RxInt refreshTime = 0.obs;

  RxString temperature = "initData".obs;
  RxBool isLedOnOff = false.obs;
  RxBool isSoundOnOff = false.obs;
  RxString cctvCapture = "initData".obs;

  @override
  onInit() async {
    _realtimeDatabase.registerCctvChangeListener();
  }

  Future<void> refreshTimer() async {
    try {
      while (true) {
        await Future.delayed(
            Duration(seconds: 1),
            () async {
              if (refreshTime.value == 0) {
                temperature.value = await getSchoolTemperature();
                cctvCapture.value = await getCctvCaptureImageUrl();
                
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
  
  getSchoolTemperature() async => await _realtimeDatabase.getSchoolTemperature();

  getLedOnOff() async => await _realtimeDatabase.getLedOnOff();
  setLedOnOff(bool ledStatus) async {
    isLedOnOff.value = ledStatus;

    await _realtimeDatabase.setLedOnOff(ledStatus);
  }

  getSoundOnOff() async => await _realtimeDatabase.getSoundOnOff();
  setSoundOnOff(bool soundStatus) async {
    if (!isSoundOnOff.value) {
      isSoundOnOff.value = soundStatus;

      if (soundStatus) { Vibrate.vibrate(); }
      await _realtimeDatabase.setSoundOnOff(soundStatus);

      Future.delayed(
          Duration(seconds: 5),
              () async                {
            isSoundOnOff.value = !soundStatus;
            await _realtimeDatabase.setSoundOnOff(!soundStatus);
          }
      );
    }
  }

  getCctvCaptureImageUrl() async {
    String lastUpdate = await _realtimeDatabase.getCctvLastUpdateDate();

    return await FirebaseStorage().getImageUrl(lastUpdate);
  }

}

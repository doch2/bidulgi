import 'package:bidulgi/services/firebase_storage.dart';
import 'package:bidulgi/services/realtime_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CCTVController extends GetxController {
  RealtimeDatabase _realtimeDatabase = RealtimeDatabase();
  
  bool isCreateRefreshTimer = false;
  RxInt refreshTime = 1.obs;

  RxString temperature = "initData".obs;
  RxString nowTime = "initData".obs;
  RxBool isLedOnOff = false.obs;
  RxBool isSoundOnOff = false.obs;
  RxString cctvCapture = "initData".obs;

  @override
  onInit() async {
    _realtimeDatabase.registerCctvChangeListener();
  }

  Future<void> refreshTimerNowTime() async {
    try {
      while (true) {
        await Future.delayed(
            Duration(seconds: 1),
            () async {
              if (refreshTime.value == 1) {
                nowTime.value = "${DateTime.now().hour}시 ${DateTime.now().minute}분 ${DateTime.now().second}초";
                //cctvCapture.value = await getCctvCaptureImageUrl();
                
                refreshTime.value = 1;
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

  Future<void> refreshTimerCctv() async {
    try {
      while (true) {
        await Future.delayed(
            Duration(seconds: 1),
                () async {
              if (refreshTime.value == 1) {
                cctvCapture.value = await getCctvCaptureImageUrl();

                refreshTime.value = 1;
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

  getLedOnOff() async => await _realtimeDatabase.getLedOnOff();
  setLedOnOff(bool ledStatus) async {
    isLedOnOff.value = ledStatus;

    await _realtimeDatabase.setLedOnOff(ledStatus);
  }

  getSoundTime() async => await _realtimeDatabase.getSoundTime();
  setSoundTime(int time) async {
    await _realtimeDatabase.setSoundTime(time);

    showToast("소리 재생 시간을 $time초로 변경했습니다.");
  }
  getSoundOnOff() async => await _realtimeDatabase.getSoundOnOff();
  setSoundOnOff(bool soundStatus) async {
    if (!isSoundOnOff.value) {
      isSoundOnOff.value = soundStatus;

      showToast("경고음이 재생됩니다.");

      if (soundStatus) {
        Vibrate.vibrate();
        await Future.delayed(
            Duration(milliseconds: 480),
                () { Vibrate.vibrate(); }
        );
        Future.delayed(
            Duration(milliseconds: 480),
                () { Vibrate.vibrate(); }
        );
      }
      await _realtimeDatabase.setSoundOnOff(soundStatus);

      Future.delayed(
          Duration(seconds: 5),
              () async {
            isSoundOnOff.value = !soundStatus;
            await _realtimeDatabase.setSoundOnOff(!soundStatus);
          }
      );
    }
  }

  sendMessage(String content) async {
    await _realtimeDatabase.sendMessage(content);

    showToast("LCD에 메세지가 전송되었습니다!");
  }

  getCctvCaptureImageUrl() async {
    String lastUpdate = await _realtimeDatabase.getCctvLastUpdateDate();

    return await FirebaseStorage().getImageUrl(lastUpdate);
  }

  showToast(String content) => Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xE6FFFFFF),
      textColor: Colors.black,
      fontSize: 13.0
  );

}

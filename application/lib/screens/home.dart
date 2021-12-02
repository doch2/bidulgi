import 'package:bidulgi/controllers/cctv_controller.dart';
import 'package:bidulgi/themes/color_theme.dart';
import 'package:bidulgi/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';

class Home extends GetWidget<CCTVController> {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    final messageTextController = TextEditingController();

    if (!controller.isCreateRefreshTimer) { controller.refreshTimerNowTime(); controller.refreshTimerCctv(); controller.isCreateRefreshTimer = true; }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Color(0x66e7f5ff)),
              width: _width,
              height: _height,
            ),
            Positioned(
              bottom: 0,
              child: Hero(
                tag: "bottomDesign",
                child: Image.asset(
                  "assets/images/background_cloud.png",
                  width: _width,
                ),
              ),
            ),
            Positioned(
              top: _height * 0.11,
              left: _width * 0.13,
              child: Obx(() {
                String data = controller.nowTime.value;
                if (data == "initData") {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "현재 시각",
                        style: homeDescription,
                      ),
                      Text(
                        "${data}",
                        style: homeTitle,
                      )
                    ],
                  );
                }
              }),
            ),
            Positioned(
              top: _height * 0.1,
              right: _width * 0.1,
              child: Obx(() {
                TextStyle textStyle = trafficLightOff;
                Color containerColor = grayThree;
                Color containerShadowColor = grayShadowOne;

                if (controller.hasThief.value) {
                  textStyle = trafficLightOn;
                  containerColor = redOne;
                  containerShadowColor = redShadowOne;

                  Vibrate.vibrate();
                }

                return Container(
                  height: _width * 0.225,
                  width: _width * 0.225,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: containerColor,
                    boxShadow: [
                      BoxShadow(
                        color: containerShadowColor,
                        offset: Offset(4, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(child: Text("침입!", style: textStyle)),
                );
              }),
            ),
            Positioned(
              top: _height * 0.285,
              left: _width * 0.13,
              child: Row(
                children: [
                  Text(
                    "LED ON/OFF",
                    style: homeTitle,
                  ),
                  SizedBox(width: _width * 0.025),
                  FutureBuilder(
                      future: controller.getLedOnOff(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) { //데이터를 정상적으로 받았을때
                          controller.isLedOnOff.value = snapshot.data;

                          return Obx(() => FlutterSwitch(
                            height: _height * 0.035,
                            width: _width * 0.14,
                            padding: 2,
                            toggleSize: _width * 0.05,
                            borderRadius: 16.0,
                            activeColor: blueTwo,
                            value: controller.isLedOnOff.value,
                            onToggle: (value) => controller.setLedOnOff(value),
                          ));
                        } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
                          return Text("데이터 로드 오류", textAlign: TextAlign.center);
                        } else { //데이터를 불러오는 중
                          return SizedBox(
                            width: _width * 0.055,
                            height: _width * 0.055,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      }
                  ),
                ],
              ),
            ),
            Positioned(
              top: _height * 0.4,
              left: _width * 0.13,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: _width * 0.45,
                    child: TextField(
                        controller: messageTextController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'LCD창에 보여줄 메세지',
                        ),
                        style: homeMessageInput
                    ),
                  ),
                  SizedBox(width: _width * 0.04),
                  GestureDetector(
                    onTap: () => controller.sendMessage(messageTextController.text),
                    child: Container(
                      height: _height * 0.07,
                      width: _width * 0.275,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF2c2c2c).withOpacity(0.1),
                              spreadRadius: 4,
                              blurRadius: 10,
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "메세지 보내기",
                              style: homeDefaultBtn
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: _height * 0.625,
              child: FutureBuilder(
                  future: controller.getSoundOnOff(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) { //데이터를 정상적으로 받았을때
                      controller.isSoundOnOff.value = snapshot.data;

                      return Obx(() => GestureDetector(
                        onTap: () => controller.setSoundOnOff(!controller.isSoundOnOff.value),
                        child: soundBtn(_width, _height),
                      ));
                    } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
                      return Text("데이터 로드 오류", textAlign: TextAlign.center);
                    } else { //데이터를 불러오는 중
                      return SizedBox(
                        width: _width * 0.2,
                        height: _width * 0.2,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  }
              ),
            ),
            Positioned(
              top: _height * 0.65,
              left: _width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => controller.setSoundTime(5),
                    child: setSoundTimeBtn(5, _width, _height),
                  ),
                  SizedBox(height: _height * 0.02),
                  GestureDetector(
                    onTap: () => controller.setSoundTime(10),
                    child: setSoundTimeBtn(10, _width, _height),
                  ),
                  SizedBox(height: _height * 0.02),
                  GestureDetector(
                    onTap: () => controller.setSoundTime(15),
                    child: setSoundTimeBtn(15, _width, _height),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container setSoundTimeBtn(int time, double _width, double _height) {
    return Container(
      height: _height * 0.0725,
      width: _height * 0.0725,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF2c2c2c).withOpacity(0.1),
              spreadRadius: 4,
              blurRadius: 10,
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "$time초",
              style: homeDefaultBtn
          )
        ],
      ),
    );
  }

  Container soundBtn(double _width, double _height) {
    Color btnColor;
    Image btnContent;

    if (controller.isSoundOnOff.value) {
      btnColor = Colors.redAccent;

      btnContent = Image.asset(
        "assets/images/sound_on.png",
        color: Colors.white,
        width: _width,
      );
    } else {
      btnColor = Colors.white;

      btnContent = Image.asset(
        "assets/images/sound_off.png",
        width: _width,
      );
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: btnColor,
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            spreadRadius: 4,
            blurRadius: 25,
          ),
        ]
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: _width * 0.325,
            height: _height * 0.325,
          ),
          SizedBox(
            width: _width * 0.25,
            child: btnContent,
          )
        ],
      )
    );
  }
}
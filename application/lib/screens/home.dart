import 'package:bidulgi/controllers/schoolinfo_controller.dart';
import 'package:bidulgi/themes/color_theme.dart';
import 'package:bidulgi/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class Home extends GetWidget<SchoolInfoController> {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    if (!controller.isCreateRefreshTimer) { controller.refreshTimer(); controller.isCreateRefreshTimer = true; }

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
              top: _height * 0.2,
              left: _width * 0.15,
              child: Obx(() {
                String data = controller.temperature.value;
                if (data == "initData") {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "현재 온도",
                        style: homeHumiAndTempTitle,
                      ),
                      Text(
                        "${data}℃",
                        style: homeHumiAndTempNum,
                      )
                    ],
                  );
                }
              }),
            ),
            Positioned(
              top: _height * 0.325,
              left: _width * 0.15,
              child: Row(
                children: [
                  Text(
                    "LED ON/OFF",
                    style: homeHumiAndTempNum,
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
              top: _height * 0.6,
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
              bottom: _height * 0.0125,
              child: Obx(() {
                return Text(
                  "새로고침까지 남은 시간 : ${controller.refreshTime.value}초",
                  style: homeRefreshTime,
                );
              }),
            ),
          ],
        ),
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
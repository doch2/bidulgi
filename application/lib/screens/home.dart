import 'package:bidulgi/controllers/schoolinfo_controller.dart';
import 'package:bidulgi/themes/color_theme.dart';
import 'package:bidulgi/themes/text_theme.dart';
import 'package:flutter/material.dart';
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
              child: Image.asset(
                "assets/images/background_cloud.png",
                width: _width,
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
            SizedBox(height: _height * 0.05),
            Positioned(
              top: _height * 0.325,
              left: _width * 0.15,
              child: Obx(() {
                String data = controller.humidity.value;
                if (data == "initData") {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "현재 습도",
                        style: homeHumiAndTempTitle,
                      ),
                      Text(
                        "${data}%",
                        style: homeHumiAndTempNum,
                      )
                    ],
                  );
                }
              }),
            ),
            Positioned(
              bottom: _height * 0.05,
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
}
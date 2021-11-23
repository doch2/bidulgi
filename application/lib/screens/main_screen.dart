import 'package:bidulgi/controllers/schoolinfo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends GetWidget<SchoolInfoController> {
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    if (!controller.isCreateRefreshTimer) { controller.refreshTimer(); controller.isCreateRefreshTimer = true; }

    controller.getSchoolTemperature();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Home Page"),
            SizedBox(height: _height * 0.08),
            Obx(() {
              String data = controller.temperature.value;
              if (data == "initData") {
                return CircularProgressIndicator();
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "현재온도 : ${data}",
                    )
                  ],
                );
              }
            }),
            Obx(() {
              String data = controller.humidity.value;
              if (data == "initData") {
                return CircularProgressIndicator();
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "현재습도 : ${data}",
                    )
                  ],
                );
              }
            }),
            Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "남은 시간 : ${controller.refreshTime.value}",
                  )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
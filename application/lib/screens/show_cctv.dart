import 'package:bidulgi/controllers/cctv_controller.dart';
import 'package:bidulgi/themes/color_theme.dart';
import 'package:bidulgi/themes/text_theme.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowCctv extends GetWidget<CCTVController> {
  ShowCctv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(color: Color(0x66e7f5ff)),
              width: _width,
              height: _height,
            ),
            Positioned(
              bottom: -(_height * 0.1),
              child: Hero(
                tag: "bottomDesign",
                child: Image.asset(
                  "assets/images/background_cloud.png",
                  width: _width,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "CCTV는 라즈베리파이의 모니터에서 \n확인하실 수 있습니다 :)\n\n정식 프로젝트가 진행되면 네트워크 설정(포트포워딩 등)을 \n진행하여 앱에서도 확인할 수 있게 할 예정이에요!",
                  textAlign: TextAlign.center,
                  style: cameraDescription,
                ),
                /*Obx(() {
                  String data = controller.cctvCapture.value;
                  if (data == "initData") {
                    return CircularProgressIndicator();
                  } else {
                    return SizedBox(
                      width: _width * 0.8,
                      child: ExtendedImage.network(controller.cctvCapture.value),
                    );
                  }
                }), */
              ],
            ),
          ],
        ),
      ),
    );
  }
}
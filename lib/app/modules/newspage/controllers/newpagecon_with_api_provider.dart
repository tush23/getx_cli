import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_cli/app/customs/handler.dart';
import 'package:getx_cli/app/provider/api_provider.dart';
import 'package:getx_cli/app/modules/newspage/model/news/news.dart';

class NewsControllerWithApiProviders extends GetxController
    with StateMixin<News> {
  final ApiProvider _apiProvider = Get.find();

  @override
  void onReady() {
    print('onReady called');
    getNews();
    super.onReady();
  }

  void getNews() {
    // Get.generalDialog(pageBuilder: (BuildContext context,
    //     Animation<double> animation, Animation<double> secondaryAnimation) {
    //   return Text('Loading');
    // });
    Get.dialog(Handler().loading);

    _apiProvider.getNews().then((value) {
      // change(null, status: RxStatus.loading());
      if (value.hasError) {
        change(null, status: RxStatus.error(value.body.message));
        Handler().error(errorString: value.body.message, retryPressed: onReady);
      }
      if (value.statusCode == 200) {
        print(Get.isSnackbarOpen);
        change(value.body, status: RxStatus.success());
      }
    });
  }

  void getEverything(String q) {
    _apiProvider.getEverthing(q).then((value) {
      change(null, status: RxStatus.loading());
      if (value.hasError)
        change(null, status: RxStatus.error(value.body.message));
      if (value.statusCode == 200)
        change(value.body, status: RxStatus.success());
    });
  }
}

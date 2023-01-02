import 'dart:convert';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:test_form/Model/distModel.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  // late DistModel response;
  String url = 'http://dev.stockpathshala.in/api_v3/audio/lang_cat_wise';

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    // await getDist();
  }

  updateData() {
    isLoading.value = false;
    update();
  }

  Future<void> getDist() async {
    //replace your restFull API here.
    String url = "http://vihotargroup.com/api/district/";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      DistModel.fromJson(responseData);
    }
  }

  Future<void> getTaluka() async {
    //replace your restFull API here.
    String url = "http://vihotargroup.com/api/taluka/";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      DistModel.fromJson(responseData);
    }
  }

  Future<void> getVillage() async {
    //replace your restFull API here.
    String url = "http://vihotargroup.com/api/village/";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      DistModel.fromJson(responseData);
    }
  }
}

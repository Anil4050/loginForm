import 'package:flutter/src/material/dropdown.dart';

class DistModel {
  String? id;
  String? stateId;
  String? districtName;
  String? districtName2;

  DistModel({this.id, this.stateId, this.districtName, this.districtName2});

  DistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateId = json['state_id'];
    districtName = json['district_name'];
    districtName2 = json['district_name_2'];
  }

  map(DropdownMenuItem<String> Function(String items) param0) {}
}

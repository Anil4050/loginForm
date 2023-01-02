import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../Controller/loginController.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  LoginController controller = Get.put(LoginController());
  late TextEditingController name;
  late TextEditingController mobile;
  late TextEditingController passaword;
  late TextEditingController rePass;
  late TextEditingController dob;
  String selectedImagePath = '';
  String dist = '';
  String taluka = '';
  String village = '';

  bool passVisiblity = true;
  DateTime selectedDate = DateTime.now();

  String? _currentAddress;
  Position? _currentPosition;
  // late Position currentLocation;

  @override
  void initState() {
    passaword = TextEditingController();
    rePass = TextEditingController();
    dob = TextEditingController();
    name = TextEditingController();
    mobile = TextEditingController();
    _getCurrentPosition();
    setState(() {
      passVisiblity;
      _currentAddress;
      _currentPosition;
    });
    super.initState();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
      boxShadow: const [
        BoxShadow(
          offset: Offset(0, 2),
          blurRadius: 12,
          color: Color.fromRGBO(0, 0, 0, 0.16),
        )
      ],
    );
  }

  String? validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return 'good';
      }
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  File? image;
  Future pickImage(sourse) async {
    try {
      final image = await ImagePicker().pickImage(source: sourse);
      if (image == null) return;
      final imageTemp = File(image.path);
      selectedImagePath = imageTemp.path;
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: containerDecoration(),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: name,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              hintText: 'Your name',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: InputBorder.none,
                            ),
                            onChanged: ((value) {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: containerDecoration(),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: mobile,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Your Mobile Number',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: InputBorder.none,
                            ),
                            onChanged: ((value) {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: containerDecoration(),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: passaword,
                            obscureText: passVisiblity,
                            // keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: InputBorder.none,
                            ),
                            onChanged: ((value) {}),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                passVisiblity = passVisiblity ? false : true;
                              });
                              print("icon presses");
                            },
                            icon: Icon(passVisiblity
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined))
                      ],
                    ),
                  ),
                  Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: containerDecoration(),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: rePass,
                            obscureText: true,

                            // keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Repeate Password',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: InputBorder.none,
                            ),
                            onChanged: ((value) {}),
                            onSubmitted: ((value) {
                              String? status = validatePassword(value);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(status!),
                              ));
                              if (passaword.text == rePass.text) {
                                print('SamePassword');
                              }
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: containerDecoration(),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(DateFormat(' dd - MM - yyyy ')
                              .format(selectedDate)),
                        ),
                        const VerticalDivider(
                          width: 2,
                        ),
                        IconButton(
                            onPressed: () {
                              _selectDate();
                            },
                            icon: const Icon(
                              Icons.calendar_month,
                              size: 30,
                              color: Colors.blueGrey,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: containerDecoration(),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('LAT: ${_currentPosition?.latitude ?? ""}'),
                        Text('LNG: ${_currentPosition?.longitude ?? ""}'),
                        // Text('ADDRESS: ${_currentAddress ?? ""}'),
                      ],
                    ),
                  ),

                  //         GoogleMap(
                  //    // onMapCreated: _onMapCreated,
                  //    initialCameraPosition: CameraPosition(
                  //      target: currentPostion,
                  //      zoom: 10,
                  //    ),
                  //  ),
                  // Container(
                  //   height: 100,
                  //   padding:
                  //       EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  //   margin: EdgeInsets.symmetric(vertical: 10.0),
                  //   decoration: containerDecoration(),
                  //   width: MediaQuery.of(context).size.width * 0.8,
                  //   child: DropdownButton(
                  //     // Initial Value
                  //     value: dist,

                  //     // Down Arrow Icon
                  //     icon: const Icon(Icons.keyboard_arrow_down),

                  //     // Array list of items
                  //     items: controller.response.map((String items) {
                  //       return DropdownMenuItem(
                  //         value: items,
                  //         child: Text(items),
                  //       );
                  //     }).toList(),
                  //     // After selecting the desired option,it will
                  //     // change button value to selected value
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         dist = newValue!;
                  //       });
                  //     },
                  //   ),
                  // ),
                  Container(
                    height: 100,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: containerDecoration(),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: image != null
                        ? Image.file(File(image!.path))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 12,
                                        color: Color.fromRGBO(0, 0, 0, 0.16),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: IconButton(
                                    onPressed: () {
                                      pickImage(ImageSource.camera);
                                    },
                                    icon: const Icon(Icons.camera_alt)),
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 12,
                                        color: Color.fromRGBO(0, 0, 0, 0.16),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: IconButton(
                                    onPressed: () {
                                      pickImage(ImageSource.gallery);
                                    },
                                    icon: const Icon(Icons.image)),
                              )
                              // Text('ADDRESS: ${_currentAddress ?? ""}'),
                            ],
                          ),
                  ),
                  InkWell(
                    onTap: (() {}),
                    child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 12,
                                color: Color.fromRGBO(0, 0, 0, 0.16),
                              )
                            ],
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:local_app/model/User.dart';
import 'package:local_app/services/userService.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  // final User moUser;

  // const AddUser({Key? key, required this.moUser}) : super(key: key);

  // const Ad, required User userdUser({Key? key, required this.moUser}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final moUserFirstNameController = TextEditingController();
  final moUserLastNameController = TextEditingController();
  final moUserContactController = TextEditingController();
  final moUserEmailController = TextEditingController();
  final moUserDobController = TextEditingController();

  String? msValidateFirstName;
  String? msValidateLastName;
  String? msValidateContact;
  String? msValidateDob;
  String? msValidateEmail;

  bool mbFName = false;
  bool mbLName = false;
  bool mbContact = false;
  bool mbEmail = false;
  bool mbDob = false;

  String msContactPattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  String msEmailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  var moUserService = UserService();
  DateTime? moDate;
  File? moPickedImage;
  String? msImagePath;

  // @override
  // void initState() {
  //   setState(() {
  //     moUserFirstNameController.text = widget.moUser.msFName ?? '';
  //     moUserLastNameController.text = widget.moUser.msLName ?? '';
  //     moUserContactController.text = widget.moUser.msContact ?? '';
  //     moUserEmailController.text = widget.moUser.msEmail ?? '';
  //     moUserDobController.text = widget.moUser.msDob ?? '';
  //   });
  //   super.initState();
  // }

  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageType) async {
    try {
      final loPhoto = await ImagePicker().pickImage(source: imageType);
      if (loPhoto == null) return;
      moPickedImage = File(loPhoto.path);
      setState(() {
        msImagePath = loPhoto.path;
        debugPrint("My Image path " + msImagePath!);
        // alert(context,title: Text(msImagePath));
      });
      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New User"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.teal, width: 5),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          child: ClipOval(
                            child: (moPickedImage != null)
                                ? Image.file(
                                    moPickedImage!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.person,
                                    color: Colors.teal,
                                    size: 150,
                                  ),

                            // Image.network(
                            //         'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg',
                            //         width: 170,
                            //         height: 170,
                            //         fit: BoxFit.cover,
                            //       ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          child: IconButton(
                            onPressed: imagePickerOption,
                            icon: const Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.teal,
                              size: 50,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: moUserFirstNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Colors.teal),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintText: 'Enter First Name',
                  labelText: 'First Name',
                  errorText: msValidateFirstName,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: moUserLastNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Colors.teal),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintText: 'Enter Last Name',
                  labelText: 'Last Name',
                  errorText: msValidateLastName,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: moUserContactController,
                  maxLength: 10,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone, color: Colors.teal),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: 'Enter Contact Number',
                    labelText: 'Contact',
                    errorText: msValidateContact,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: moUserEmailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Colors.teal),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintText: 'Enter Email',
                  labelText: 'Email',
                  errorText: msValidateEmail,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () async {
                  final loInitialDate = DateTime.now();
                  final loPickedDate = await showDatePicker(
                    context: context,
                    initialDate: moDate ?? loInitialDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (loPickedDate != null) {
                    String msFormattedDate =
                        DateFormat('dd-MM-yyyy').format(loPickedDate);
                    setState(() {
                      moUserDobController.text = msFormattedDate;
                      moDate = loPickedDate;
                      mbDob = true;
                    });
                  } else {
                    mbDob = false;
                    print("Date is not selected");
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: moUserDobController,
                    // keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      prefixIcon:
                          Icon(Icons.calendar_today, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: "Enter DOB",
                      hintText: 'Enter Date of Birth',
                    ),
                    // readOnly: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        setState(() {
                          if (moUserFirstNameController.text.isEmpty ||
                              moUserLastNameController.text.isEmpty) {
                            msValidateFirstName = "First value Can\'t Be Empty";
                            msValidateLastName = "Last value Can\'t Be Empty";
                          } else {
                            msValidateFirstName = null;
                            msValidateLastName = null;
                            mbFName = true;
                            mbLName = true;
                          }

                          if (moUserContactController.text.isEmpty) {
                            msValidateContact = "Contact value Can\'t Be Empty";
                          } else if (moUserContactController.text.length !=
                              10) {
                            msValidateContact = "Please Enter 10 Digit...";
                          } else {
                            msValidateContact = null;
                            mbContact = true;
                          }

                          if (moUserEmailController.text.isEmpty) {
                            msValidateEmail = "Contact value Can\'t Be Empty";
                          } else if (!RegExp(msEmailPattern)
                              .hasMatch(moUserEmailController.text)) {
                            msValidateEmail = "Please enter valid email";
                          } else if (moUserService.checkEmailVerify(
                                  moUserEmailController.text) ==
                              0) {
                            msValidateEmail = "Email Already Exists.";
                          } else {
                            msValidateEmail = null;
                            mbEmail = true;
                          }
                        });
                        if (mbFName &&
                            mbLName &&
                            mbContact &&
                            mbEmail &&
                            mbDob) {
                          // print("Good Data Can Save");
                          var loUser = User();
                          loUser.msFName = moUserFirstNameController.text;
                          loUser.msLName = moUserLastNameController.text;
                          loUser.msContact = moUserContactController.text;
                          loUser.msEmail = moUserEmailController.text;
                          loUser.msDob = moUserDobController.text;
                          loUser.msImg = msImagePath;
                          var loResult = await moUserService.saveUser(loUser);
                          Navigator.pop(context, loResult);

                          // } else {
                          //   loUser.miId = widget.moUser.miId;
                          //   loUser.msFName = moUserFirstNameController.text;
                          //   loUser.msLName = moUserLastNameController.text;
                          //   loUser.msContact = moUserContactController.text;
                          //   loUser.msEmail = moUserEmailController.text;
                          //   loUser.msDob = moUserDobController.text;
                          //   var result = await moUserService.updateUser(loUser);
                          //   Navigator.pop(context, result);
                          // }
                        } else {
                          print("Error");
                        }
                      },
                      child: const Text('Save Details')),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        moUserFirstNameController.text = '';
                        moUserLastNameController.text = '';
                        moUserContactController.text = '';
                        moUserEmailController.text = '';
                        moUserDobController.text = '';
                      },
                      child: const Text('Clear Details'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

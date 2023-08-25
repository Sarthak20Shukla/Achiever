// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:async';

import 'package:achiever/screens/authentications/login.dart';
import 'package:achiever/screens/authentications/phone_auth.dart';
import 'package:achiever/screens/authentications/verifyEmail.dart';
import 'package:achiever/screens/doctor_screens/doctor_form.dart';
import 'package:achiever/screens/homeScreen.dart';
import 'package:achiever/services/storage_services.dart';
import 'package:achiever/services/toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool check = false;
  bool check1 = false;
  bool hide = true;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final proffesionController = TextEditingController();
  final auth = FirebaseAuth.instance;
  // final db = FirebaseFirestore.instance;

  // TEDDY RIVE ANIMATION PARAMETER INITIALISATION

  Artboard? _teddyArtBoard;
  SMITrigger? successTrigger, failTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? numLook;

  StateMachineController? stateMachineController;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/rive/login.riv').then((value) {
      final file = RiveFile.import(value);
      final artboard = file.mainArtboard;
      stateMachineController =
          StateMachineController.fromArtboard(artboard, "Login Machine");
      if (stateMachineController != null) {
        artboard.addController(stateMachineController!);

        stateMachineController!.inputs.forEach((element) {
          if (element.name == "trigSuccess") {
            successTrigger = element as SMITrigger;
          } else if (element.name == "trigFail") {
            failTrigger = element as SMITrigger;
          } else if (element.name == "isHandsUp") {
            isHandsUp = element as SMIBool;
          } else if (element.name == "isChecking") {
            isChecking = element as SMIBool;
          } else if (element.name == "numLook") {
            numLook = element as SMINumber;
          }
        });
      }
      setState(() {
        _teddyArtBoard = artboard;
      });
    });
  }

  void handsOnTheEyes() {
    isHandsUp?.change(true);
  }

  void lookOnTheTextField() {
    isHandsUp?.change(false);
    isChecking?.change(true);
    numLook?.change(0);
  }

  void moveEyeBalls(val) {
    numLook?.change(val.length.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xffd5e2ea),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome to",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff50a387)),
                    )),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Oncogems",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff50a387)),
                    )),
              ),
              if (_teddyArtBoard != null)
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 250.h,
                  child: Rive(artboard: _teddyArtBoard!, fit: BoxFit.cover),
                ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: TextFormField(
                          onTap: () {
                            lookOnTheTextField();
                          },
                          onChanged: moveEyeBalls,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(120))),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your email";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: TextFormField(
                          onTap: handsOnTheEyes,
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: hide,
                          decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hide = !hide;
                                  });
                                },
                                icon: hide
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(120))),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your password";
                            } else {}
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: TextFormField(
                          onTap: () {
                            lookOnTheTextField();
                          },
                          onChanged: moveEyeBalls,
                          controller: proffesionController,
                          decoration: InputDecoration(
                              hintText: "Domain",
                              labelText: "Enter your domain",
                              suffixIcon: PopupMenuButton(
                                  icon: Icon(Icons.arrow_drop_down),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Text("Doctor"),
                                          onTap: () {
                                            setState(() {
                                              proffesionController.text =
                                                  "Doctor";
                                            });
                                          },
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Text("Patient"),
                                          onTap: () {
                                            setState(() {
                                              proffesionController.text =
                                                  "Patient";
                                            });
                                          },
                                        ),
                                      ]),
                              // prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(120))),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your domain";
                            } else {}
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter,
                            LengthLimitingTextInputFormatter(7),
                          ],
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(top: 20.0.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.r),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 4,
                          minimumSize: Size(320.w, 48.h),
                          backgroundColor: const Color(0xff50a387),
                          padding: EdgeInsets.symmetric(horizontal: 30.w)),
                      onPressed: () {
                        setState(() {
                          check = true;
                        });
                        if (_formKey.currentState!.validate() &&
                            (emailController.text != null &&
                                passwordController.text != null)) {
                          setState(() {});
                          auth
                              .createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString(),
                          )
                              .then((value) {
                            isChecking?.change(false);
                            isHandsUp?.change(false);
                            //Utils(check: true).toastMessage("Succesfully SignedUp");
                            final user = auth
                                .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text)
                                .then((value) async {
                              try {
                                value.user!
                                    .sendEmailVerification()
                                    .then((value) {
                                  Get.snackbar("Oncogems",
                                      "Confirmation link sent to your email id");
                                  Timer(
                                      Duration(seconds: 1),
                                      () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VerifyEmailPage(
                                                      proffesion:
                                                          proffesionController
                                                              .text))));
                                });

                                // User? appuser = FirebaseAuth.instance.currentUser;
                                // if (appuser!.emailVerified) {
                                //   // The user's email is verified
                                //   print('Email is verified');
                                //   Utils().toastMessage("Email Verified", true);
                                //   String displayName =
                                //       value.user!.displayName ?? "Dummy User";
                                //   String email = value.user!.email.toString();
                                //   String id = value.user!.uid;
                                //   String photoUrl = value.user!.photoURL ??
                                //       "assets/images/oncogems.jpg";
                                //   UserLoginResponseEntity userProfile =
                                //       UserLoginResponseEntity();
                                //   userProfile.photoUrl = photoUrl;
                                //   userProfile.displayName = displayName;
                                //   userProfile.email = email;
                                //   userProfile.accessToken = id;
                                //   //userProfile.type = 2;
                                //   //asyncPostAllData();
                                //   await StorageService()
                                //       .saveProfile(userProfile);

                                //   // var userbase = await db
                                //   //     .collection("users")
                                //   //     .withConverter(
                                //   //       fromFirestore: UserData.fromFirestore,
                                //   //       toFirestore: (UserData userdata, options) =>
                                //   //           userdata.toFirestore(),
                                //   //     )
                                //   //     .where("id", isEqualTo: id)
                                //   //     .get();

                                //   // if (userbase.docs.isEmpty) {
                                //   //   final data = UserData(
                                //   //     id: id,
                                //   //     name: displayName,
                                //   //     email: email,
                                //   //     photourl: photoUrl,
                                //   //     location: "",
                                //   //     fcmtoken: "",
                                //   //     addtime: Timestamp.now(),
                                //   //   );
                                //   //   await db
                                //   //       .collection("users")
                                //   //       .withConverter(
                                //   //         fromFirestore: UserData.fromFirestore,
                                //   //         toFirestore:
                                //   //             (UserData userdata, options) =>
                                //   //                 userdata.toFirestore(),
                                //   //       )
                                //   //       .add(data);
                                //   // } else {}
                                //   // //toastInfo(msg: "login succesful");
                                //   // print("login succesful");
                                //   // Get.offAllNamed(AppRoutes.Application);
                                //   //Get.to(ApplicationPage());
                                //   // asyncPostAllData();        }

                                //   await StorageService()
                                //       .setString("user_id", value.user!.uid);
                                //   await StorageService().setString("user_name",
                                //       value.user!.displayName.toString());
                                //   await StorageService().setString("user_photo",
                                //       value.user!.photoURL.toString());
                                //   await StorageService().setString("user_email",
                                //       value.user!.email.toString());
                                //   setState(() {
                                //     check = false;
                                //   });
                                //   successTrigger?.fire();
                                //   Get.snackbar(
                                //       "Achiever", "Succesfully SignedIn",
                                //       colorText: const Color(0xff50a387));
                                //   if (proffesionController.text == "Doctor") {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: ((context) =>
                                //                 DoctorForm())));
                                //   } else {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: ((context) =>
                                //                 const HomeScreen())));
                                //   }
                                // }// else {
                                //   // The user's email is not verified
                                //   print('Email is not verified');
                                // }
                              } catch (e) {
                                Utils().toastMessage(e.toString(), false);
                              }
                            });
                          }).onError((error, stackTrace) {
                            setState(() {
                              check = false;
                            });
                            //print(error.toString());
                            Get.snackbar("Achiever", error.toString(),
                                colorText: Colors.red);
                            failTrigger?.fire();
                          });
                        }
                      },
                      child: check
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text("Create account")),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 12),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: const Text("Sign in"))
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(25.r),
                child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        check1 = true;
                      });
                      await Get.to(VerifyNumber());
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 4,
                        minimumSize: Size(320.w, 48.h),
                        backgroundColor: const Color(0xff50a387),
                        padding: EdgeInsets.symmetric(horizontal: 30.w)),
                    child: check1
                        ? CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          )
                        : Text("SignIn with phone number")),
              )
            ],
          ),
        ),
      ),
    );
  }
}

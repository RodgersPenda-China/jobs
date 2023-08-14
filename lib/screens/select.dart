import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/screens/JSJobSearchScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSConstant.dart';
import 'package:job_search/utils/JSImage.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';

import '../utils/JSWidget.dart';
import 'JSSignUpScreen.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({Key? key}) : super(key: key);

  @override
  _JSSignUpScreenState createState() => _JSSignUpScreenState();
}

class _JSSignUpScreenState extends State<SelectScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
          height: 100,
          color: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor,
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Positioned(
                left: 16,
                right: 16,
                bottom: 60,
                child: AppButton(
                  color: js_primaryColor,
                  onTap: () async {
                    JSSignUpScreen(type: 1,).launch(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Employee", style: boldTextStyle(color: white)),
                      8.width,
                      Icon(Icons.person, color: white, size: iconSize),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 60,
                child: AppButton(
                  color: js_primaryColor,
                  onTap: () async {
                    JSSignUpScreen(type: 2,).launch(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Employer", style: boldTextStyle(color: white)),
                      8.width,
                      Icon(Icons.business, color: white, size: iconSize),
                    ],
                  ),
                ),
              )
            ],
          )
      ),
      body: Stack(
        children: [
          Center(
              child: Image.asset('images/jobSearch/hiring.png')

          ),



          // Container(color: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Text("SELECT YOUR ROLE"),
          // ),
          // Positioned(
          //   top: 95,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     height: context.height() * 0.7,
          //     padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
          //     margin: EdgeInsets.only(bottom: 16),
          //     decoration: boxDecorationWithRoundedCorners(
          //         backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : white,
          //         borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          //         border: Border.all(color: appStore.isDarkModeOn ? white : gray.withOpacity(0.2))),
          //     child: SingleChildScrollView(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text("Ready to take the next step?", style: boldTextStyle(size: 18)),
          //           16.height,
          //           Text("Create an account and sign in.", style: secondaryTextStyle()),
          //
          //           16.height,
          //           Text("Email address *", style: boldTextStyle()),
          //           8.height,
          //           Container(
          //             height: textFieldHeight,
          //             alignment: Alignment.center,
          //             decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
          //             child: AppTextField(
          //               textFieldType: TextFieldType.EMAIL,
          //               keyboardType: TextInputType.text,
          //               decoration: jsInputDecoration(),
          //             ),
          //           ),
          //           16.height,
          //           Text("Password *", style: boldTextStyle()),
          //           8.height,
          //           Container(
          //             height: textFieldHeight,
          //             alignment: Alignment.center,
          //             decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
          //             child: AppTextField(
          //               textFieldType: TextFieldType.EMAIL,
          //               keyboardType: TextInputType.text,
          //               decoration: jsInputDecoration(),
          //             ),
          //           ),
          //           16.height,
          //           RichText(
          //             text: TextSpan(
          //               text: 'When you create an account or sign in, you agree to Indeed\'s ',
          //               style: secondaryTextStyle(),
          //               children: <TextSpan>[
          //                 TextSpan(text: 'Terms, ', style: boldTextStyle(color: js_primaryColor, decoration: TextDecoration.underline)),
          //                 TextSpan(text: 'Cookie ', style: boldTextStyle(color: js_primaryColor, decoration: TextDecoration.underline)),
          //                 TextSpan(text: 'and ', style: secondaryTextStyle()),
          //                 TextSpan(text: 'privacy ', style: boldTextStyle(color: js_primaryColor, decoration: TextDecoration.underline)),
          //                 TextSpan(text: 'policies', style: secondaryTextStyle()),
          //                 TextSpan(
          //                     text: 'you consent to receiving marketing massage from Indeed and may otp out of receiving such messages by following the unsubscribe link   in our messages, or '
          //                         'as detailed  in out terms.',
          //                     style: secondaryTextStyle()),
          //               ],
          //             ),
          //           ),
          //           16.height,
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // 16.height,
          // Positioned(
          //   left: 16,
          //   right: 16,
          //   bottom: 60,
          //   child: AppButton(
          //     color: js_primaryColor,
          //     onTap: () async {
          //     // FilePickerResult? result = await FilePicker.platform.pickFiles();
          //
          //       final ImagePicker picker = ImagePicker();
          //       final XFile? image = await picker.pickImage(source: ImageSource.gallery);
          //       print(image?.path);
          //       //JSJobSearchScreen().launch(context);
          //     },
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text("Continue", style: boldTextStyle(color: white)),
          //         8.width,
          //         Icon(Icons.arrow_forward, color: white, size: iconSize),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

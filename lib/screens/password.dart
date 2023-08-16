import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/screens/JSJobSearchScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSConstant.dart';
import 'package:job_search/utils/JSImage.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';

import '../controller/home.dart';
import '../utils/JSWidget.dart';
import 'JSProfileScreen.dart';
import 'JSSearchResultScreen.dart';

class PasswordScreen extends StatefulWidget {
  PasswordScreen({Key? key, }) : super(key: key);

  @override
  _JSSignUpScreenState createState() => _JSSignUpScreenState();
}

class _JSSignUpScreenState extends State<PasswordScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }
  void init() async {
    //
  }
  String email = ''; String password = ''; bool loading = false;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: jsAppBar(context, backWidget: true, homeAction: true),

      body: SingleChildScrollView(
        child: Column( children:[

          Container(color: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor),
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(js_SplashImage, height: 100, color: appStore.isDarkModeOn ? white : js_primaryColor),
          ),
          Container(
            // height: context.height() * 0.7,
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
            margin: EdgeInsets.only(bottom: 16),
            decoration: boxDecorationWithRoundedCorners(
                backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                border: Border.all(color: appStore.isDarkModeOn ? white : gray.withOpacity(0.2))),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Want to reset your password?", style: boldTextStyle(size: 18)),
                  16.height,
                  Text("Both Passwords Must Be 6 Characters And Above", style: secondaryTextStyle()),

                  16.height,
                  Text("New Password *", style: boldTextStyle()),
                  8.height,
                  Container(
                    height: textFieldHeight,
                    alignment: Alignment.center,
                    decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                    child: AppTextField(
                      onChanged: (v){email = v;},
                      textFieldType: TextFieldType.EMAIL,
                      keyboardType: TextInputType.text,
                      decoration: jsInputDecoration(),
                    ),
                  ),
                  16.height,
                  Text("Confirm New Password *", style: boldTextStyle()),
                  8.height,
                  Container(
                    height: textFieldHeight,
                    alignment: Alignment.center,
                    decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                    child: AppTextField(
                      onChanged: (v){password = v;},
                      textFieldType: TextFieldType.EMAIL,
                      keyboardType: TextInputType.text,
                      decoration: jsInputDecoration(),
                    ),
                  ),
                  16.height,
                  RichText(
                    text: TextSpan(
                      text: 'When you create an account or sign in, you agree to Indeed\'s ',
                      style: secondaryTextStyle(),
                      children: <TextSpan>[
                        TextSpan(text: 'Terms, ', style: boldTextStyle(color: js_primaryColor, decoration: TextDecoration.underline)),
                        TextSpan(text: 'and ', style: secondaryTextStyle()),
                        TextSpan(text: 'privacy ', style: boldTextStyle(color: js_primaryColor, decoration: TextDecoration.underline)),
                        TextSpan(text: 'policies', style: secondaryTextStyle()),
                        TextSpan(
                            text: 'you consent to receiving marketing massage from Indeed and may otp out of receiving such messages by following the unsubscribe link   in our messages, or '
                                'as detailed  in out terms.',
                            style: secondaryTextStyle()),
                      ],
                    ),
                  ),
                  16.height,
                  AppButton(
                      color: js_primaryColor,
                      onTap: () async {
                        //give an error on invalid details
                        if(password.length < 6){
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Invalid Password!',
                              message:
                              'Password 6 Characters And Above',
                              contentType: ContentType.failure,
                            ),
                          );
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                          Get.snackbar('Error', 'Email is Empty',
                              snackPosition: SnackPosition.BOTTOM); return;
                        }else if(email != password){
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Invalid Passwords',
                              message:
                              'New Password And Confirm Password Are Not The Same',
                              contentType: ContentType.failure,
                            ),
                          );
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                          return;
                        }
                        setState(() {loading = true;});
                        await Get.find<HomeController>().update_password(password);
                        var bl = Get.find<HomeController>().login_response;

                        if(bl['error'] == 0){
                          setState(() {loading = false;});
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Success',
                              message:'Password Changed Successfull',
                              contentType: ContentType.success,
                            ),
                          );
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        }
                        else if(bl['error'] == 1){
                          setState(() {loading = false;});
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Error',
                              message:bl['message'],
                              contentType: ContentType.failure,
                            ),
                          );
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        }
                      },
                      child: loading == false? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Update Password", style: boldTextStyle(color: white)),
                          8.width,
                          // CircularProgressIndicator(color: Colors.white,),
                        ],
                      ):Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Loading", style: boldTextStyle(color: white)),
                          8.width,
                          CircularProgressIndicator(color: Colors.white,),
                        ],
                      )
                  ),
                  // )
                ],
              ),
            ),
          ),


        ]),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/screens/JSHomeScreen.dart';
import 'package:job_search/screens/JSNotificationScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSConstant.dart';
import 'package:job_search/utils/JSImage.dart';
import 'package:job_search/main.dart';

import '../screens/JSMessagesScreen.dart';
import '../screens/JSSearchResultScreen.dart';

Widget googleSignInWidget({String? loginLogo, String? btnName, Function? onTapBtn, double? logoHeight, double? logoWidth}) {
  return OutlinedButton(
    onPressed: () {
      onTapBtn!();
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        commonCachedNetworkImage(loginLogo!, height: logoHeight!, width: logoWidth!, fit: BoxFit.cover),
        24.width,
        Text(btnName!, style: boldTextStyle()),
      ],
    ).paddingOnly(top: 8, bottom: 8, right: 8),
  );
}

InputDecoration jsInputDecoration({Icon? icon, String? hintText, Icon? prefixIcon, bool? showPreFixIcon}) {
  return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: gray.withOpacity(0.4)),
      ),
      hintText: hintText,
      hintStyle: secondaryTextStyle(),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: js_primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: gray.withOpacity(0.4)),
      ),
      filled: true,
      fillColor: appStore.isDarkModeOn ? scaffoldDarkColor : white,
      suffixIcon: icon.validate(),
      prefixIcon: showPreFixIcon.validate() ? prefixIcon.validate() : null);
}

PreferredSizeWidget jsAppBar(BuildContext context, {VoidCallback? callBack, bool? backWidget, bool? homeAction, bool? bottomSheet, bool? message, bool? notifications}) {
  return appBarWidget(
    '',
    color: appStore.isDarkModeOn ? cardDarkColor : white,
    elevation: 0.0,
    backWidget: backWidget.validate()
        ? IconButton(
            icon: Icon(Icons.arrow_back_ios, size: iconSize),
            color: appStore.iconColor,
            onPressed: () {
              finish(context);
            })
        : SizedBox.shrink(),
    actions: [
      homeAction.validate()
          ? IconButton(
              onPressed: () {
                JSSearchResultScreen().launch(context);
              },
              icon: Icon(Icons.home, size: 24),
              color: appStore.iconColor)
          : SizedBox.shrink(),
    ],
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(bottomSheet.validate() ? 20 : 0),
      child: bottomSheet.validate()
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  js_SplashImage,
                  height: 30,
                  width: 80,
                  fit: BoxFit.cover,
                  color: appStore.isDarkModeOn ? white : js_primaryColor,
                ).paddingOnly(left: 8),
                Row(
                  children: [
                    message.validate()
                        ? IconButton(
                            onPressed: () {
                              //JSMessagesScreen
                              JSMessagesScreen().launch(context);
                            },
                            icon: Icon(Icons.message))
                        : SizedBox(),
                    IconButton(onPressed: callBack, icon: Icon(Icons.menu)),
                  ],
                ),
              ],
            )
          : SizedBox(),
    ),
  );
}

Widget jsCompleteProfileStep(BuildContext context, {int? stepSubTitle, bool? hideCV}) {
  return Container(
    color: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor,
    width: context.width(),
    padding: EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Create an Indeed CV", style: boldTextStyle(size: 22)),
        8.height,
        hideCV == true
            ? RichText(
                text: TextSpan(
                  text: 'Or ',
                  style: primaryTextStyle(),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Upload a CV',
                      style: boldTextStyle(color: js_textColor, decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              )
            : SizedBox(),
        8.height,
        Text("${"Step"} ${stepSubTitle!} ${"of 5"}", style: secondaryTextStyle(size: 16))
      ],
    ),
  );
}

Widget commonCachedNetworkImage(
  String? url, {
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
  Color? color,
}) {
  if (url!.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return CircularProgressIndicator(color: Colors.blue,);
        return CircularProgressIndicator(color: Colors.blue,);
      },
    );
  } else {
    return  CircularProgressIndicator(color: Colors.blue,);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return CircularProgressIndicator(color: Colors.white,);
}

Widget filteredWidget({Widget? widget}) {
  return Container(
    child: widget,
    decoration: boxDecorationWithRoundedCorners(
      borderRadius: BorderRadius.circular(8),
      backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor,
    ),
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  );
}

Widget jsGetTitle(String content) {
  return Text(content, style: boldTextStyle());
}

Widget jsGetPrimaryTitle(String content) {
  return Text(content, style: primaryTextStyle());
}

Widget jsGetSubTitle(String content) {
  return Padding(
    padding: EdgeInsets.fromLTRB(16.0, 8, 16.0, 8),
    child: Text(content, style: secondaryTextStyle()),
  );
}

BoxDecoration boxDecoration({double radius = 2, Color color = Colors.transparent, Color? bgColor, var showShadow = false}) {
  return BoxDecoration(
    color: bgColor ?? appStore.scaffoldBackground,
    boxShadow: showShadow ? defaultBoxShadow(shadowColor: shadowColorGlobal) : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}
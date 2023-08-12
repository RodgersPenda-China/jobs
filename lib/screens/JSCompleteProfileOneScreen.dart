import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/screens/JSCompleteProfileTwoScreen.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSConstant.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';

import '../controller/api.dart';
import '../controller/home.dart';


class JSCompleteProfileOneScreen extends StatefulWidget {
  const JSCompleteProfileOneScreen({Key? key}) : super(key: key);

  @override
  _JSCompleteProfileOneScreenState createState() => _JSCompleteProfileOneScreenState();
}

class _JSCompleteProfileOneScreenState extends State<JSCompleteProfileOneScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  TextEditingController fNameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode surnameFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode phoneNumFocus = FocusNode();


  late File image ;bool has_image = false;String f_name = '';String l_name = '';
  String location = '';String phone = ''; String gender = ''; bool loading = false;
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
      key: scaffoldKey,
      appBar: jsAppBar(context, notifications: false, message: false, bottomSheet: true, backWidget: true, homeAction: true, callBack: () {
        setState(() {});
        scaffoldKey.currentState!.openDrawer();
      }),
      drawer: JSDrawerScreen(),
      body: GetBuilder<HomeController>(builder: (authController){
        return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? im = await picker.pickImage(source: ImageSource.gallery);
                      image = File(im!.path);
                      setState(() {has_image = true;});
                    },
                    child:Center(child:Container(
                      height: has_image?120:80,
                  decoration: boxDecorationWithRoundedCorners(
                    boxShape: BoxShape.circle,
                    border: Border.all(color: js_primaryColor, width: 4),
                    backgroundColor: context.scaffoldBackgroundColor,
                  ),
                  padding: EdgeInsets.all(18),
                  child: has_image == false?Text('RP', style: boldTextStyle(size: 22))
                      : Image.file(image,height: 140,),
                ))),
                Text("Profile", style: boldTextStyle(size: 20)),
                28.height,
                Text("* Required fields", style: secondaryTextStyle(size: 16)),
                16.height,
                Text("First Name *", style: boldTextStyle()),
                Container(
                  height: textFieldHeight,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 16),
                  decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                  child: AppTextField(
                    initialValue: f_name,
                    onChanged: (v){f_name = v;},
                    // controller: fNameController,
                    focus: fNameFocus,
                    nextFocus: surnameFocus,
                    textFieldType: TextFieldType.NAME,
                    keyboardType: TextInputType.text,
                    decoration: jsInputDecoration(),
                  ),
                ),
                16.height,
                Text("Surname *", style: boldTextStyle()),
                Container(
                  height: textFieldHeight,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 16),
                  decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                  child: AppTextField(
                    initialValue: l_name,
                    onChanged: (v){l_name = v;},
                    // controller: surnameController,
                    focus: surnameFocus,
                    nextFocus: addressFocus,
                    textFieldType: TextFieldType.NAME,
                    decoration: jsInputDecoration(),
                  ),
                ),
                16.height,
                Row(
                  children: [
                    Text("Location*", style: boldTextStyle()),
                  ],
                ),
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 16),
                  decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                  child: DropdownSearch<String>(

                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(labelText: "Search By Place Name"),
                    ),
                    popupProps: PopupProps.modalBottomSheet(
                        showSearchBox: true,
                        isFilterOnline: true
                    ),
                    asyncItems: (String filter) => authController.google_autocomplete(filter),
                    onChanged: (print){
                      location = print!;
                    },
                  ),
                ),
                16.height,
                Row(
                  children: [
                    Text("Gender*", style: boldTextStyle()),
                  ],
                ),
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 16),
                  decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                  child: DropdownSearch<String>(
                    items: ['Male','Female'],
                    popupProps:PopupProps.menu(),
                    onChanged: (print){
                      gender = print!;
                    },
                    selectedItem: 'Male',
                  ),
                ),
                16.height,
                Text("Phone*", style: boldTextStyle()),
                Container(
                  height: textFieldHeight,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 16),
                  decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                  child: AppTextField(
                    initialValue: phone,
                    onChanged: (v){phone = v;},
                    //controller: phoneNumController,
                    focus: phoneNumFocus,
                    textFieldType: TextFieldType.PHONE,
                    decoration: jsInputDecoration(),
                  ),
                ),
                24.height,
                Center(
                  child:AppButton(
                    color: js_primaryColor,
                    width: 300,
                    onTap: () async {
                      bool error = false; String message = '';
                      print(phone.length);
                      if(location == ''){
                      error = true; message = 'Location Not Selected';
                      }else if(f_name == ''){
                        error = true; message = 'First Name Is Empty';
                      } else if(l_name == ''){
                        error = true; message = 'Last Name Is Empty';
                      } else if(phone.length != 10){
                        error = true; message = 'Phone Number Shoube Be 10 Digits';
                      }else if(has_image == false){
                        error = true; message = 'Image Not Selected';
                      }
                      var place = {};
                      if(error == true){
                        final snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Error',
                            message:message,
                            contentType: ContentType.failure,
                          ),
                        );
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                      } else {
                        String place_id = '';
                        var jk =Get.find<HomeController>().google_response;
                        for(int i = 0; i < jk.length;i++){
                          if(jk[i]['name'] == location){
                            place_id = jk[i]['place_id'];
                          }
                        }
                         print(location);

                      //cover the image to an uploadable format
                      List<MultipartBody> files = [];
                      files.add(MultipartBody('0',image));
                      setState(() {loading = true;});
                      await Get.find<HomeController>().personal_details(f_name,l_name,gender,phone,location,place_id,files);
                      var results = Get.find<HomeController>().personal_reponse;
                      if(results['error'] == 0){
                        final snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Success',
                            message:'Data Saved Successfully',
                            contentType: ContentType.success,
                          ),
                        );
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                      } else {
                        final snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Failed',
                            message:'An Error Occurred, Try Another Time',
                            contentType: ContentType.failure,
                          ),
                        );
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                      }
                      setState(() {loading = false;});
                      } },
                    child: loading?CircularProgressIndicator(color: Colors.white):Text("Save", style: boldTextStyle(color: white)),
                  ),
                )

              ],
            ).paddingOnly(left: 16, right: 16, top: 8, bottom: 24),
          ],
        ),
      );
    })
    );
  }
}
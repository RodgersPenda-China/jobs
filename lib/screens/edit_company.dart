import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_search/model/user.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/screens/JSCompleteProfileTwoScreen.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSConstant.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';

import '../controller/api.dart';
import '../controller/home.dart';
import 'compamy.dart';


class EditMoney extends StatefulWidget {
  List<User> kl;
  EditMoney({Key? key,required this.kl}) : super(key: key);

  @override
  _JSCompleteProfileOneScreenState createState() => _JSCompleteProfileOneScreenState();
}

class _JSCompleteProfileOneScreenState extends State<EditMoney> {
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
  final HtmlEditorController controller = HtmlEditorController();


  late File image ;bool has_image = false;String f_name = '',description='';String l_name = ''; String i_image = '';
  String location = '';String phone = ''; String gender = 'Male'; bool loading = false;
  List<dynamic> images = [];
  @override
  void initState() {
    super.initState();
    init();
    if(widget.kl[0].name != 'Please Edit'){
      phone = widget.kl[0].phone;
      f_name = widget.kl[0].f_name;
      l_name = widget.kl[0].l_name;
      gender = widget.kl[0].gender;
      location = widget.kl[0].location;
      i_image = widget.kl[0].image;
      Future.delayed(
        const Duration(seconds: 8),
            () {
          print('here!!');
          setState(
                () {
              controller.setText(widget.kl[0].description);

            },
          );
        },
      );
    }
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
                          child: has_image == false? i_image != ''?Image.network(widget.kl[0].image):Text('RP', style: boldTextStyle(size: 22))
                              : Image.file(image,height: 140,),
                        ))),
                    Text("Profile", style: boldTextStyle(size: 20)),
                    28.height,
                    Text("* Required fields", style: secondaryTextStyle(size: 16)),
                    16.height,
                    Text("Short Name *", style: boldTextStyle()),
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
                    Text("Long Name *", style: boldTextStyle()),
                    Container(
                      height: 60,
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
                        selectedItem: location,
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
                        selectedItem: gender,
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
                    // Text("Photos (Maximum: 4)*", style: boldTextStyle()),
                    // Row(
                    //   children: [
                    //     for(int i = 0; i < images.length;i++)
                    //     Expanded(child:
                    //     Container(
                    //       width: 100,
                    //         child:
                    //     Card(
                    //       elevation: 2,
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8)
                    //       ),
                    //       child: Center(
                    //         child: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: <Widget>[
                    //             Icon(Icons.close),
                    //             images[i].runtimeType.toString() == 'String'?
                    //             CachedNetworkImage(height: 100,
                    //               imageUrl: images[i],
                    //               progressIndicatorBuilder: (context, url, downloadProgress) =>
                    //                   CircularProgressIndicator(value: downloadProgress.progress),
                    //               errorWidget: (context, url, error) => Icon(Icons.error),
                    //             )
                    //
                    //                 :Image.file(images[i],height: 100,)
                    //           ],
                    //         ),
                    //       ),
                    //     ))),
                    //
                    //   ],
                    // ),
                       Center( child: ElevatedButton(onPressed: () async {
                         //upload pictures
                         if(images.length > 4){return;}
                         FilePickerResult? result = await FilePicker.platform.pickFiles();


                         if (result != null) {
                           setState(() {
                             images.add(File(result.files.single.path!));

                           });
                           // ik = false;
                         } else {
                           // User canceled the picker
                         }
                       }, child: Text('Upload'))),
                    Text("Description*", style: boldTextStyle()),
                    HtmlEditor(
                      controller: controller,
                      htmlEditorOptions: HtmlEditorOptions(
                        autoAdjustHeight: true,
                        hint:  'Describe Yourself',
                        shouldEnsureVisible: true,
                        adjustHeightForKeyboard: true,
                      ),
                      htmlToolbarOptions: HtmlToolbarOptions(
                        toolbarPosition: ToolbarPosition.aboveEditor,
                        toolbarType: ToolbarType.nativeGrid,
                        //by default
                        gridViewHorizontalSpacing: 0,
                        gridViewVerticalSpacing: 0,
                        dropdownBackgroundColor: Colors.white60,
                        toolbarItemHeight: 40,
                        buttonColor: Colors.black,
                        buttonFocusColor: Colors.black,
                        buttonBorderColor: Colors.red,
                        buttonFillColor: Colors.blue,
                        dropdownIconColor: Colors.blue,
                        dropdownIconSize: 26,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        onDropdownChanged: (DropdownType type, dynamic changed,
                            Function(dynamic)? updateSelectedItem) {
                          return true;
                        },
                        mediaLinkInsertInterceptor:
                            (String url, InsertFileType type) {
                          return true;
                        },
                        mediaUploadInterceptor:
                            (PlatformFile file, InsertFileType type) async {
                          return true;
                        },
                      ),
                      otherOptions: OtherOptions(
                        height: 550,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                      ),
                      callbacks: Callbacks(
                        onBeforeCommand: (String? currentHtml) {},
                        onChangeContent: (String? changed) {
                          setState(() {
                            description = changed!;

                          });
                        },
                        onChangeCodeview: (String? changed) {
                          // print(changed); print('kuno');

                        },
                        onNavigationRequestMobile: (String url) {
                          return NavigationActionPolicy.ALLOW;
                        },
                      ),
                    ),
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
                          }else if(has_image == false && widget.kl[0].image == ''){
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
                            print(place_id);

                            //cover the image to an uploadable format
                            List<MultipartBody> files = [];
                            if(has_image == true) {
                              files.add(MultipartBody('0', image));
                            }
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
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (ctx) => EmployeeScreen()), (route) => false);
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

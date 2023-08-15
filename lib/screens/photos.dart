import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/screens/JSJobSearchScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSConstant.dart';
import 'package:job_search/utils/JSImage.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';
import 'dart:io';
import '../components/JSDrawerScreen.dart';
import '../controller/api.dart';
import '../controller/home.dart';
import '../utils/JSWidget.dart';
import 'JSSignUpScreen.dart';
import 'package:http/http.dart' as http;

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  _JSSignUpScreenState createState() => _JSSignUpScreenState();
}

class _JSSignUpScreenState extends State<PhotosScreen> {
  @override
  bool loading = true;
  void initState() {
    super.initState();
    init();
  }
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String url = "https://x.smartbuybuy.com/job/index.php?get_photos=1&token=${token}";
    setState(() {
      loading = true;
    });
    print(url);
    final response = await http.get(Uri.parse(url));
    setState(() {
      loading = false;
      images= jsonDecode(response.body);
    });
    print('object');
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
  List<dynamic> images = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: ,
        key: scaffoldKey,
        drawer: JSDrawerScreen(),
        appBar: jsAppBar(context, notifications: false, message: false, bottomSheet: true, backWidget: false, homeAction: false, callBack: () {
          setState(() {});
          scaffoldKey.currentState!.openDrawer();
        }),
        body:
        GetBuilder<HomeController>(builder: (authController){
      return
        loading? Center(child: CircularProgressIndicator(color: Colors.blue,),):
        Column(
          children: [
            Text("Photos (Maximum: 4)*", style: boldTextStyle()),
            Row(
              children: [
                for(int i = 0; i < images.length;i++)
                Expanded(child:
                Container(
                  width: 100,
                    child:
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              images.removeAt(i);

                            });
                          },
                          child: Icon(Icons.close,color: Colors.red,),
                        ),
                        images[i].runtimeType.toString() == 'String'?
                        CachedNetworkImage(height: 100,
                          imageUrl: images[i],
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              CircularProgressIndicator(value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        )

                            :Image.file(images[i],height: 100,)
                      ],
                    ),

                  ),
                ))),

              ],
            ),
            Center( child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () async {
                    //upload pictures
                    if(images.length >= 4){
                    EasyLoading.showToast('Maximum Number Of Photos Reached');
                    return;}
                    FilePickerResult? result = await FilePicker.platform.pickFiles();


                    if (result != null) {
                    setState(() {
                    images.add(File(result.files.single.path!));

                    });
                    }
            }, child: Text('Pick Photos')),
                ElevatedButton(onPressed: () async {
                  //upload pictures
                  List<File> kb = []; List<String> web = [];
                  for(int i = 0; i < images.length;i++){
                    if(images[i].runtimeType.toString() == '_File'){
                      kb.add(images[i]);
                    }else{
                      web.add(images[i]);
                    }
                  }
                  print(web);
                  List<MultipartBody> files = [];
                  for(int i = 0; i < kb.length;i++){
                    files.add(MultipartBody(i.toString(), kb[i]));
                  }

                  await Get.find<HomeController>().upload_photos(web, files);
                  EasyLoading.showToast('Images Uploaded Successfully');
                }, child: authController.photos_loading?CircularProgressIndicator(color: Colors.white,):
                Text('Upload')),
              ],
            )
            )
          ],
        );})

    );
  }
}

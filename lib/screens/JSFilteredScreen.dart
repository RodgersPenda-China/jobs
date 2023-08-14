import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/components/JSDatePostedComponent.dart';
import 'package:job_search/components/JSRemoteFilterComponent.dart';
import 'package:job_search/components/JSSortByComponent.dart';
import 'package:job_search/model/JSPopularCompanyModel.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSDataGenerator.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:http/http.dart' as http;

import '../controller/home.dart';

class JSFilteredScreen extends StatefulWidget {
  var filter = {};
  JSFilteredScreen({Key? key,required this.filter}) : super(key: key);

  @override
  _JSFilteredScreenState createState() => _JSFilteredScreenState();
}

class _JSFilteredScreenState extends State<JSFilteredScreen> {
  int? remoteValue = 0;

  List<JSPopularCompanyModel> remoteList = getRemoteList();
  bool category_loading = false; bool city_loading = false;
  var category = []; var  city = [];
  var category_array = {}; var city_array = {};
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    String url = "https://x.smartbuybuy.com/job/index.php?get_categories=1";
    print(url);
    setState(() {
      category_loading = true;
    });

    final response = await http.get(Uri.parse(url));
    setState(() {
      // category_loading = false;
      category = json.decode(response.body);
    });
    for(int i = 0; i < category.length;i++){
      if(Get.find<HomeController>().category_array.containsKey(category[i])){
        category_array[category[i]]  =  Get.find<HomeController>().category_array[category[i]];
      }else{
        category_array[category[i]] = false;
      }
    }
    setState(() {
      category_loading = false;
    });
    print(category_array);

    String iurl = "https://x.smartbuybuy.com/job/index.php?get_city=1";
    print(url);
    setState(() {
      city_loading = true;
    });
    final res = await http.get(Uri.parse(iurl));
    setState(() {
      city_loading = false;
      city = json.decode(res.body);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: jsAppBar(context, bottomSheet: false, backWidget: true, homeAction: true),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: boxDecorationWithRoundedCorners(
                  boxShadow: [
                    BoxShadow(spreadRadius: 0.8, blurRadius: 1, color: gray.withOpacity(0.8)),
                  ],
                  borderRadius: BorderRadius.circular(0),
                  backgroundColor: context.scaffoldBackgroundColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: js_primaryColor, width: 2),
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                      child: IconButton(
                          onPressed: () {
                            finish(context);
                          },
                          icon: Icon(Icons.close)),
                    ),
                    TextButton(onPressed: () {}, child: Text("Filters", style: boldTextStyle())),
                    // TextButton(
                    //     onPressed: () {
                    //       finish(context);
                    //     },
                    //     child: Text("Reset", style: boldTextStyle(color: js_primaryColor))),
                  ],
                ).paddingOnly(left: 8, right: 8, bottom: 16),
              ),
              24.height,
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Category", style: boldTextStyle(size: 18)).paddingOnly(left: 16),
                    16.height,
                    category_loading? Center(child: CircularProgressIndicator(color: Colors.blue,))
                    :ListView.builder(
                        itemCount: category.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        itemBuilder: (_, i) {
                         // JSPopularCompanyModel data = remoteList[i];
                          return Theme(
                            data: Theme.of(context).copyWith(unselectedWidgetColor: Theme.of(context).iconTheme.color),
                            child: CheckboxListTile(
                              dense: category_array[category[i]],
                              contentPadding: EdgeInsets.only(left: 0, bottom: 0),
                              activeColor: js_primaryColor, 
                              value: category_array[category[i]],
                             // groupValue: remoteValue,
                              onChanged: (bool? val) {
                                print(val);
                                setState(() {
                                  category_array[category[i]] = val;
                                });
                               },
                              title: Text(category[i], style: primaryTextStyle()),
                            ),
                          );
                        }),
                    Divider(color: gray.withOpacity(0.4)),
                    24.height,
                    Text("City", style: boldTextStyle(size: 18)).paddingOnly(left: 16),
                    16.height,
                    city_loading? Center(child: CircularProgressIndicator(color: Colors.blue,)):
                    ListView.builder(
                        itemCount: city.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        itemBuilder: (_, i) {
                          JSPopularCompanyModel data = remoteList[i];
                          return Theme(
                            data: Theme.of(context).copyWith(unselectedWidgetColor: Theme.of(context).iconTheme.color),
                            child: CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.only(left: 0, bottom: 0),
                              activeColor: js_primaryColor,
                              value: true,
                              // groupValue: remoteValue,
                              onChanged: (bool? val) {
                                print(val);
                                setState(() {
                                  //remoteValue = val;
                                });
                              },
                              title: Text(city[i], style: primaryTextStyle()),
                            ),
                          );
                        }),

                  ],
                ),
              ).expand(),
            ],
          ).paddingOnly(bottom: 80),
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: AppButton(
              onTap: () {
                var cat = ''; int count = 0;
                for(int i = 0; i < category_array.length;i++){
                  if(category_array[category[i]] == true){
                    cat += ','+category[i];
                    count++;
                  } else{
                    print(category_array[category[i] ]);
                  }
                }
                Get.find<HomeController>().category_array = category_array;
                String city=widget.filter['city']!,type=widget.filter['type']!,
                    remote=widget.filter['remote']!;print('object');
                print(Get.find<HomeController>().category_array.containsKey('Administration'));
                Get.find<HomeController>().filter(cat,city,type,remote);
                finish(context);
              },
              //width: context.width(),
              margin: EdgeInsets.all(16),
              color: js_primaryColor,
              child: Text("Update", style: boldTextStyle(color: white)),
            ),
          )
        ],
      ),
    );
  }
}

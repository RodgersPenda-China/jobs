import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:job_search/components/JSPopularCompanyComponent.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/main.dart';
import 'package:job_search/screens/JSJobSearchScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSConstant.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../model/JSPopularCompanyModel.dart';
import '../utils/JSDataGenerator.dart';
import '../utils/flutter_rating_bar.dart';
import 'JSCompanyProfileScreens.dart';
import 'JSSearchResultScreen.dart';


class JSJobCompanies extends StatefulWidget {
  const JSJobCompanies({Key? key}) : super(key: key);

  @override
  _JSJobCompaniesState createState() => _JSJobCompaniesState();
}

class _JSJobCompaniesState extends State<JSJobCompanies> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<JSPopularCompanyModel> popularCompanyList = getPopularCompanyData();
  @override
  void initState() {
    super.initState();
    init();
  }
  bool loading = true; var companies = [];

  void init() async {
    String url = "http://api.ioevisa.net/api/job/index.php?get_companies=1";
    setState(() {
      loading = true;
    });
    print(url);
    final response = await http.get(Uri.parse(url));
    setState(() {
      loading = false;
      companies = json.decode(response.body);
    });
    print('object');
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: jsAppBar(context,notifications: false,message: false,bottomSheet: true,backWidget: true,homeAction: true,callBack: () {
        setState(() {});
        scaffoldKey.currentState!.openDrawer();
      }),
      drawer: JSDrawerScreen(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                Text("Find great Place to work", style: boldTextStyle(size: 22)),
                8.height,
                Text("Get access to millions of company", style: secondaryTextStyle()),
                8.height,
                Text("Feel Safe With Us", style: boldTextStyle()),
                16.height,
                8.height,
                AppButton(
                  color: js_primaryColor,
                  width: context.width(),
                  onTap: () {
                    JSSearchResultScreen().launch(context);
                    // JSJobSearchScreen().launch(context);
                  },
                  child: Text("Browse Jobs", style: boldTextStyle(color: white)),
                ),
                16.height,
                // Text("Do you want to search for salaries?", style: boldTextStyle(color: js_textColor.withOpacity(0.7), decoration: TextDecoration.underline), textAlign: TextAlign.center).center(),
                32.height,

             loading?Shimmer.fromColors(child:         ListView.separated(
               itemCount: 2,
               padding: EdgeInsets.all(8),
               shrinkWrap: true,
               physics: NeverScrollableScrollPhysics(),
               separatorBuilder: (BuildContext context, int index) => Divider(),
               itemBuilder: (context, index) {
                 JSPopularCompanyModel data = popularCompanyList[index];

                 return Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       children: [
                         commonCachedNetworkImage(data.companyImage.validate(), height: 50, width: 50, fit: BoxFit.contain),
                         16.width,
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(data.companyName.validate(), style: boldTextStyle()),
                             4.height,
                             Row(
                               children: [
                                 Text('200 Jobs', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))
                               ],
                             ),
                           ],
                         ),
                       ],
                     ),
                     6.height,
                     Row(
                       children: [
                         Icon(Icons.location_pin),
                         8.width,
                         Text('Meanwood', style: secondaryTextStyle()),
                       ],
                     ),
                   ],
                 ).onTap(() {
                   // JSCompanyProfileScreens(popularCompanyList: data).launch(context);
                 });
               },
             ),
                 baseColor: Colors.red, highlightColor: Colors.blue):

             ListView.separated(
        itemCount: companies.length,
            padding: EdgeInsets.all(8),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (context, index) {
          JSPopularCompanyModel data = popularCompanyList[index];

          return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  JSCompanyProfileScreens(id: companies[index]['id'],employer: 0,).launch(context);
                },
                child: Row(
                  children: [
                    commonCachedNetworkImage(companies[index]['image'], height: 50, width: 50, fit: BoxFit.contain),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(companies[index]['short_name'], style: boldTextStyle()),
                        4.height,
                        Row(
                          children: [
                            Text('${companies[index]['jobs']} Jobs', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
              ,
              6.height,
              Row(
                children: [
                  Icon(Icons.location_on,color: Colors.blue,),
                  8.width,
                  Text('${companies[index]['location']}', style: secondaryTextStyle(color: Colors.blue)),
                ],
              ),
            ],
          ).onTap(() {
            // JSCompanyProfileScreens(popularCompanyList: data).launch(context);
          });
        },
      ),
              ],
            ).paddingOnly(left: 16, right: 16, bottom: 24)
          ],
        ),
      ),
    );
  }
}

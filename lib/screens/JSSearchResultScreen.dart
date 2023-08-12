import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/components/JSFilteredResultsComponent.dart';
import 'package:job_search/screens/JSFilteredScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';

import '../components/JSJobDetailComponent.dart';
import '../components/JSRemoveJobComponent.dart';
import '../model/JSPopularCompanyModel.dart';
import '../utils/JSConstant.dart';
import '../utils/JSDataGenerator.dart';
import '../widgets/JSFilteredResultWidget.dart';
import 'JSHomeScreen.dart';

class JSSearchResultScreen extends StatefulWidget {
  final String? jobTitle;
  final String? city;

  JSSearchResultScreen({this.jobTitle, this.city});

  @override
  _JSSearchResultScreenState createState() => _JSSearchResultScreenState();
}

class _JSSearchResultScreenState extends State<JSSearchResultScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  String daysValue = 'Date Posted';

  var daysItems = ['Date Posted', 'Last 1 days', 'Last 2 days', 'Last 3 days', 'Last 4 days'];

  String jobCategoryValue = 'Job Category';

  var jobCategoryItems = ['Job Category', 'Web Designer', 'Project Manager', 'Graphics Designer', 'Team Leader'];

  String salaryValue = 'All Salaries';
  List<JSPopularCompanyModel> filteredResultsList = getFilteredResultsData();

  var salaryItems = ['All Salaries', '\$40,000', '\$45,000', '\$50,0000', '\$55,0000'];

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
      appBar: jsAppBar(context, notifications: true, message: true, bottomSheet: true, backWidget: false, homeAction: false, callBack: () {

        setState(() {});
        scaffoldKey.currentState!.openDrawer();
      }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: textFieldHeight,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24),
            decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
            child: AppTextField(
              textFieldType: TextFieldType.NAME,
              decoration: jsInputDecoration(
                hintText: "Search for jobs title, keyword or company",
                prefixIcon: Icon(Icons.search,color: context.iconColor,size: 20),
              ),
            ),
          ),
          Container(height: 10, color: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor),
          8.height,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                filteredWidget(widget: Icon(Icons.filter_list, size: 18)).cornerRadiusWithClipRRect(8).onTap(() {
                  JSFilteredScreen().launch(context);
                }),
                8.width,
                filteredWidget(widget: Text("Remote", style: primaryTextStyle(size: 14))),
                8.width,
                Container(
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor,
                  ),
                  height: 35,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: DropdownButton(
                    isExpanded: false,
                    underline: Container(color: Colors.transparent),
                    value: daysValue,
                    icon: Icon(Icons.arrow_drop_down),
                    items: daysItems.map((String daysItems) {
                      return DropdownMenuItem(
                        value: daysItems,
                        child: Text(daysItems, style: primaryTextStyle(size: 14)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        daysValue = newValue!;
                      });
                    },
                  ),
                ),
                8.width,
                Container(
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor,
                  ),
                  height: 35,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: DropdownButton(
                    isExpanded: false,
                    underline: Container(color: Colors.transparent),
                    value: jobCategoryValue,
                    icon: Icon(Icons.arrow_drop_down),
                    items: jobCategoryItems.map((String jobCategoryItems) {
                      return DropdownMenuItem(
                        value: jobCategoryItems,
                        child: Text(jobCategoryItems, style: primaryTextStyle(size: 14)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        jobCategoryValue = newValue!;
                      });
                    },
                  ),
                ),
                8.width,
                Container(
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor,
                  ),
                  height: 35,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: DropdownButton(
                    isExpanded: false,
                    underline: Container(color: Colors.transparent),
                    value: salaryValue,
                    icon: Icon(Icons.arrow_drop_down),
                    items: salaryItems.map((String salaryItems) {
                      return DropdownMenuItem(
                        value: salaryItems,
                        child: Text(salaryItems, style: primaryTextStyle(size: 14)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        salaryValue = newValue!;
                      });
                    },
                  ),
                ),
                8.width,
                filteredWidget(widget: Text("Applications", style: primaryTextStyle(size: 14))),
              ],
            ),
          ),
          8.height,
          Text(
            "${widget.jobTitle.validate()} jobs in ${widget.city.validate()}, Greater ${widget.city.validate()}",
            style: primaryTextStyle(),
            textAlign: TextAlign.start,
          ).paddingOnly(left: 16),
          4.height,
          Row(
            children: [
              Text("page 1 of 545 jobs", style: secondaryTextStyle()),
              4.width,
              Icon(Icons.help, color: gray.withOpacity(0.5), size: 18),
            ],
          ).paddingOnly(left: 16),
          16.height,
      SingleChildScrollView(
        child: ListView.builder(
          itemCount: filteredResultsList.length,
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            JSPopularCompanyModel data = filteredResultsList[index];
            !data.isBlocked!
                ? Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(spreadRadius: 0.6, blurRadius: 1, color: gray.withOpacity(0.5)),
                ],
                backgroundColor: context.scaffoldBackgroundColor,
              ),
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("new", style: primaryTextStyle(size: 14)),
                      Icon(
                        data.selectSkill.validate() ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: data.selectSkill.validate()
                            ? js_primaryColor
                            : appStore.isDarkModeOn
                            ? white
                            : black,
                      ).onTap(() {
                        data.selectSkill = !data.selectSkill.validate();
                        setState(() {});
                      }),
                    ],
                  ),
                  8.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.companyName.validate(), style: boldTextStyle()),
                      8.width,
                      Icon(Icons.block, size: 20).onTap(() {
                        data.isBlocked = !data.isBlocked.validate();
                        setState(() {});
                      }),
                    ],
                  ),
                  4.height,
                  Text(data.totalReview.validate(), style: primaryTextStyle()),
                  4.height,
                  Text("Remote in ${widget.city.validate()}", style: primaryTextStyle()),
                  8.height,
                  Container(
                    decoration: boxDecorationRoundedWithShadow(
                      8,
                      backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor,
                    ),
                    padding: EdgeInsets.all(8),
                    //width: 165,
                    child: Row(
                      children: [
                        Icon(Icons.payment, size: 18),
                        4.width,
                        Text(
                          data.companyImage.validate(),
                          style: boldTextStyle(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).flexible(),
                      ],
                    ),
                  ),
                  16.height,
                  Row(
                    children: [
                      Icon(Icons.send, size: 18, color: js_primaryColor),
                      4.width,
                      Text("Apply with your Indeed CV", style: secondaryTextStyle()),
                    ],
                  ),
                  8.height,
                  Row(
                    children: [
                      Icon(Icons.person_add_alt_1, size: 18, color: Colors.red),
                      4.width,
                      Text("Hiring multiple candidates", style: secondaryTextStyle()),
                    ],
                  ),
                  8.height,
                  Row(
                    children: [
                      Icon(Icons.timer, size: 18, color: gray.withOpacity(0.8)),
                      4.width,
                      Text("Urgently needed", style: secondaryTextStyle()),
                    ],
                  ),
                  16.height,
                  Text(data.totalDays.validate(), style: secondaryTextStyle()),
                ],
              ),
            ).onTap(() {
              // Add BottomSheet Code
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.90,
                    child: Stack(
                      children: [
                        JSJobDetailComponent(filteredResultsList: data),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 8,
                          child: AppButton(
                            onTap: () {
                              JSHomeScreen().launch(context);
                            },
                            width: context.width(),
                            margin: EdgeInsets.all(16),
                            color: js_primaryColor,
                            child: Text("Apply Now", style: boldTextStyle(color: white)),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            })
                : Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(spreadRadius: 0.5, blurRadius: 1, color: gray.withOpacity(0.5)),
                ],
                backgroundColor: context.scaffoldBackgroundColor,
              ),
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(16),
              width: context.width(),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.block, size: 20),
                      8.width,
                      Text("Job Remove", style: boldTextStyle()),
                    ],
                  ),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                            ),
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {
                                          finish(context);
                                        },
                                        padding: EdgeInsets.all(16),
                                        icon: Icon(Icons.close, size: 20),
                                        alignment: Alignment.topRight,
                                      ),
                                    ),
                                    Text("Why did you removw this job?", style: boldTextStyle()).paddingSymmetric(horizontal: 16),
                                    8.height,
                                    Text(
                                      "Selecting what could be improved will make your search results more relevant.",
                                      style: primaryTextStyle(size: 14),
                                    ).paddingSymmetric(horizontal: 16),
                                    JSRemoveJobComponent(),
                                    Divider(),
                                    AppButton(
                                      onTap: () {
                                        finish(context);
                                        snackBar(context,title: 'Thanks for a feedback',backgroundColor: context.scaffoldBackgroundColor);
                                      },
                                      width: context.width(),
                                      margin: EdgeInsets.all(16),
                                      color: js_primaryColor,
                                      child: Text("Send feedback", style: boldTextStyle(color: white)),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        style: OutlinedButton.styleFrom(side: BorderSide(width: 1.0, color: js_primaryColor)),
                        child: Text("Give feedBack", style: boldTextStyle(color: js_primaryColor)),
                      ),
                      16.width,
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(side: BorderSide(width: 1.0, color: js_primaryColor)),
                        child: Text("Undo", style: boldTextStyle(color: js_primaryColor)),
                      ),
                    ],
                  ),
                ],
              ),
            );
            // return JSFilteredResultWidget(filteredResultsList: data, city: widget.city,index: index);
          },
        ).expand(),
      )

        ],
      ),
    );
  }
}

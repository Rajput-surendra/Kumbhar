import 'dart:convert';

import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indianmilan/app/global_widgets/textEnter.dart';
import 'package:indianmilan/app/modules/OTP_screen/views/OTP_view.dart';
import 'package:indianmilan/app/modules/Register_six/controllers/Register_six_cotroller.dart';
import 'package:indianmilan/app/modules/dashboard/views/dashboard_view.dart';
import 'package:indianmilan/app/routes/app_pages.dart';
import 'package:indianmilan/app/utils/constant.dart';
import 'package:indianmilan/app/utils/image_helper.dart';
import 'package:indianmilan/app/utils/string_helper.dart';
import 'package:indianmilan/app/utils/widget.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/Session.dart';
import 'package:http/http.dart' as http;
class Register_six_view extends StatefulWidget {
  var param;


  Register_six_view(this.param);

  @override
  _Register_six_viewState createState() => _Register_six_viewState();
}

class _Register_six_viewState extends State<Register_six_view> {
  bool toggle = true;

  late Dimension beginWidth;
  late Dimension beginHeight;
  late Dimension endWidth;
  late Dimension endHeight;
  Map param={};




  Widget getTitle() {
    return Container(
      // margin: EdgeInsets.only(left: 10),
      height: 40,
      width: 120,
      child: Image.asset(
        SPLASH_IMAGE,
        fit: BoxFit.fill,
      ),
    );
  }

  Container getBackButton() {
    return Container(
      padding: EdgeInsets.all(getWidth(20)),
      height: getHeight(50),
      width: getHeight(50),
      child: Image.asset(
        BACK_BUTTON,
        fit: BoxFit.fill,
      ),
    );
  }


  Row getHeader() {
    return  Row(
      children: <Widget>[
        GestureDetector(
          onTap:(){
            Get.back();
          },
          child: getBackButton(),
        ),
        const Spacer(
          //flex: 1,
        ),
        getTitle(),
        const Spacer(flex: 2)
      ],
    );
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(model!=null){
      if(model!.aboutMe!=null&&model!.aboutMe!=""){
        desCon.text = model!.aboutMe.toString();
      }
    }

    param = widget.param;
  }
  TextEditingController desCon = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // bool isScreenWide = MediaQuery.of(context).size.width >= kMinWidthOfLargeScreen;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    beginWidth = Dimension.max(20.toPercentLength, 700.toPXLength);
    beginHeight = (90.toVHLength - 10.toPXLength);

    endWidth = Dimension.clamp(200.toPXLength, 40.toVWLength, 200.toPXLength);
    endHeight = 50.toVHLength +
        10.toPercentLength -
        Dimension.min(4.toPercentLength, 40.toPXLength);

    //LocalNotificationService.initialize(context);
    return
      SafeArea(
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: GestureDetector(
                onTap:(){
                  Navigator.pop(context);
                },
                child: getBackButton(),
              ),
              centerTitle: true,
              title:  getTitle(),
            ),
            backgroundColor: Colors.white,
            body:
            Stack(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child:
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height:  350.toPercentLength.value,
                          child: Image.asset(
                            LOGIN_BACKGRAUND,
                            fit: BoxFit.fill,
                          ),
                        ),

                      ],)

                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      boxHeight(95),
                      text("Great ! Now some basic details about you",
                          fontFamily: fontMedium,
                          fontSize: 12.sp,
                          textColor:Colors.white
                      ),
                      boxHeight(35),
                      Container(
                        width: getWidth(625),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            text("All Fields are mandatory",
                                fontFamily: fontMedium,
                                fontSize: 9.sp,
                                textColor:Color(0xffFECC2F)
                            ),
                          ],),
                      ),
                      boxHeight(15),
                      Container(
                        width: getWidth(625),
                        padding: EdgeInsets.symmetric(horizontal: getWidth(24),vertical: getHeight(40)),
                        decoration: boxDecoration(
                          radius: 20,
                          showShadow: true,
                          bgColor: Colors.white,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height/2.8,
                              child: TextFormField(
                                minLines: 20,
                                maxLines: 50,
                                controller: desCon,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  hintText: MULTILINE_TEXT1,
                                  hintStyle: TextStyle(
                                      color: Colors.grey
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                ),
                              ),
                            )
                          ],),
                      ),
                      boxHeight(90),
                      Center(
                        child: InkWell(
                          onTap: (){
                            if(desCon.text==""){
                              setSnackbar("Please Enter Description", context);
                              return;
                            }
                            param['description']= desCon.text;
                            print(param);
                            setState(() {
                              loading = true;
                            });
                            if(model!=null){
                              update();
                            }else{
                              register();
                            }
                          },
                          child: Container(
                            width: getWidth(625),
                            height: getHeight(95),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [0,1],
                                  colors: <Color>[Color(0xff4292EB), Color(0xff63BEF5),]),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: !loading?text(model!=null?"Update Profile":Create_Profile,
                                  fontFamily: fontMedium,
                                  fontSize: 14.sp,
                                  textColor: Colors.white
                              ):loadingWidget(color: Colors.white,),
                            ),
                          ),
                        ),
                      ),
                      boxHeight(200),
                    ],),
                )




              ],
            )
        ),
      );
  }
  bool loading = false;
  register() async{
    param['name']= "test";
    param['sub_caste']= "test";
    param['brother_name']= "test";
   param['device_token']= fcmToken;
    debugPrint(param.toString());
    var res = await http.post(Uri.parse(baseUrl+"signup"),body: param,headers: {
    "Accept-Language" : langCode,
    });
    print(res.body);
    Map response = jsonDecode(res.body);
    print(response);
    setState(() {
      loading = false;
    });
    setSnackbar(response['message'].toString(), context);
    if(response['status'].toString()=="1"){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>OTP_view(param['mobile'])));
    }else{

    }

  }

  update() async{
    param['name']= "test";
   // param['sub_caste']= "test";
    param['brother_name']= "test";
    param['device_token']= fcmToken;
    param['user_id']= curUserId;
    print(param);
    var res = await http.post(Uri.parse(baseUrl+"user_full_profil_update"),body: param,headers: {
      "Accept-Language" : langCode,
    });
    print(res.body);
    Map response = jsonDecode(res.body);
    print(response);
    setState(() {
      loading = false;
    });
    setSnackbar(response['message'].toString(), context);
    if(response['status'].toString()=="1"){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> DashboardView(0)), (route) => false);

    }else{

    }

  }
}


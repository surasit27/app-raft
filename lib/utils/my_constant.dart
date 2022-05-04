import 'package:flutter/material.dart';

class MyConstant {
  // Genernal
  static String appName = 'Raft';

  //Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/create_account';
  static String routeDetailActivitys = '/detail_activitys';
  static String routeHome = '/home';
  static String routePromotion = '/list_promotion';
  static String routeOrder = '/order';
  static String routeOrderPay = '/order_pay';
  static String routeOrderHistory = '/order_history';
  static String routeRaftDetail = '/detail_raft';
  static String routeDetailOderHistory = '/detail_oderhistory';
  static String routeRaftBusiness = '/list_business';
  static String routeOrderDetailPay = '/order_detailpay';
  static String routeLocation = '/location';

  //Img
  static String logoraft = 'assets/images/logoraft.png';
  static String error = 'assets/images/error.png';
  static String uploadimage = 'assets/images/uploadimage.png';

  //Color
  static Color primary = Color(0xFF42a5f5);
  static Color dark = Color(0xFF0077c2);
  static Color light = Color(0xFF80d6ff);
  static Color red = Color(0xFFd32f2f);

  //Style
  TextStyle h1Style() => TextStyle(
        fontSize: 24,
        color: dark,
        fontWeight: FontWeight.bold,
      );
  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        color: primary,
        fontWeight: FontWeight.w600,
      );
  TextStyle h2whiteStyle() => TextStyle(
        fontSize: 18,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      );
  TextStyle h3Style() => TextStyle(
        fontSize: 16,
        color: primary,
        fontWeight: FontWeight.w600,
      );
  TextStyle h3whiteStyle() => TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      );

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
  ButtonStyle cancleButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}

const kTextColor = Color(0xFF0077c2);
const kTextLightColor = Color(0xFFACACAC);
const kDefaultPaddin = 15.0;

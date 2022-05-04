import 'package:flutter/material.dart';
import 'package:flutter_raft/sceens/detail_activitys.dart';
import 'package:flutter_raft/sceens/detail_oderhistory.dart';
import 'package:flutter_raft/sceens/detail_raft.dart';
import 'package:flutter_raft/sceens/home.dart';
import 'package:flutter_raft/sceens/list_business.dart';
import 'package:flutter_raft/sceens/business_idpro.dart';
import 'package:flutter_raft/sceens/location.dart';
import 'package:flutter_raft/sceens/order_detailpay.dart';
import 'package:flutter_raft/sceens/order_history.dart';
import 'package:flutter_raft/sceens/order_pay.dart';
import 'package:flutter_raft/states/authen.dart';
import 'package:flutter_raft/states/create_account.dart';
import 'package:flutter_raft/utils/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/create_account': (BuildContext context) => CreateAccount(),
  '/home': (BuildContext context) => Home(),
  '/list_promotion': (BuildContext context) => ListPromotion(),
  '/order_pay': (BuildContext context) => OrderPay(),
  '/order_history': (BuildContext context) => OrderHistory(),
  '/detail_raft': (BuildContext context) => RaftDetail(),
  '/detail_activitys': (BuildContext context) => DetailActivitys(),
  '/detail_oderhistory': (BuildContext context) => DetailOderHistory(),
  '/list_business': (BuildContext context) => RaftBusiness(),
  '/order_detailpay': (BuildContext context) => OrderDetailPay(),
  '/location': (BuildContext context) => Location(),
};

String? initlalRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? user = preferences.getString('userEmail');
  print('user ===>> $user');
  if (user?.isEmpty ?? true) {
    initlalRoute = MyConstant.routeAuthen;
    runApp(MyApp());
  } else {
    initlalRoute = MyConstant.routeHome;
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyConstant.appName,
      routes: map,
      initialRoute: initlalRoute,
    );
  }
}

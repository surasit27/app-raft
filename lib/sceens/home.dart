import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_raft/custom/show_title.dart';
import 'package:flutter_raft/custom/site_menu.dart';
import 'package:flutter_raft/models/activitys_model.dart';
import 'package:flutter_raft/models/businesses_model.dart';
import 'package:flutter_raft/models/raft_model.dart';
import 'package:flutter_raft/models/sqlite_raftmodel.dart';
import 'package:flutter_raft/models/sqlite_servicesmodel.dart';
import 'package:flutter_raft/models/user_model.dart';
import 'package:flutter_raft/sceens/home_activitys.dart';
import 'package:flutter_raft/sceens/home_order.dart';
import 'package:flutter_raft/sceens/home_raft.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:flutter_raft/utils/constant_server_image.dart';
import 'package:flutter_raft/utils/my_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool load = true;
  List<ActivitysModel> activitysModel = [];
  List<RaftModel> raftModel = [];
  List<UserModel> userModel = [];
  List<BusinessesModel> businessesModel = [];

  List<List<String>> listImage = [];
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final fromkey = GlobalKey<FormState>();
  File? file;
  String? raftIdBus;
  List<RaftSQLite> raftSQLite = [];
  List<SesviceSQLite> servicesSQLite = [];
  int? total;
  int? totalser;

  @override
  void initState() {
    super.initState();
    loadvalueactiviys();
    loadvalueraft();
    findUserLogin();
    // controller = TabController(length: 4)
  }

  Future<Null> loadvalueactiviys() async {
    var apiGetActiviys =
        Uri.parse('${Constant().domain}/APIActivities/GetActivity');
    var response = await http.get(apiGetActiviys);
    setState(() {
      load = false;
    });
    final List jsonaFromActivity = json.decode(response.body);
    List<ActivitysModel> result = jsonaFromActivity
        .map(
          (e) => ActivitysModel.fromJson(e),
        )
        .toList();
    for (var item in result) {
      // print(item.businessName);

      setState(() {
        activitysModel.add(item);
      });
    }
  }

  Future<Null> findUserLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString('userId')!;
    var apiGetUser = Uri.parse('${Constant().domain}/APIUsers/GetUser/$userId');
    var response = await http.get(apiGetUser);
    final List jsonFromGetUser = json.decode(response.body);
    List<UserModel> result =
        jsonFromGetUser.map((e) => UserModel.fromJson(e)).toList();
    print(response.body);
    for (var item in result) {
      setState(() {
        userModel.add(item);
        print(item.userEmail);
      });
    }
  }

  Future<Null> loadvalueraft() async {
    var apiGetRaft = Uri.parse('${Constant().domain}/APIRafts/GetRaft');
    var response = await http.get(apiGetRaft);
    setState(() {
      load = false;
    });
    final List jsonFromRaft = json.decode(response.body);
    List<RaftModel> result = jsonFromRaft
        .map(
          (e) => RaftModel.fromJson(e),
        )
        .toList();
    for (var item in result) {
      String string = item.raftImage;
      List<String> strings = string.split(',');
      int i = 0;
      for (var item in strings) {
        strings[i] = item.trim();
        i++;
      }
      listImage.add(strings);
      // print(item.raftName);
      setState(() {
        raftModel.add(item);
      });
    }
  }

  String findImageSQLite(String arrayImage) {
    String string = arrayImage;
    List<String> strings = string.split(',');
    int index = 0;
    for (var item in strings) {
      strings[index] = item.trim();
      index++;
    }
    String result = '${strings[0]}';
    return result;
  }

  String findUrlImage(String arrayImage) {
    String string = arrayImage;
    List<String> strings = string.split(',');
    int index = 0;
    for (var item in strings) {
      strings[index] = item.trim();
      index++;
    }
    String result = '${ServerImage().domain}${strings[0]}';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    child: Column(
                        children: List.generate(userModel.length, (index) {
                      return userAccounts(userModel[index]);
                    })),
                  ),
                  // dataUser(userModel),
                  // menuOrder(),
                  menuPayOrder(),
                  menuHistoryOrder(),
                ],
              ),
              SiteMenu(),
              // buildImage(size),
            ],
          ),
        ),
        appBar: _appbarhome(),
        body: Container(
          child: TabBarView(
            children: [
              _buildHome(),
              HomeRaft(),
              HomeActivitys(),
              // _listActivitySection(),
              HomeOrder(),
            ],
          ),
        ),
      ),
    );
  }

///////////////////DRAWER USER
  Widget userAccounts(UserModel userModel) {
    return new UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF008ba3),
              Color(0xFF1de9b6),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        currentAccountPicture: Image.asset(
          MyConstant.logoraft,
        ),
        accountName: Text(userModel == null ? 'name ?' : userModel.userName!),
        accountEmail:
            Text(userModel == null ? 'Email ?' : userModel.userEmail!));
  }

  // ListTile menuOrder() {
  //   return ListTile(
  //     onTap: () {
  //       Navigator.pushReplacementNamed(context, '/order');

  //     },
  //     leading: Icon(
  //       Icons.shopping_cart_outlined,
  //       size: 30,
  //     ),
  //     title: ShowTitle(
  //       title: 'รายการจอง',
  //       textStyle: MyConstant().h2Style(),
  //     ),
  //   );
  // }

  ListTile menuPayOrder() {
    return ListTile(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/order_pay');
      },
      leading: Icon(
        Icons.paid_outlined,
        size: 30,
      ),
      title: ShowTitle(
        title: 'ชำระเงิน',
        textStyle: MyConstant().h2Style(),
      ),
    );
  }

  ListTile menuHistoryOrder() {
    return ListTile(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/order_history');
      },
      leading: Icon(
        Icons.manage_search_outlined,
        size: 30,
      ),
      title: ShowTitle(
        title: 'ประวัติการจอง',
        textStyle: MyConstant().h2Style(),
      ),
    );
  }

///////////////////////////////APPBAR
  AppBar _appbarhome() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.black87,
        ),
        onPressed: () {
          scaffoldKey.currentState!.openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_none,
            color: Colors.black87,
          ),
          onPressed: () {},
        ),
      ],
      bottom: _tabbar(),
      elevation: 0.8,
      titleSpacing: 10,
    );
  }

  TabBar _tabbar() {
    return TabBar(
      indicatorColor: Colors.black87,
      indicatorWeight: 2,
      tabs: [
        Tab(
          icon: Icon(
            Icons.home,
            color: Colors.black87,
          ),
          child: Text(
            'หน้าหลัก',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.anchor,
            color: Colors.black87,
          ),
          child: Text(
            'แพลาก',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.rowing,
            color: Colors.black87,
          ),
          child: Text(
            'กิจกรรม',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.local_grocery_store,
            color: Colors.black87,
          ),
          child: Text(
            'การจอง',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHome() => ListView(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "กิจกรรมประชาสัมพันธ์",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            "ดูเพิ่มเติม",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 16,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      activitysModel.length,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                            width: 140,
                            height: 180,
                            child: Stack(
                              children: [
                                _homeImageAct(activitysModel[index]),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "แพลาก",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            "ดูเพิ่มเติม",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 16,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                    children: List.generate(raftModel.length, (index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          _homeRaftImage(raftModel[index]),
                          _onTapRaft(raftModel[index], listImage[index]),
                          _homeRaftText(raftModel[index])
                        ],
                      ),
                    ),
                  );
                })),
              ],
            ),
          )
        ],
      );

  GestureDetector _onTapRaft(RaftModel raftModel, List<String> images) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString('raftIdService', raftModel.raftId);
        Navigator.pushReplacementNamed(context, '/detail_raft');
      },
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _homeRaftText(RaftModel raftModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                Icons.near_me,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '${raftModel.raftName} - ${raftModel.businessName}',
                style: TextStyle(fontSize: 18, color: Colors.white),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _homeRaftImage(RaftModel raftModel) => Container(
        height: 200,
        width: double.infinity,
        child: FadeInImage.memoryNetwork(
          fit: BoxFit.cover,
          placeholder: kTransparentImage,
          image: findUrlImage(
            raftModel.raftImage,
          ),
        ),
      );

  Widget _homeImageAct(ActivitysModel activitysModel) {
    return GestureDetector(
      onTap: () async {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DetailActivitys(activitysModel),
        //   ),
        // );
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString('activityId', activitysModel.activityId);
        Navigator.pushReplacementNamed(context, '/detail_activitys');
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  '${ServerImage().domain}${activitysModel.activityImagePaht}'),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

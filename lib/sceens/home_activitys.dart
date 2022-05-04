import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_raft/api/search_apiactivitys.dart';
import 'package:flutter_raft/custom/searchraft_widget.dart';
import 'package:flutter_raft/models/activitys_model.dart';
import 'package:flutter_raft/utils/constant_server_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeActivitys extends StatefulWidget {
  const HomeActivitys({Key? key}) : super(key: key);

  @override
  _HomeActivitysState createState() => _HomeActivitysState();
}

class _HomeActivitysState extends State<HomeActivitys> {
  bool load = true;
  List<ActivitysModel> activitysModel = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    init();

    // loadvalueactiviys();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final activitysModel = await SearchActivityApi.getSearcdhAct(query);

    setState(() {
      this.activitysModel = activitysModel;
    });
  }

  // Future<Null> loadvalueactiviys() async {
  //   var apiGetActiviys =
  //       Uri.parse('${Constant().domain}/APIActivities/GetActivity');
  //   var response = await http.get(apiGetActiviys);
  //   setState(() {
  //     load = false;
  //   });
  //   final List jsonaFromActivity = json.decode(response.body);
  //   List<ActivitysModel> result = jsonaFromActivity
  //       .map(
  //         (e) => ActivitysModel.fromJson(e),
  //       )
  //       .toList();
  //   for (var item in result) {
  //     // print(item.businessName);

  //     setState(() {
  //       activitysModel.add(item);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          buildSearch(),
          SizedBox(
            height: 20,
          ),
          Column(
              children: List.generate(activitysModel.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Container(
                height: 200,
                width: double.infinity,
                child: Stack(
                  children: [
                    _listActImage(activitysModel[index]),
                    _onTapHomeAct(activitysModel[index], context),
                    _listActText(activitysModel[index])
                  ],
                ),
              ),
            );
          })),
        ],
      ),
    );
  }

  Widget buildSearch() => SearchRaftWidget(
        hintText: 'ค้นหารายการกิจกรรม',
        onChanged: searchAct,
        text: 'query',
      );

  Future searchAct(String query) async {
    final activitysModel = await SearchActivityApi.getSearcdhAct(query);
    if (!mounted) return;
    setState(() {
      this.query = query;
      this.activitysModel = activitysModel;
    });
  }

  Widget _onTapHomeAct(ActivitysModel activitysModel, BuildContext context) =>
      GestureDetector(
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
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(10)),
        ),
      );

  Widget _listActText(ActivitysModel activitysModel) {
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
                activitysModel.activityName,
                style: TextStyle(fontSize: 18, color: Colors.white),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _listActImage(ActivitysModel activitysModel) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  '${ServerImage().domain}${activitysModel.activityImagePaht}'),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(5),
        ),
      );
}

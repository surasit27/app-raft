import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_raft/custom/show_title.dart';
import 'package:flutter_raft/models/activitys_model.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:flutter_raft/utils/constant_server_image.dart';
import 'package:flutter_raft/utils/my_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class DetailActivitys extends StatefulWidget {
  // ActivitysModel activitysModel;
  // DetailActivitys(this.activitysModel);
  const DetailActivitys({Key? key}) : super(key: key);

  @override
  _DetailActivitysState createState() => _DetailActivitysState();
}

class _DetailActivitysState extends State<DetailActivitys> {
  bool load = true;
  List<ActivitysModel> activitysModel = [];
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    loadvalueactiviys();
  }

  Future<Null> loadvalueactiviys() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String activityId = preferences.getString('activityId')!;
    var apiGetActiviys =
        Uri.parse('${Constant().domain}/APIActivities/GetActivity/$activityId');
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
      setState(() {
        activitysModel.add(item);
        _controller = VideoPlayerController.network(
            "${ServerImage().domain}${item.activityVideoPaht}");
        _initializeVideoPlayerFuture = _controller.initialize();
        _controller.setLooping(true);
        _controller.setVolume(1);
      });
      print(item.activityName);
    }
  }

  @override
  Widget build(BuildContext context) {
    //   Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  Widget getBody() {
    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black87,
                    )),
                SizedBox(
                  width: 20,
                ),
                // Flexible(
                //   child: Container(
                //     height: 45,
                //     decoration: BoxDecoration(
                //         color: Colors.grey.withOpacity(0.2),
                //         borderRadius: BorderRadius.circular(30)),
                //     child: Padding(
                //       padding: const EdgeInsets.only(left: 20),
                //       child: TextField(
                //         cursorColor: kPrimaryColor,
                //         decoration: InputDecoration(
                //             border: InputBorder.none,
                //             suffixIcon: Icon(
                //               Icons.search,
                //             ),
                //             hintText: "ค้นหากิจกรรม"),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          Divider(
            color: Colors.grey.withOpacity(0.8),
          ),
          // SizedBox(
          //   height: 20,
          // ),
          Column(
            children: List.generate(
              activitysModel.length,
              (index) {
                return FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
              children: List.generate(activitysModel.length, (index) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      activitysModel[index].activityName,
                      style: MyConstant().h1Style(),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      activitysModel[index].activityDetails,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            );
          })),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'ติดต่อสอบถาม',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(activitysModel.length, (index) {
                  return Container(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.account_circle_outlined,
                          ),
                          title: ShowTitle(
                            title: activitysModel[index].businessName,
                            textStyle: MyConstant().h3Style(),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.call_outlined,
                          ),
                          title: ShowTitle(
                            title: activitysModel[index].businessTel,
                            textStyle: MyConstant().h3Style(),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.add_circle_outline,
                          ),
                          title: ShowTitle(
                            title: activitysModel[index].businessIdline,
                            textStyle: MyConstant().h3Style(),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.email_outlined,
                          ),
                          title: ShowTitle(
                            title: activitysModel[index].businessEmail,
                            textStyle: MyConstant().h3Style(),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.location_on,
                          ),
                          title: ShowTitle(
                            title: '${activitysModel[index].businessAddress}'
                                ' ${activitysModel[index].businessSubdistrict}'
                                ' ${activitysModel[index].businessDistrict}'
                                ' ${activitysModel[index].businessProvince}'
                                ' ${activitysModel[index].businessZipcode}',
                            textStyle: MyConstant().h3Style(),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  );
                })),
          ),
        ],
      ),
    );
  }

  // Widget _activiysImage(BuildContext context) {
  //   return
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Widget _activiysImage(ActivitysModel activitysModel) {
  //   return Padding(
  //     padding: const EdgeInsets.only(
  //       left: 10,
  //       right: 10,
  //     ),
  //     child: Container(
  //       child: Stack(
  //         children: [
  //           Container(
  //             height: 200,
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //                 image: DecorationImage(
  //                     image: NetworkImage(
  //                         '${ServerImage().domain}${activitysModel.activityImagePaht}'),
  //                     fit: BoxFit.cover),
  //                 borderRadius: BorderRadius.circular(10)),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

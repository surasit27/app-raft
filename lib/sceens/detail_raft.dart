import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_raft/custom/show_image.dart';
import 'package:flutter_raft/custom/show_title.dart';
import 'package:flutter_raft/models/businesses_model.dart';
import 'package:flutter_raft/models/raftid_model.dart';
import 'package:flutter_raft/models/raftservices_model.dart';
import 'package:flutter_raft/models/sqlite.dart';
import 'package:flutter_raft/models/sqlite_raftmodel.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:flutter_raft/utils/constant_server_image.dart';
import 'package:flutter_raft/utils/dialog.dart';
import 'package:flutter_raft/utils/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
// import 'package:transparent_image/transparent_image.dart';

class RaftDetail extends StatefulWidget {
  const RaftDetail({Key? key}) : super(key: key);

  @override
  _RaftDetailState createState() => _RaftDetailState();
}

class _RaftDetailState extends State<RaftDetail> {
  bool load = true;
  List<RaftServiceModel> raftServiceModel = [];
  // List<List<String>> listImage = [];
  List<RaftIdModel> raftIdModel = [];
  List<RaftSQLite> raftSQLite = [];
  List<BusinessesModel> businessesModel = [];
  String? raftIdBus;

  final List<String> imageList = [];

  @override
  void initState() {
    super.initState();
    loadRaftID();
    loadValueRaftService();
  }

  Future<Null> processRaftSQLite() async {
    if (raftSQLite.isEmpty) {
      raftSQLite.clear();
    }

    await SQLiteHelper().readSQLite().then((value) {
      setState(() {
        load = false;
        raftSQLite = value;
        findbusOrderRaft();
        // calculateTotal();
      });
    });
  }

  Future<Null> readIdbusORder() async {
    await SQLiteHelper().readSQLite().then((value) {
      if (value.length != 0) {
        List<RaftSQLite> models = [];
        for (var model in value) {
          models.add(model);
        }
        raftIdBus = models[0].busId;
        // iDraft = model.raftId;
        print('raftIdBus ==>> $raftIdBus');
      }
    });
  }

  Future<void> findbusOrderRaft() async {
    String idbus = raftSQLite[0].busId;
    print('idbus ==> $idbus');
    var apiGetUser = Uri.parse(
        '${Constant().domain}/APIBusinesses/GetBusinessOrderRaft/$idbus');
    var response = await http.get(apiGetUser);
    final List jsonFromGetBus = json.decode(response.body);
    List<BusinessesModel> result =
        jsonFromGetBus.map((e) => BusinessesModel.fromJson(e)).toList();
    print(response.body);
    for (var item in result) {
      setState(() {
        businessesModel.add(item);
      });
    }
  }

  Future<Null> loadRaftID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String raftId = preferences.getString('raftIdService')!;
    var apiGetRaft = Uri.parse('${Constant().domain}/APIRafts/GetRaft/$raftId');
    var response = await http.get(apiGetRaft);
    setState(() {
      load = false;
    });
    final List jsonFromRaftId = json.decode(response.body);
    List<RaftIdModel> result =
        jsonFromRaftId.map((e) => RaftIdModel.fromJson(e)).toList();
    print(response.body);
    for (var item in result) {
      setState(() {
        raftIdModel.add(item);
        String string = item.raftImage;
        List<String> strings = string.split(',');
        // int index = 0;
        for (var item in strings) {
          imageList.add(item.trim());
          // strings[index] = item.trim();
          // index++;
        }
        // print(item.raftImage);
      });
    }
  }

  String findImage(String arrayImage) {
    String string = arrayImage;
    List<String> strings = string.split(',');
    // int index = 0;
    for (var item in strings) {
      imageList.add(item.trim());
      // strings[index] = item.trim();
      // index++;
    }
    String result = '${ServerImage().domain}${strings[0]}';
    return result;
  }

  Future<Null> loadValueRaftService() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String raftIdService = preferences.getString('raftIdService')!;
    print('raftIdService ==> $raftIdService');
    var apiGetRaftService = Uri.parse(
        '${Constant().domain}/APIRafts/GetRaftService/$raftIdService');
    var response = await http.get(apiGetRaftService);
    setState(() {
      load = false;
    });
    final List jsonFromraftService = json.decode(response.body);
    List<RaftServiceModel> result =
        jsonFromraftService.map((e) => RaftServiceModel.fromJson(e)).toList();
    print(response.body);
    for (var item in result) {
      setState(() {
        raftServiceModel.add(item);
        print(item.servicesName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                // SizedBox(
                //   width: 20,
                // ),
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
                //             hintText: "ค้นหาแพ"),
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
              raftIdModel.length,
              (index) {
                return Container(
                  child: Column(
                    children: [
                      _raftImage(raftIdModel[index]),
                      SizedBox(
                        height: 20,
                      ),
                      _textRaft(raftIdModel[index]),
                    ],
                  ),
                );
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'บริการเสริมแพ',
                  style: MyConstant().h2Style(),
                ),
              ),
            ],
          ),
          Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(raftServiceModel.length, (index) {
                  return Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        _raftServices(raftServiceModel[index]),
                      ],
                    ),
                  );
                })),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'ติดต่อสอบถาม',
                  style: MyConstant().h2Style(),
                ),
              ),
            ],
          ),
          Column(
            children: List.generate(
              raftIdModel.length,
              (index) {
                return Container(
                  child: Column(
                    children: [
                      _raftBussines(raftIdModel[index]),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _raftBussines(RaftIdModel raftIdMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(
              Icons.account_circle_outlined,
            ),
            title: ShowTitle(
              title: raftIdMode.businessName,
              textStyle: MyConstant().h3Style(),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.call_outlined,
            ),
            title: ShowTitle(
              title: raftIdMode.businessTel,
              textStyle: MyConstant().h3Style(),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.add_circle_outline,
            ),
            title: ShowTitle(
              title: raftIdMode.businessIdline,
              textStyle: MyConstant().h3Style(),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.email_outlined,
            ),
            title: ShowTitle(
              title: raftIdMode.businessEmail,
              textStyle: MyConstant().h3Style(),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.location_on,
            ),
            title: ShowTitle(
              title: '${raftIdMode.businessAddress}'
                  ' ${raftIdMode.businessSubdistrict}'
                  ' ${raftIdMode.businessDistrict}'
                  ' ${raftIdMode.businessProvince}'
                  ' ${raftIdMode.businessZipcode}',
              textStyle: MyConstant().h3Style(),
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.pop(context, '/location');
          //   },
          //   child: ListTile(
          //     leading: Icon(Icons.location_on),
          //     title: ShowTitle(
          //       title: 'แผนที่',
          //       textStyle: MyConstant().h3Style(),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  Widget _raftServices(
    RaftServiceModel raftServiceModel,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Text(
        raftServiceModel.servicesName,
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _textRaft(RaftIdModel raftIdMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Text(
                  raftIdMode.raftName,
                  style: MyConstant().h1Style(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  _showAlerDialogRaft(raftIdMode);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    //color: Colors.blue,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF008ba3),
                        Color(0xFF1de9b6),
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        blurRadius: 50,
                        color: Color(0xFF12153D).withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Text(
            'ราคา ${raftIdMode.raftPrice}',
            style: MyConstant().h2Style(),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            raftIdMode.raftDetails,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _raftImage(RaftIdModel raftIdModel) => Center(
        child: CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            autoPlay: true,
          ),
          items: imageList
              .map((e) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          '${ServerImage().domain}$e',
                          width: 1000,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                  ))
              .toList(),
        ),
      );

  // Widget _raftImage(RaftIdModel raftIdModel) => Padding(
  //       padding: const EdgeInsets.only(left: 20, right: 20),
  //       child: Container(
  //         height: 200,
  //         width: double.infinity,
  //         child: FadeInImage.memoryNetwork(
  //           fit: BoxFit.cover,
  //           placeholder: kTransparentImage,
  //           image: findImage(
  //             raftIdModel.raftImage,
  //           ),
  //         ),
  //         // child:CarouselSlider.builder(itemCount: m, itemBuilder: itemBuilder, options: options) ,
  //         // child: CarouselSlider.builder(
  //         //   itemCount: raftIdModel.raftImage.length,
  //         //   itemBuilder: (context, index, realIndex) {
  //         //     // final urlImage = raftIdModel.raftImage[index];

  //         //     return buildUrlImage(raftIdModel, index);
  //         //   },
  //         //   options: CarouselOptions(height: 200),
  //         // ),
  //       ),
  //     );

  // Widget buildUrlImage(RaftIdModel raftIdModel, int index) => Container(
  //       margin: EdgeInsets.symmetric(horizontal: 12),
  //       color: Colors.grey,
  //       child: Image.network('${ServerImage().domain}${raftIdModel.raftImage}'),
  //     );

  Future<Null> _showAlerDialogRaft(RaftIdModel raftIdModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(pathImage: MyConstant.logoraft),
          title: ShowTitle(
            title: raftIdModel.raftName,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
              title: raftIdModel.businessName,
              textStyle: MyConstant().h3Style()),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeInImage.memoryNetwork(
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
              image: findImage(
                raftIdModel.raftImage,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String raftId = raftIdModel.raftId;
              String raftName = raftIdModel.raftName;
              String businessId = raftIdModel.businessId;
              String raftDetails = raftIdModel.raftDetails;
              String raftPrice = raftIdModel.raftPrice.toString();
              String raftImage = raftIdModel.raftImage;
              String businessName = raftIdModel.businessName;
              if ((raftIdBus == businessId) || (raftIdBus == null)) {
                print(
                    'IDRaft ==>> $raftId, $raftName, $raftDetails, $raftPrice, $raftImage, $businessId, $businessName');
                RaftSQLite raftSQLite = RaftSQLite(
                  raftId: raftId,
                  busId: businessId,
                  busName: businessName,
                  raftName: raftName,
                  raftDetails: raftDetails,
                  raftPrice: raftPrice,
                  raftImage: raftImage,
                );
                await SQLiteHelper()
                    .inserRaftToSQLite(raftSQLite)
                    .then((value) async {
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  _prefs.setString('busid', raftIdModel.businessId);
                  _prefs.setString('serraftid', raftSQLite.raftId);
                  Navigator.pushReplacementNamed(context, '/list_business');
                });
              } else {
                Navigator.pop(context);
                MyDialog().normalDialog(context, 'จองแพผิด ? ',
                    'กรุณาทำรายการจองของ ${raftIdModel.businessName} ให้เสร็จก่อน ทำการจองแพอื่น');
              }
              // Navigator.pop(context);
            },
            child: Text('จองแพ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

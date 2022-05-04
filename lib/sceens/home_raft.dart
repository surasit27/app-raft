import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_raft/api/search_apiraft.dart';
import 'package:flutter_raft/custom/searchraft_widget.dart';
import 'package:flutter_raft/custom/show_image.dart';
import 'package:flutter_raft/custom/show_title.dart';
import 'package:flutter_raft/models/businesses_model.dart';
import 'package:flutter_raft/models/raft_model.dart';
import 'package:flutter_raft/models/sqlite.dart';
import 'package:flutter_raft/models/sqlite_raftmodel.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:flutter_raft/utils/constant_server_image.dart';
import 'package:flutter_raft/utils/dialog.dart';
import 'package:flutter_raft/utils/my_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeRaft extends StatefulWidget {
  const HomeRaft({Key? key}) : super(key: key);

  @override
  _HomeRaftState createState() => _HomeRaftState();
}

class _HomeRaftState extends State<HomeRaft> {
  List<RaftModel> raftModel = [];
  bool load = true;
  List<List<String>> listImage = [];
  List<RaftSQLite> raftSQLite = [];
  List<BusinessesModel> businessesModel = [];
  int? total;
  String? raftIdBus;
  String? iDraft;

  // late List<RaftModel> seardhrafts;
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    // seardhrafts = raftModel;
    // loadvalueraft();
    processRaftSQLite();
    readIdbusORder();
    init();
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
    final raftModel = await SearchRaftApi.getSearcdhRaft(query);
    setState(() {
      this.raftModel = raftModel;
    });
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
        calculateTotal();
      });
    });
  }

  void calculateTotal() async {
    total = 0;
    for (var item in raftSQLite) {
      int sumInt = int.parse(item.raftPrice.trim());
      setState(() {
        total = total! + sumInt;
      });
    }
  }

  Future<void> findbusOrderRaft() async {
    String idbus = raftSQLite[0].busId;
    // String iDraft = raftSQLite.ra
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

  // Future<Null> loadvalueraft() async {
  //   var apiGetRaft = Uri.parse('${Constant().domain}/APIRafts/GetRaft');
  //   var response = await http.get(apiGetRaft);
  //   setState(() {
  //     load = false;
  //   });
  //   final List jsonFromRaft = json.decode(response.body);
  //   List<RaftModel> result = jsonFromRaft
  //       .map(
  //         (e) => RaftModel.fromJson(e),
  //       )
  //       .toList();
  //   for (var item in result) {
  //     String string = item.raftImage;
  //     List<String> strings = string.split(',');
  //     int i = 0;
  //     for (var item in strings) {
  //       strings[i] = item.trim();
  //       i++;
  //     }
  //     listImage.add(strings);
  //     print(item.raftName);
  //     setState(() {
  //       raftModel.add(item);
  //     });
  //   }
  // }

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
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSearch(),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
              child: GridView.builder(
                itemCount: raftModel.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: kDefaultPaddin / 2,
                  crossAxisSpacing: kDefaultPaddin / 2,
                  // childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final raftModels = raftModel[index];

                  return _bodyraft(raftModels);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearch() => SearchRaftWidget(
        hintText: 'ค้นหารายการแพ',
        onChanged: searchRaft,
        text: 'query',
      );

  Future searchRaft(String query) async {
    final raftModel = await SearchRaftApi.getSearcdhRaft(query);
    if (!mounted) return;
    setState(() {
      this.query = query;
      this.raftModel = raftModel;
    });
  }

  Widget _bodyraft(RaftModel raftModel) => Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Stack(
                children: [
                  _imageRaft(raftModel),
                ],
              ),
            ),
            _titleRaft(raftModel),
            //_iconShopping(),
          ],
        ),
      );
  Widget _titleRaft(RaftModel raftModel) {
    // Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  raftModel.raftName,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  raftModel.businessName,
                  // '\฿ ${raftModel.raftPrice}',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _showAlerDialogRaft(raftModel);
            },
            child: Container(
              padding: EdgeInsets.all(5),
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
        ],
      ),
    );
  }

  Future<Null> _showAlerDialogRaft(RaftModel raftModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(pathImage: MyConstant.logoraft),
          title: ShowTitle(
            title: raftModel.raftName,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
              title: raftModel.businessName, textStyle: MyConstant().h3Style()),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeInImage.memoryNetwork(
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
              image: findUrlImage(
                raftModel.raftImage,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String raftId = raftModel.raftId;
              String raftName = raftModel.raftName;
              String businessId = raftModel.businessId;
              String raftDetails = raftModel.raftDetails;
              String raftPrice = raftModel.raftPrice.toString();
              String raftImage = raftModel.raftImage;
              String businessName = raftModel.businessName;

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
                  _prefs.setString('busid', raftModel.businessId);
                  //Navigator.pop(context, '/list_business');

                  Navigator.pushReplacementNamed(context, '/list_business');
                });
              } else {
                Navigator.pop(context);
                MyDialog().normalDialog(context, 'จองแพผิด ? ',
                    'กรุณาทำรายการจองของ ${raftModel.businessName} ให้เสร็จก่อน ทำการจองแพอื่น');
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

  Container _imageRaft(RaftModel raftModel) {
    return Container(
      child: GestureDetector(
        onTap: () async {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.setString('raftIdService', raftModel.raftId);
          Navigator.pushReplacementNamed(context, '/detail_raft');
        },
        child: FadeInImage.memoryNetwork(
          fit: BoxFit.cover,
          placeholder: kTransparentImage,
          image: findUrlImage(
            raftModel.raftImage,
          ),
        ),
      ),
    );
  }
}

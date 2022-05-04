import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_raft/api/search_apiraftbuid.dart';
import 'package:flutter_raft/custom/Searchraft_widget.dart';
import 'package:flutter_raft/custom/show_image.dart';
import 'package:flutter_raft/custom/show_title.dart';
import 'package:flutter_raft/models/raft_model.dart';
import 'package:flutter_raft/models/sqlite.dart';
import 'package:flutter_raft/models/sqlite_raftmodel.dart';
import 'package:flutter_raft/sceens/business_idser.dart';
import 'package:flutter_raft/sceens/business_idpro.dart';
import 'package:flutter_raft/utils/constant_server_image.dart';
import 'package:flutter_raft/utils/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class RaftBusiness extends StatefulWidget {
  const RaftBusiness({Key? key}) : super(key: key);

  @override
  _RaftBusinessState createState() => _RaftBusinessState();
}

class _RaftBusinessState extends State<RaftBusiness>
    with SingleTickerProviderStateMixin {
  bool load = true;
  List<RaftModel> raftModel = [];
  List<List<String>> listImage = [];
  late TabController controller;

  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    // loadvalueraft();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      setState(() {});
    });

    init();
  }

  @override
  void dispose() {
    controller.dispose();
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
    final raftModel = await SearchRaftIdBusApi.getSearcdhRaftIdBus(query);
    setState(() {
      this.raftModel = raftModel;
    });
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black87,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black87,
                )),
          ],
          bottom: TabBar(
            controller: controller,
            tabs: [
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
                  Icons.kitesurfing,
                  color: Colors.black87,
                ),
                child: Text(
                  'บริการเสริม',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.campaign,
                  color: Colors.black87,
                ),
                child: Text(
                  'โปรโมชัน',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: [
            _listRaft(),
            BusinessIdSer(),
            ListPromotion(),
          ],
        ),
      ),
    );
  }

  Widget _listRaft() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSearch(),
          SizedBox(
            height: 20,
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
                  //childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) => _listraft(raftModel[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearch() => SearchRaftWidget(
        hintText: 'ค้นหารายการแพ',
        onChanged: searchRaftIDBus,
        text: 'query',
      );

  Future searchRaftIDBus(String query) async {
    final raftModel = await SearchRaftIdBusApi.getSearcdhRaftIdBus(query);
    if (!mounted) return;

    setState(() {
      this.query = query;
      this.raftModel = raftModel;
    });
  }

  Widget _listraft(RaftModel raftModel) => Card(
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
                  '\฿ ${raftModel.raftPrice}',
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
                // Navigator.pushReplacementNamed(context, '/list_business');
              });
              Navigator.pop(context);
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_raft/api/search_apiservices.dart';
import 'package:flutter_raft/custom/searchraft_widget.dart';
import 'package:flutter_raft/custom/show_image.dart';
import 'package:flutter_raft/custom/show_title.dart';
import 'package:flutter_raft/models/services_model.dart';
import 'package:flutter_raft/models/sqlite.dart';
import 'package:flutter_raft/models/sqlite_servicesmodel.dart';
import 'package:flutter_raft/sceens/detail_services.dart';
import 'package:flutter_raft/utils/constant_server_image.dart';
import 'package:flutter_raft/utils/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessIdSer extends StatefulWidget {
  const BusinessIdSer({Key? key}) : super(key: key);

  @override
  _BusinessIdSerState createState() => _BusinessIdSerState();
}

class _BusinessIdSerState extends State<BusinessIdSer> {
  bool load = true;
  List<ServicesModel> servicesModel = [];
  List<SesviceSQLite> serviceSQLite = [];

  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    // loadvalueservices();
    processServicesSQLite();
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
    final servicesModel =
        await SearchServicesIdBusApi.getSearcdhServicesIdBus(query);
    setState(() {
      this.servicesModel = servicesModel;
    });
  }

  Future<Null> processServicesSQLite() async {
    await SQLiteHelper().readServiceSQLite().then((value) {
      setState(() {
        load = false;
        serviceSQLite = value;
      });
    });
  }

  // Future<Null> loadvalueservices() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String busid = preferences.getString('busid')!;
  //   var apiGetServices =
  //       Uri.parse('${Constant().domain}/APIServices/GetServices/$busid');
  //   var response = await http.get(apiGetServices);
  //   setState(() {
  //     load = false;
  //   });
  //   final List jsonFromServices = json.decode(response.body);
  //   List<ServicesModel> result = jsonFromServices
  //       .map(
  //         (e) => ServicesModel.fromJson(e),
  //       )
  //       .toList();
  //   for (var item in result) {
  //     setState(() {
  //       servicesModel.add(item);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 20,
        ),
        buildSearch(),
        SizedBox(
          height: 20,
        ),
        Column(
          children: List.generate(
            servicesModel.length,
            (index) {
              return Column(
                children: [
                  _servicesImage(servicesModel[index]),
                ],
              );
            },
          ),
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Widget buildSearch() => SearchRaftWidget(
        hintText: 'ค้นหารายการบริการเสริม',
        onChanged: searchSer,
        text: 'query',
      );

  Future searchSer(String query) async {
    final servicesModel =
        await SearchServicesIdBusApi.getSearcdhServicesIdBus(query);
    if (!mounted) return;
    setState(() {
      this.query = query;
      this.servicesModel = servicesModel;
    });
  }

  Widget _servicesImage(ServicesModel servicesModel) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Container(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailServices(servicesModel),
                    ),
                  );
                },
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        '${ServerImage().domain}${servicesModel.servicesImagePaht}',
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      servicesModel.servicesName,
                      style: MyConstant().h2Style(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      servicesModel.businessName,
                      style: MyConstant().h3Style(),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '\฿ ${servicesModel.servicesPrice}',
                      style: MyConstant().h2Style(),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  _showAlerDialogService(servicesModel);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    //color: Colors.blue,
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.blueGrey],
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
        ),
      ),
    );
  }

  Future<Null> _showAlerDialogService(ServicesModel servicesModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(pathImage: MyConstant.logoraft),
          title: ShowTitle(
            title: servicesModel.servicesName,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
              title: servicesModel.businessName,
              textStyle: MyConstant().h3Style()),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              '${ServerImage().domain}${servicesModel.servicesImagePaht}',
              fit: BoxFit.cover,
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              String serraftid = preferences.getString('serraftid')!;

              String serId = servicesModel.servicesId;
              String serName = servicesModel.servicesName;
              String serDetails = servicesModel.servicesDetails;
              String serImage = servicesModel.servicesImagePaht;
              String serPrice = servicesModel.servicesPrice.toString();
              String serbusId = servicesModel.businessId;
              String serbusName = servicesModel.businessName;
              String serRaftId = serraftid;

              print(
                  'IDServices  ==>> $serId, $serName, $serDetails, $serImage, $serPrice, $serbusId, $serbusName,$serRaftId');
              SesviceSQLite sesviceSQLite = SesviceSQLite(
                  serId: serId,
                  serName: serName,
                  serDetails: serDetails,
                  serImage: serImage,
                  serPrice: serPrice,
                  serbusId: serbusId,
                  serbusName: serbusName,
                  serRaftId: serRaftId);
              await SQLiteHelper()
                  .inserServicesToSQLite(sesviceSQLite)
                  .then((value) {
                Navigator.pop(context);
              });
            },
            child: Text('จองบริการเสริม',
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

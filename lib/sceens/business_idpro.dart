import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_raft/custom/show_image.dart';
import 'package:flutter_raft/custom/show_title.dart';
import 'package:flutter_raft/models/promotion_model.dart';
import 'package:flutter_raft/models/sqlite.dart';
import 'package:flutter_raft/models/sqlite_promotionmodel.dart';
import 'package:flutter_raft/sceens/detail_promotion.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:flutter_raft/utils/constant_server_image.dart';
import 'package:flutter_raft/utils/dialog.dart';
// import 'package:flutter_raft/utils/dialog.dart';
import 'package:flutter_raft/utils/my_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListPromotion extends StatefulWidget {
  const ListPromotion({Key? key}) : super(key: key);

  @override
  _ListPromotionState createState() => _ListPromotionState();
}

class _ListPromotionState extends State<ListPromotion> {
  bool load = true;
  List<PromotionModel> promotionModel = [];
  List<PromotionSQLite> promotionSQLite = [];

  String? readIdPro;

  @override
  void initState() {
    super.initState();
    loadvaluepromotion();
    processPromotionSQLite();
    readIdPromotion();
  }

  Future<Null> processPromotionSQLite() async {
    await SQLiteHelper().readPromotionSQLite().then((value) {
      setState(() {
        load = false;
        promotionSQLite = value;
      });
    });
  }

  Future<Null> readIdPromotion() async {
    await SQLiteHelper().readPromotionSQLite().then((value) {
      if (value.length != 0) {
        List<PromotionSQLite> models = [];
        for (var model in value) {
          models.add(model);
        }
        readIdPro = models[0].proId;
        print('readIdPro ==>> $readIdPro');
      }
    });
  }

  Future<Null> loadvaluepromotion() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String busid = preferences.getString('busid')!;
    var apiGetPromotion =
        Uri.parse('${Constant().domain}/APIPromotions/GetPromotions/$busid');
    var response = await http.get(apiGetPromotion);
    setState(() {
      load = false;
    });
    final List jsonFromServices = json.decode(response.body);
    List<PromotionModel> result = jsonFromServices
        .map(
          (e) => PromotionModel.fromJson(e),
        )
        .toList();
    for (var item in result) {
      setState(() {
        promotionModel.add(item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView(
      children: [
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Flexible(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.search,
                      ),
                      hintText: "ค้นหาโปรโมชัน"),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: List.generate(
            promotionModel.length,
            (index) {
              return Column(
                children: [
                  _servicesImage(promotionModel[index]),
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

  Widget _servicesImage(PromotionModel promotionModel) {
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
                      builder: (context) => DetailPromotion(promotionModel),
                    ),
                  );
                },
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        '${ServerImage().domain}${promotionModel.promotionImage}',
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
                      promotionModel.promotionName,
                      style: TextStyle(fontSize: 22),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      promotionModel.businessName,
                      style: TextStyle(
                          fontSize: 13, color: Colors.black.withOpacity(0.7)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '\฿ ${promotionModel.promotionDiscoun} %',
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  _showAlerDialogPro(promotionModel);
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

  Future<Null> _showAlerDialogPro(PromotionModel promotionModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(pathImage: MyConstant.logoraft),
          title: ShowTitle(
            title: promotionModel.promotionName,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
              title: promotionModel.businessName,
              textStyle: MyConstant().h3Style()),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              '${ServerImage().domain}${promotionModel.promotionImage}',
              fit: BoxFit.cover,
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String proId = promotionModel.promotionId;
              String proName = promotionModel.promotionName;
              String proImage = promotionModel.promotionImage;
              String proDetaits = promotionModel.promotionDetails;
              String proStartdate =
                  promotionModel.promotionStartdate.toIso8601String();
              String proLastdate =
                  promotionModel.promotionLastdate.toIso8601String();
              String proStatusId = promotionModel.promotionStatusId.toString();
              String proStatusName = promotionModel.spromotionName;
              String proDiscoun = promotionModel.promotionDiscoun.toString();
              String proBusId = promotionModel.businessId;
              if (promotionSQLite.isNotEmpty) {
                Navigator.pop(context);

                MyDialog().normalDialog(
                    context,
                    'คุณมีโปรโมชัน ${promotionModel.promotionName} ',
                    'คุณสามารถจองโปรโมชันได้หนึ่งครั้งต่อหนึ่งรายการ');
              } else {
                print(
                    'IDServices  ==>> $proId, $proName, $proImage, $proDetaits, $proStartdate, $proLastdate, $proStatusId, $proStatusName, $proDiscoun, $proBusId');
                PromotionSQLite promotionSQLite = PromotionSQLite(
                    proId: proId,
                    proName: proName,
                    proImage: proImage,
                    proDetaits: proDetaits,
                    proStartdate: proStartdate,
                    proLastdate: proLastdate,
                    proStatusId: proStatusId,
                    proStatusName: proStatusName,
                    proDiscoun: proDiscoun,
                    proBusId: proBusId);
                await SQLiteHelper()
                    .inserPromotionToSQLite(promotionSQLite)
                    .then((value) {
                  Navigator.pop(context);
                });
              }
            },
            child: Text('จองโปรโมชัน',
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

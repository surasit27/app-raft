import 'package:flutter/material.dart';
import 'package:flutter_raft/custom/show_image.dart';
import 'package:flutter_raft/custom/show_title.dart';
import 'package:flutter_raft/models/promotion_model.dart';
import 'package:flutter_raft/models/sqlite.dart';
import 'package:flutter_raft/models/sqlite_promotionmodel.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:flutter_raft/utils/constant_server_image.dart';
import 'package:flutter_raft/utils/my_constant.dart';
import 'package:intl/intl.dart';

class DetailPromotion extends StatelessWidget {
  PromotionModel promotionModel;
  DetailPromotion(this.promotionModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // centerTitle: true,
                BackButton(
                  color: Colors.black87,
                ),
                // IconButton(
                //     onPressed: () => Navigator.of([index]).pop(),
                //     icon: Icon(Icons.arrow_back_ios_new)),
                SizedBox(
                  width: 20,
                ),
                Flexible(
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
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.grey.withOpacity(0.8),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Container(
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                '${ServerImage().domain}${promotionModel.promotionImage}'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Text(
                        promotionModel.businessName,
                        style: MyConstant().h1Style(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () {
                        // _showAlerDialogService(servicesModel, context);
                        // _showAlerDialogRaft(raftIdMode);
                        _showAlerDialogPro(promotionModel, context);
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
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Text(
                  'ส่วนลด ${promotionModel.promotionDiscoun} %',
                  style: MyConstant().h2Style(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  'วันที่โปรโมชัน ${DateFormat('dd/MM/yyyy').format(promotionModel.promotionStartdate).toString()} - ${DateFormat('dd/MM/yyyy').format(promotionModel.promotionLastdate).toString()}',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  promotionModel.promotionDetails,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'ติดต่อสอบถาม',
                  style: MyConstant().h2Style(),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.account_circle_outlined,
                    ),
                    title: ShowTitle(
                      title: promotionModel.businessName,
                      textStyle: MyConstant().h3Style(),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.call_outlined,
                    ),
                    title: ShowTitle(
                      title: promotionModel.businessTel,
                      textStyle: MyConstant().h3Style(),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.add_circle_outline,
                    ),
                    title: ShowTitle(
                      title: promotionModel.businessIdline,
                      textStyle: MyConstant().h3Style(),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.email_outlined,
                    ),
                    title: ShowTitle(
                      title: promotionModel.businessEmail,
                      textStyle: MyConstant().h3Style(),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                    ),
                    title: ShowTitle(
                      title: '${promotionModel.businessAddress}'
                          ' ${promotionModel.businessSubdistrict}'
                          ' ${promotionModel.businessDistrict}'
                          ' ${promotionModel.businessProvince}'
                          ' ${promotionModel.businessZipcode}',
                      textStyle: MyConstant().h3Style(),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> _showAlerDialogPro(
      PromotionModel promotionModel, BuildContext context) async {
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
              // SharedPreferences preferences =
              //     await SharedPreferences.getInstance();
              // String serraftid = preferences.getString('serraftid')!;

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

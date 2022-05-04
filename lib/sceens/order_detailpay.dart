import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_raft/custom/show_image.dart';
import 'package:flutter_raft/custom/show_title.dart';
import 'package:flutter_raft/models/confirm.dart';
import 'package:flutter_raft/models/order_Model.dart';
import 'package:flutter_raft/models/order_raft.dart';
import 'package:flutter_raft/models/order_services.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:flutter_raft/utils/my_constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderDetailPay extends StatefulWidget {
  const OrderDetailPay({Key? key}) : super(key: key);

  @override
  _OrderDetailPayState createState() => _OrderDetailPayState();
}

class _OrderDetailPayState extends State<OrderDetailPay> {
  bool load = true;
  List<OrderModel> orderModel = [];
  List<OrderRaftModel> orderRaftModel = [];
  List<OrderServicesModel> orderServicesModel = [];
  File? file;
  Future<File>? tempfile;
  String? base64Image;
  final fromkey = GlobalKey<FormState>();
  Confirm confirm = Confirm();

  int? sumtotal;
  @override
  void initState() {
    super.initState();
    loadValueOrder();
    loadValueOrderRaft();
    loadValueOrderServices();
  }

  Future<Null> loadValueOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String orderId = preferences.getString('orderId')!;
    print('orderId ==> $orderId');
    var apiGetOrder =
        Uri.parse('${Constant().domain}/APIOrders/GetOrderId/$orderId');
    var response = await http.get(apiGetOrder);
    setState(() {
      load = false;
    });
    final List jsonFromOrder = json.decode(response.body);
    List<OrderModel> result =
        jsonFromOrder.map((e) => OrderModel.fromJson(e)).toList();
    print(response.body);
    for (var item in result) {
      setState(() {
        orderModel.add(item);
        print(item.orderId);
      });
    }
    calculateTotal();
  }

  void calculateTotal() async {
    sumtotal = 0;
    for (var item in orderModel) {
      int sumpay = item.orderPrice!.toInt();
      int sumdeposit = item.orderDeposit!.toInt();
      setState(() {
        sumtotal = sumpay - sumdeposit;
      });
    }

    print(sumtotal);
  }

  Future<Null> loadValueOrderRaft() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String orderraftid = preferences.getString('orderId')!;
    print('orderraftid ==> $orderraftid');
    var apiGetOrderRaft =
        Uri.parse('${Constant().domain}/APIOrders/GetOrderRaft/$orderraftid');
    var response = await http.get(apiGetOrderRaft);
    setState(() {
      load = false;
    });
    final List jsonFromOrderRaft = json.decode(response.body);
    List<OrderRaftModel> result =
        jsonFromOrderRaft.map((e) => OrderRaftModel.fromJson(e)).toList();
    print(response.body);
    for (var item in result) {
      setState(() {
        orderRaftModel.add(item);
        print(item.raftName);
      });
    }
  }

  Future<Null> loadValueOrderServices() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String orderservicesid = preferences.getString('orderId')!;
    print('orderservicesid ==> $orderservicesid');
    var apiGetOrderServices = Uri.parse(
        '${Constant().domain}/APIOrders/GetOrderServices/$orderservicesid');
    var response = await http.get(apiGetOrderServices);
    setState(() {
      load = false;
    });
    final List jsonFromOrderSer = json.decode(response.body);
    List<OrderServicesModel> result =
        jsonFromOrderSer.map((e) => OrderServicesModel.fromJson(e)).toList();
    print(response.body);
    for (var item in result) {
      setState(() {
        orderServicesModel.add(item);
        print(item.servicesName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/order_history'),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black87,
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black87,
              )),
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView(
      children: [
        SizedBox(
          width: 20,
        ),
        Column(
          children: List.generate(
            orderModel.length,
            (index) {
              return Column(
                children: [
                  _listOrderId(orderModel[index]),
                ],
              );
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
              child: Text(
                'รายการแพ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Column(
          children: List.generate(
            orderRaftModel.length,
            (index) {
              return Column(
                children: [
                  _orderRaft(orderRaftModel[index]),
                ],
              );
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
              child: Text(
                'รายการบริการเสริม',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Column(
          children: List.generate(
            orderServicesModel.length,
            (index) {
              return Column(
                children: [
                  _orderServices(orderServicesModel[index]),
                ],
              );
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
              child: Text(
                'รายการโปรโมชัน',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Column(
          children: List.generate(
            orderModel.length,
            (index) {
              return Column(
                children: [
                  _listOrder(orderModel[index]),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _listOrderId(OrderModel orderModel) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        orderModel.orderId!,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: SizedBox(
                                height: 10,
                                width: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(99),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 5),
                                    blurRadius: 50,
                                    color: Color(0xFF12153D).withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              orderModel.sorderName!,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'วันที่จอง ${DateFormat('dd/MM/yyyy').format(orderModel.orderDate!).toString()} - ${DateFormat('dd/MM/yyyy').format(orderModel.orderLastdate!).toString()}',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }

  Widget _orderRaft(OrderRaftModel orderRaftModel) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 5),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  orderRaftModel.raftName,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'ราคา ${orderRaftModel.raftPrice}',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderServices(OrderServicesModel orderServicesModel) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 5),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  orderServicesModel.servicesName,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'ราคา ${orderServicesModel.servicesPrice}',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _listOrder(OrderModel orderModel) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 5),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  orderModel.promotionName!,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'ส่วนลด ${orderModel.promotionDiscoun} %',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'ยอดเงินที่ต้องชำระ:  ${orderModel.orderPrice}',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'เงินมัดจำ:  ${orderModel.orderDeposit}',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'เงินที่ค้างชำระ:  $sumtotal',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.account_balance_outlined,
                    ),
                    title: ShowTitle(
                      title: 'ธนาคาร ${orderModel.businessBank}',
                      textStyle: MyConstant().h3Style(),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.credit_card_outlined,
                    ),
                    title: ShowTitle(
                      title: 'เลขบัญชี ${orderModel.businessAccountnumber}',
                      textStyle: MyConstant().h3Style(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: _uploadImagePay(),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('ยื่นยันการจอง'),
                      onPressed: () => setState(() {
                        _uploadPay(orderModel);
                      }),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  void _uploadPay(OrderModel orderModel) async {
    if (file == null) {
      _alertUploadImageDialog();
    } else {
      String fid = "files";

      final payUri = Uri.parse('${Constant().domain}/APIOrders/UpdateImage');
      http.MultipartRequest request = http.MultipartRequest('PUT', payUri);
      http.MultipartFile imagePay =
          await http.MultipartFile.fromPath(fid, file!.path);

      request.files.add(imagePay);
      request.fields['OrderId'] = orderModel.orderId!;
      request.fields['sumtotal'] = sumtotal.toString();
      http.StreamedResponse responseImage = await request.send();
      var imagepay = await responseImage.stream.bytesToString();
      Navigator.pushReplacementNamed(context, '/home');
      // DateTime? startDate = orderModel.orderDate;
      // DateTime? lastDate = orderModel.orderDate;
      // int? price = orderModel.orderPrice;
      // String? imagedeposit = orderModel.orderImageDeposit;
      // int? deposit = orderModel.orderDeposit;
      // String? imagePay = imagepay;
      // int? pay = sumtotal;
      // String? userId = orderModel.userId;
      // String? promotionId = orderModel.promotionId;

      // confirm = Confirm(
      //   date: startDate,
      //   datelast: lastDate,
      //   price: price,
      //   deposit: deposit.toString(),
      //   userid: userId,
      //   iDPro: promotionId,
      //   pathfile: imagedeposit,
      //   pay: pay,
      //   pathfilepay: imagePay,
      // );
      // var apiDeposite = Uri.parse('${Constant().domain}/APIOrders/UpdateImage');
      // var response = await http.put(
      //   apiDeposite,
      //   headers: {"Content-type": "application/json"},
      //   body: json.encode(confirm.toJson()),
      // );
    }
  }

  void _alertUploadImageDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("ทำการมัดจำไม่สำเร็จ"),
            content: Text("กรุณาใส่สลิปมัดจำเงิน"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("ตกลง"))
            ],
          );
        });
  }

  Widget _uploadImagePay() {
    return Column(
      children: [
        Container(
          width: 200,
          child: InkWell(
            onTap: () => sourceImage(),
            child: file == null
                ? Image.asset(MyConstant.uploadimage)
                : Image.file(file!),
          ),
        ),
      ],
    );
  }

  Future<Null> processImage(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .pickImage(source: source, maxHeight: 800, maxWidth: 800);
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Future<Null> sourceImage() async {
    // print('sourceImage ==>$index');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(
            pathImage: MyConstant.logoraft,
          ),
          title: ShowTitle(
            title: 'อัพโหลดสลิป ? ',
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
            title: 'กรุณากดถ่ายรูปหรือเลือกภาพจากแกลเลอรี่',
            textStyle: MyConstant().h3Style(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                processImage(ImageSource.camera);
              },
              child: Text('ถ่ายรูป')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                processImage(ImageSource.gallery);
              },
              child: Text('แกลเลอรี่')),
        ],
      ),
    );
  }
}

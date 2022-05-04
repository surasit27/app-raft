import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_raft/models/order_Model.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderPay extends StatefulWidget {
  const OrderPay({Key? key}) : super(key: key);

  @override
  _OrderPayState createState() => _OrderPayState();
}

class _OrderPayState extends State<OrderPay> {
  List<OrderModel> orderModel = [];

  bool load = true;

  @override
  void initState() {
    super.initState();
    loadValueOrderPay();
  }

  Future<Null> loadValueOrderPay() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString('userId')!;
    print('userID ==> $userId');
    var apiGetOrder =
        Uri.parse('${Constant().domain}/APIOrders/GetOrderPay/$userId');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black87,
            )),
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
                  _listOrder(orderModel[index]),
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

  Widget _listOrder(OrderModel orderModel) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                      Text(
                        orderModel.orderId!,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: kTextColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'วันที่จอง ${DateFormat('dd/MM/yyyy').format(orderModel.orderDate!).toString()} - ${DateFormat('dd/MM/yyyy').format(orderModel.orderLastdate!).toString()}',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 40, left: 40),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    SharedPreferences _prefs =
                                        await SharedPreferences.getInstance();
                                    _prefs.setString(
                                        'orderId', orderModel.orderId!);
                                    Navigator.pushReplacementNamed(
                                        context, '/order_detailpay');
                                  },
                                  child: Text(
                                    'ชำระเงินยอดคงเหลือ',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

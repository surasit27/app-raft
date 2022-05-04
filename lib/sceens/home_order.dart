import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_raft/custom/show_image.dart';
import 'package:flutter_raft/custom/show_progress.dart';
import 'package:flutter_raft/custom/show_title.dart';
import 'package:flutter_raft/models/businesses_model.dart';
import 'package:flutter_raft/models/confirm.dart';
import 'package:flutter_raft/models/sqlite.dart';
import 'package:flutter_raft/models/sqlite_promotionmodel.dart';
import 'package:flutter_raft/models/sqlite_raftmodel.dart';
import 'package:flutter_raft/models/sqlite_servicesmodel.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:flutter_raft/utils/my_constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeOrder extends StatefulWidget {
  const HomeOrder({Key? key}) : super(key: key);

  @override
  _HomeOrderState createState() => _HomeOrderState();
}

class _HomeOrderState extends State<HomeOrder> {
  Confirm confirm = Confirm();
  bool load = true;
  List<BusinessesModel> businessesModel = [];
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<RaftSQLite> raftSQLite = [];
  String? raftIdBus;
  List<SesviceSQLite> servicesSQLite = [];
  List<PromotionSQLite> promotionSQLite = [];
  double? total;
  bool isCompleted = false;
  double? totalser;
  double? totalpro;
  double? sumtotalpro;
  double? sumtotal;
  double? sumtotalraft;
  double? totaldeposit;
  double? totalpay;

  File? file;
  Future<File>? tempfile;
  String? base64Image;
  final fromkey = GlobalKey<FormState>();
  //  String? idOrderPro;

  int currentStep = 0;

  DateTime _date = DateTime.now();
  DateTime _datelast = DateTime.now();

  TextEditingController depositController = TextEditingController();
  TextEditingController payController = TextEditingController();
  TextEditingController imgedepositController = TextEditingController();
  TextEditingController startdateController = TextEditingController();
  TextEditingController lastdateController = TextEditingController();
  TextEditingController idcardController = TextEditingController();

  @override
  void initState() {
    super.initState();
    processRaftSQLite();
    processServiceSQLite();
    processPromotionSQLite();
  }

  Future _getDate(BuildContext context) async {
    final newdate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (newdate != null) {
      setState(() {
        _date = newdate;
        print(_date.toString());
      });

      startdateController.text =
          DateFormat('dd/MM/yyyy').format(newdate).toString();
    }
  }

  Future _getLastDate(BuildContext context) async {
    // final initialDate = DateTime.now();
    final newlastdate = await showDatePicker(
      context: context,
      initialDate: _datelast,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (newlastdate != null) {
      setState(() {
        _datelast = newlastdate;
        print(_datelast.toString());
      });

      // lastdateController.text = newlastdate.toIso8601String();
      lastdateController.text =
          DateFormat('dd/MM/yyyy').format(newlastdate).toString();
      // print(lastdateController.text);
    }
  }

  Future<Null> processRaftSQLite() async {
    if (raftSQLite.isNotEmpty) {
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

  void calculateTotaldeposit() {
    totaldeposit = 0;

    double sumdeposit = double.parse(depositController.text);
    setState(() {
      totaldeposit = sumtotal! - sumdeposit;
    });
  }

  void calculateTotal() async {
    total = 0;
    for (var item in raftSQLite) {
      double sumInt = double.parse(item.raftPrice.trim());
      setState(() {
        total = total! + sumInt;
      });
    }
  }

  Future<Null> processServiceSQLite() async {
    if (servicesSQLite.isNotEmpty) {
      servicesSQLite.clear();
    }
    await SQLiteHelper().readServiceSQLite().then((value) {
      setState(() {
        load = false;
        servicesSQLite = value;
        calculateTotalser();
        // findbusOrderRaft();
      });
    });
  }

  void calculateTotalser() async {
    totalser = 0;
    for (var item in servicesSQLite) {
      double sumIntser = double.parse(item.serPrice.trim());
      setState(() {
        totalser = totalser! + sumIntser;
        sumtotalraft = total! + totalser!;

        // calculateTotalPay();
        // sumTotal();
      });
    }
  }

  Future<Null> processPromotionSQLite() async {
    if (promotionSQLite.isNotEmpty) {
      promotionSQLite.clear();
    }
    await SQLiteHelper().readPromotionSQLite().then((value) {
      setState(() {
        load = false;
        promotionSQLite = value;
        calculateTotalPromotion();
      });
    });
  }

  void calculateTotalPromotion() async {
    totalpro = 0;
    sumtotalpro = 0;
    for (var item in promotionSQLite) {
      double sumIntpro = double.parse(item.proDiscoun.trim());
      setState(() {
        totalpro = total! / sumIntpro;
        sumtotal = total! + totalser! - totalpro!;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: load
          ? ShowProgress()
          : raftSQLite.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: ShowImage(
                          pathImage: MyConstant.logoraft,
                        ),
                      ),
                      ShowTitle(
                        title: 'กรุณาทำการจองแพ',
                        textStyle: MyConstant().h1Style(),
                      ),
                    ],
                  ),
                )
              : isCompleted
                  ? buidCompleted()
                  : Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(primary: Colors.blue),
                      ),
                      child: Stepper(
                          type: StepperType.horizontal,
                          steps: getsteps(),
                          currentStep: currentStep,
                          onStepContinue: () {
                            final isLastStap =
                                currentStep == getsteps().length - 1;
                            if (isLastStap) {
                              setState(() => isCompleted = true);
                            } else {
                              setState(() => currentStep += 1);
                            }
                          },
                          // onStepTapped: (step) => setState(() => currentStep = step),
                          onStepCancel: currentStep == 0
                              ? null
                              : () => setState(() => currentStep -= 1),
                          controlsBuilder: (context,
                              {onStepContinue, onStepCancel}) {
                            final isLastStep =
                                currentStep == getsteps().length - 1;
                            return Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      child: Text(isLastStep
                                          ? 'ยื่นยันการจอง'
                                          : 'ถัดไป'),
                                      onPressed: onStepContinue,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
    );
  }

  List<Step> getsteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text('ยื่นยันการจอง'),
          content: Container(
            child: _buildOrder(),
          ),
        ),
        Step(
          // state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text('มัดจำเงิน'),
          content: Container(
            child: _buildDeposit(),
          ),
        ),
      ];

  Widget _buildDeposit() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShowTitle(
                title: 'ทำการมัดจำแพและบริการเสริม',
                textStyle: MyConstant().h1Style()),
            Container(
              child: Column(
                children: List.generate(
                  businessesModel.length,
                  (index) => Container(
                    child: Column(
                      children: [
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
                                  title:
                                      'ธนาคาร ${businessesModel[index].businessBank}',
                                  textStyle: MyConstant().h3Style(),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.credit_card_outlined,
                                ),
                                title: ShowTitle(
                                  title:
                                      'เลขบัญชี ${businessesModel[index].businessAccountnumber}',
                                  textStyle: MyConstant().h3Style(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: fromkey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        buildLoadImage(),
                        SizedBox(
                          height: 20,
                        ),
                        buildDeposit(),
                        SizedBox(
                          height: 20,
                        ),
                        buildDepositStartDate(),
                        SizedBox(
                          height: 20,
                        ),
                        buildDepositLastdate(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildBusines() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'ติดต่อสอบถาม',
          style: MyConstant().h2Style(),
        ),
        Container(
          child: Column(
            children: List.generate(
              businessesModel.length,
              (index) => Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.account_circle_outlined,
                            ),
                            title: ShowTitle(
                              title: businessesModel[index].businessName,
                              textStyle: MyConstant().h3Style(),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.call_outlined,
                            ),
                            title: ShowTitle(
                              title: businessesModel[index].businessTel,
                              textStyle: MyConstant().h3Style(),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.add_circle_outline,
                            ),
                            title: ShowTitle(
                              title: businessesModel[index].businessIdline,
                              textStyle: MyConstant().h3Style(),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.email_outlined,
                            ),
                            title: ShowTitle(
                              title: businessesModel[index].businessEmail,
                              textStyle: MyConstant().h3Style(),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.location_on,
                            ),
                            title: ShowTitle(
                              title: '${businessesModel[index].businessAddress}'
                                  ' ${businessesModel[index].businessSubdistrict}'
                                  ' ${businessesModel[index].businessDistrict}'
                                  ' ${businessesModel[index].businessProvince}'
                                  ' ${businessesModel[index].businessZipcode}',
                              textStyle: MyConstant().h3Style(),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrder() {
    return Column(
      children: [
        Container(
          child: Column(
              children: List.generate(businessesModel.length, (index) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _nameOrderRaft(businessesModel[index]),
                  _buildRaftOrder()
                ],
              ),
            );
          })),
        ),
        Container(
          child: Column(
            children: List.generate(raftSQLite.length, (index) {
              return Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ShowTitle(
                              title: raftSQLite[index].raftName,
                              textStyle: MyConstant().h3Style()),
                        ),
                        Expanded(
                          flex: 1,
                          child: ShowTitle(
                              title: raftSQLite[index].raftPrice,
                              textStyle: MyConstant().h3Style()),
                        ),
                        Expanded(
                          flex: 0,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  SharedPreferences _prefs =
                                      await SharedPreferences.getInstance();
                                  _prefs.setString(
                                      'busid', raftSQLite[index].busId);
                                  _prefs.setString(
                                      'serraftid', raftSQLite[index].raftId);
                                  Navigator.pushReplacementNamed(
                                      context, '/list_business');
                                },
                                icon: Icon(
                                  Icons.dashboard_customize_outlined,
                                  color: Colors.blue.shade500,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  int idSQLite = raftSQLite[index].id!;
                                  print('Delete ==>> $idSQLite');
                                  await SQLiteHelper()
                                      .deleteRaftSQLite(idSQLite)
                                      .then((value) => processRaftSQLite());
                                },
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        Container(
          child: Column(
              children: List.generate(servicesSQLite.length, (index) {
            return Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ShowTitle(
                            title: servicesSQLite[index].serName,
                            textStyle: MyConstant().h3Style()),
                      ),
                      Expanded(
                        flex: 1,
                        child: ShowTitle(
                            title: servicesSQLite[index].serPrice,
                            textStyle: MyConstant().h3Style()),
                      ),
                      Expanded(
                        flex: 0,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                            ),
                            IconButton(
                              onPressed: () async {
                                // _refresh.currentState!.show();
                                int idSerSQLite =
                                    servicesSQLite[index].sqliteid!;
                                print('Delete ==>> $idSerSQLite');
                                await SQLiteHelper()
                                    .deleteServicesSQLite(idSerSQLite)
                                    .then((value) => processServiceSQLite());
                              },
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          })),
        ),
        Container(
          child: Column(
              children: List.generate(promotionSQLite.length, (index) {
            return Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ShowTitle(
                            title: 'โปรโมชัน${promotionSQLite[index].proName}',
                            textStyle: MyConstant().h3Style()),
                      ),
                      Expanded(
                        flex: 1,
                        child: ShowTitle(
                            title: '${promotionSQLite[index].proDiscoun} %',
                            textStyle: MyConstant().h3Style()),
                      ),
                      Expanded(
                        flex: 0,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                            ),
                            IconButton(
                              onPressed: () async {
                                // _refresh.currentState!.show();
                                int sqliteProid =
                                    promotionSQLite[index].sqliteProid!;
                                print('Delete ==>> $sqliteProid');
                                await SQLiteHelper()
                                    .deletePromotionSQLite(sqliteProid)
                                    .then((value) => processPromotionSQLite());
                              },
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          })),
        ),
        Divider(color: MyConstant.dark),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ShowTitle(
                            title: 'ราคาแพ :',
                            textStyle: MyConstant().h2Style()),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShowTitle(
                        title: total == null ? '' : total.toString(),
                        textStyle: MyConstant().h2Style()),
                  ],
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ShowTitle(
                            title: 'ส่วนลดแพ :',
                            textStyle: MyConstant().h2Style()),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShowTitle(
                        title: totalpro == null ? '' : totalpro.toString(),
                        textStyle: MyConstant().h2Style()),
                  ],
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ShowTitle(
                            title: 'ราคาบริการเสริม :',
                            textStyle: MyConstant().h2Style()),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShowTitle(
                        title: totalser == null ? '' : totalser.toString(),
                        textStyle: MyConstant().h2Style()),
                  ],
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ShowTitle(
                            title: 'ราคารวม :',
                            textStyle: MyConstant().h2Style()),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ShowTitle(
                            title: sumtotal == null
                                ? sumtotalraft.toString()
                                : sumtotal.toString(),
                            textStyle: MyConstant().h2Style()),
                      ],
                    )),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: fromkey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            buildStartDate(),
                            SizedBox(
                              height: 20,
                            ),
                            buildLastdate(),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            // buildBusines(),
          ],
        ),
      ],
    );
  }

  buidCompleted() => Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ShowTitle(
                      title: 'ทำการยื่นยันการจองแพ',
                      textStyle: MyConstant().h1Style(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'วันที่จอง ${DateFormat('dd/MM/yyyy').format(_date).toString()} - ${DateFormat('dd/MM/yyyy').format(_datelast).toString()}',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              ShowTitle(
                  title: 'รายการที่จอง', textStyle: MyConstant().h2Style()),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Column(
                    children: List.generate(raftSQLite.length, (index) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ShowTitle(
                                    title: raftSQLite[index].raftName,
                                    textStyle: TextStyle(
                                        fontSize: 16, color: Colors.grey)),
                              ),
                              Expanded(
                                flex: 2,
                                child: ShowTitle(
                                  title: raftSQLite[index].raftPrice,
                                  textStyle: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })),
              ),
              Container(
                child: Column(
                    children: List.generate(servicesSQLite.length, (index) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ShowTitle(
                                    title: servicesSQLite[index].serName,
                                    textStyle: TextStyle(
                                        fontSize: 16, color: Colors.grey)),
                              ),
                              Expanded(
                                flex: 2,
                                child: ShowTitle(
                                  title: servicesSQLite[index].serPrice,
                                  textStyle: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })),
              ),
              Container(
                child: Column(
                    children: List.generate(promotionSQLite.length, (index) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ShowTitle(
                                    title: promotionSQLite[index].proName,
                                    textStyle: TextStyle(
                                        fontSize: 16, color: Colors.grey)),
                              ),
                              Expanded(
                                flex: 2,
                                child: ShowTitle(
                                  title:
                                      '${promotionSQLite[index].proDiscoun} %',
                                  textStyle: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })),
              ),
              Divider(color: MyConstant.dark),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ShowTitle(
                                title: 'ราคาแพ :',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          )),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ShowTitle(
                            title: total == null ? '' : total.toString(),
                            textStyle:
                                TextStyle(fontSize: 16, color: Colors.grey),
                          )
                        ],
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ShowTitle(
                                title: 'ส่วนลดแพ :',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          )),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ShowTitle(
                            title: totalpro == null ? '' : totalpro.toString(),
                            textStyle:
                                TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ShowTitle(
                                title: 'ราคาบริการเสริม :',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          )),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ShowTitle(
                            title: totalser == null ? '' : totalser.toString(),
                            textStyle:
                                TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ShowTitle(
                                title: 'ราคารวม :',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ShowTitle(
                                title: sumtotal == null
                                    ? sumtotalraft.toString()
                                    : sumtotal.toString(),
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ShowTitle(
                                title: 'เงินมัดจำ :',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ShowTitle(
                                title: '${depositController.text}.0',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('ยกเลิกการจอง'),
                        onPressed: () => setState(() {
                          isCompleted = false;
                          currentStep = 0;
                          uploadOrder();
                        }),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        child: Text('ยื่นยันการจอง'),
                        onPressed: () => setState(() {
                          isCompleted = false;
                          currentStep = 0;
                          uploadOrder();
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Container _buildRaftOrder() {
    return Container(
      decoration: BoxDecoration(color: MyConstant.light),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ShowTitle(
                    title: 'รายการที่จอง', textStyle: MyConstant().h2Style()),
              ),
              Expanded(
                flex: 1,
                child:
                    ShowTitle(title: 'ราคา', textStyle: MyConstant().h2Style()),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nameOrderRaft(BusinessesModel businessesModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ShowTitle(
        title: businessesModel == null ? '' : businessesModel.businessName,
        textStyle: MyConstant().h1Style(),
      ),
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

  Widget buildPay() {
    return Container(
      child: TextFormField(
        controller: payController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกเงินหมัดจำ';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'ยอดเงินที่ต้องชำระ :',
          prefixIcon: Icon(
            Icons.paid_outlined,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
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

  Widget buildLoadImage() {
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

  Widget buildLoadImagePay() {
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

  Widget buildPayDeposit() {
    return Container(
      child: TextFormField(
        controller: depositController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกเงินหมัดจำ';
          } else {
            return null;
          }
        },
        readOnly: true,
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'เงินหมัดจำ :',
          prefixIcon: Icon(
            Icons.paid_outlined,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget buildDeposit() {
    return Container(
      child: TextFormField(
        controller: depositController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกเงินหมัดจำ';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'เงินหมัดจำ :',
          prefixIcon: Icon(
            Icons.paid_outlined,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget buildStartDate() {
    return Container(
      child: TextFormField(
        onTap: () async {
          await _getDate(context);
        },
        readOnly: true,
        controller: startdateController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาเลือกวันที่เข้าพัก';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'วันที่เข้าพัก',
          hintText: (DateFormat('dd/MM/yyyy').format(_date).toString()),
          labelStyle: MyConstant().h3Style(),
          prefixIcon: Icon(
            Icons.calendar_today_outlined,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget buildDepositStartDate() {
    return Container(
      child: TextFormField(
        // onTap: () async {
        //   await _getDate(context);
        // },
        readOnly: true,
        controller: startdateController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาเลือกวันที่เข้าพัก';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'วันที่เข้าพัก',
          hintText: (DateFormat('dd/MM/yyyy').format(_date).toString()),
          labelStyle: MyConstant().h3Style(),
          prefixIcon: Icon(
            Icons.calendar_today_outlined,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget buildLastdate() {
    return Container(
      child: TextFormField(
        onTap: () async {
          await _getLastDate(context);
        },
        readOnly: true,
        controller: lastdateController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาเลือกวันที่ออกจากที่พัก';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'วันที่ออกจากที่พัก :',
          hintText: (DateFormat('dd/MM/yyyy').format(_datelast).toString()),
          labelStyle: MyConstant().h3Style(),
          prefixIcon: Icon(
            Icons.date_range_outlined,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        keyboardType: TextInputType.datetime,
      ),
    );
  }

  Widget buildDepositLastdate() {
    return Container(
      child: TextFormField(
        // onTap: () async {
        //   await _getLastDate(context);
        // },
        readOnly: true,
        controller: lastdateController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาเลือกวันที่ออกจากที่พัก';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'วันที่ออกจากที่พัก :',
          hintText: (DateFormat('dd/MM/yyyy').format(_datelast).toString()),
          labelStyle: MyConstant().h3Style(),
          prefixIcon: Icon(
            Icons.date_range_outlined,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        keyboardType: TextInputType.datetime,
      ),
    );
  }

  Row buildConfirm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              if (fromkey.currentState!.validate()) {}
            },
            child: Text('ยืนยันการจอง'),
          ),
        ),
      ],
    );
  }

  void uploadOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString('userId')!;

    List<String> raftIDs = [];
    List<String> services = [];

    for (var item in raftSQLite) {
      raftIDs.add(item.raftId);
    }

    for (var item1 in servicesSQLite) {
      services.add(item1.serId);
    }

    String raftID = raftIDs.toString();
    String serviceID = services.toString();
    String proId = promotionSQLite[0].proId;

    if (file == null) {
      _alertUploadImageDialog();
    } else {
      String fid = "files";
      final postUri = Uri.parse('${Constant().domain}/APIOrders/SaveImage');
      http.MultipartRequest request = http.MultipartRequest('POST', postUri);

      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath(fid, file!.path);

      request.files.add(multipartFile);

      http.StreamedResponse responseImage = await request.send();
      var pathimage = await responseImage.stream.bytesToString();

      String fidPay = "NullPay.png";
      final postPayUri =
          Uri.parse('${Constant().domain}/APIOrders/SaveImagePay');
      http.MultipartRequest requestpay =
          http.MultipartRequest('POST', postPayUri);
      http.MultipartFile multipartFilePay =
          await http.MultipartFile.fromPath(fidPay, file!.path);
      requestpay.files.add(multipartFilePay);

      http.StreamedResponse responseImagePay = await requestpay.send();
      var pathimagePay = await responseImagePay.stream.bytesToString();

      confirm = Confirm(
          date: _date,
          datelast: _datelast,
          price: sumtotal!.toInt(),
          deposit: depositController.text,
          userid: userId,
          raft: raftID,
          iDPro: proId,
          services: serviceID,
          pathfile: pathimage,
          pathfilepay: pathimagePay);
      var apiDeposite =
          Uri.parse('${Constant().domain}/APIOrders/ConfirmOrder');
      var response = await http.post(
        apiDeposite,
        headers: {"Content-type": "application/json"},
        body: json.encode(confirm.toJson()),
      );

      if (response.body == "fase") {
        _alertDeposit();
      } else {
        await SQLiteHelper().emptyRaftSQLite().then((value) {
          return processRaftSQLite();
        });
        await SQLiteHelper().emptyServiseSQlite().then((value) {
          return processServiceSQLite();
        });
        await SQLiteHelper().emptyPromotion().then((value) {
          return processPromotionSQLite();
        });

        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  void _alertDeposit() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("ทำการมัดจำไม่สำเร็จ"),
            content: Text("กรุณาลองทำการมัดจำใหม่อีกครั้ง"),
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
}

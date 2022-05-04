import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_raft/custom/show_image.dart';
import 'package:flutter_raft/custom/show_title.dart';
import 'package:flutter_raft/models/user_model.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:flutter_raft/utils/my_constant.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  UserModel userModel = UserModel();
  // AuthServices authServices = AuthServices();
  bool statusRedEye = true;
  final formKey = GlobalKey<FormState>();
  FocusNode passFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                buildImage(size),
                // buildAppName(),
                buildUser(size),
                buildPassword(size),
                buildLogin(size),
                buildCreateAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: 'คุณไม่มีบัญชีอยู่ในระบบ ?  ',
          textStyle: MyConstant().h3Style(),
        ),
        TextButton(
          onPressed: () =>
              Navigator.pushNamed(context, MyConstant.routeCreateAccount),
          child: Text('ลงทะเบียนเพื่อเข้าใช้'),
        ),
      ],
    );
  }

  Row buildLogin(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.6,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              // String userEmail = emailController.text;
              // String userPassword = passwordController.text;
              // print('userEmail: $userEmail,userPassword: $userPassword');
              // _submit(userEmail: userEmail, userPassword: userPassword);
              _submit();
            },
            child: Text('เข้าสู่ระบบ'),
          ),
        ),
      ],
    );
  }

  void _submit() async {
    userModel = UserModel(
      userPassword: passwordController.text,
      userEmail: emailController.text,
    );

    var login = Uri.parse('${Constant().domain}/APIUsers/Login');
    var response = await http.post(
      login,
      headers: {"Content-type": "application/json"},
      body: json.encode(userModel.toJson()),
    );
    print(response.body);
    // final List jsonFromUser = json.decode(response.body);
    // List<UserModel> result =
    //     jsonFromUser.map((e) => UserModel.fromJson(e)).toList();
    // print(result);
    if (response.body == "flse") {
      _alertloginDialog();
    } else {
      for (var item in json.decode(response.body)) {
        UserModel model = UserModel.fromJson(item);
        if (userModel.userPassword == model.userPassword) {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.setString('userEmail', model.userEmail!);
          _prefs.setString('userId', model.userId!);
          _prefs.setString('userName', model.userName!);
          _prefs.setString('userPassword', model.userPassword!);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _alertPassDialog();
        }
      }
    }
  }

  void _alertloginDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("เข้าระบบไม่สำเร็จ"),
            content: Text("กรุณาเข้าสู่ระบบอีกครั้ง"),
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

  void _alertPassDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("รหัสผ่านไม่ถูกต้อง"),
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

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Email';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              userModel.userEmail = value;
            },
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(passFocusNode);
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'อีเมล :',
              prefixIcon: Icon(
                Icons.account_circle_outlined,
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
            keyboardType: TextInputType.emailAddress,
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            focusNode: passFocusNode,
            controller: passwordController,
            validator: (value) {
              if (value!.length < 3) {
                return 'Please Fill Password';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              userModel.userPassword = value;
            },
            obscureText: statusRedEye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                },
                icon: statusRedEye
                    ? Icon(
                        Icons.visibility_off,
                        color: MyConstant.dark,
                      )
                    : Icon(
                        Icons.remove_red_eye_outlined,
                        color: MyConstant.dark,
                      ),
              ),
              labelStyle: MyConstant().h3Style(),
              labelText: 'รหัสผ่าน :',
              prefixIcon: Icon(
                Icons.lock_outline,
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
        ),
      ],
    );
  }

  Row buildImage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 50),
          width: size * 0.6,
          child: ShowImage(
            pathImage: MyConstant.logoraft,
          ),
        ),
      ],
    );
  }
}

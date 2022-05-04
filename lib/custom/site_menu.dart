import 'package:flutter/material.dart';
import 'package:flutter_raft/custom/show_title.dart';
import 'package:flutter_raft/utils/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SiteMenu extends StatelessWidget {
  const SiteMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ListTile(
            onTap: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.clear().then(
                    (value) => Navigator.pushNamedAndRemoveUntil(
                        context, MyConstant.routeAuthen, (route) => false),
                  );
            },
            tileColor: Colors.black.withOpacity(0.1),
            leading: Icon(
              Icons.exit_to_app,
              size: 30,
              color: Colors.black87,
            ),
            title: ShowTitle(
              title: 'ออกจากระบบ',
              textStyle: MyConstant().h2whiteStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

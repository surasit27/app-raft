import 'dart:convert';

import 'package:flutter_raft/models/raft_model.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchRaftIdBusApi {
  static Future<List<RaftModel>> getSearcdhRaftIdBus(String query) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String busid = preferences.getString('busid')!;
    final url =
        Uri.parse('${Constant().domain}/APIRafts/GetRaftBusiness/$busid');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List raftModel = json.decode(response.body);
      return raftModel
          .map((json) => RaftModel.fromJson(json))
          .where((searchraft) {
        final raftbusLower = searchraft.raftName.toLowerCase();
        final busLower = searchraft.businessName.toLowerCase();
        final searchLower = query.toLowerCase();

        return raftbusLower.contains(searchLower) ||
            busLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}

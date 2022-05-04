import 'dart:convert';

import 'package:flutter_raft/models/raft_model.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:http/http.dart' as http;

class SearchRaftApi {
  static Future<List<RaftModel>> getSearcdhRaft(String query) async {
    final url = Uri.parse('${Constant().domain}/APIRafts/GetRaft');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List raftModel = json.decode(response.body);
      return raftModel
          .map((json) => RaftModel.fromJson(json))
          .where((searchraft) {
        final raftLower = searchraft.raftName.toLowerCase();
        final busLower = searchraft.businessName.toLowerCase();
        final searchLower = query.toLowerCase();

        return raftLower.contains(searchLower) ||
            busLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}

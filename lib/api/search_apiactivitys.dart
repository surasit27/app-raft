import 'dart:convert';

import 'package:flutter_raft/models/activitys_model.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:http/http.dart' as http;

class SearchActivityApi {
  static Future<List<ActivitysModel>> getSearcdhAct(String query) async {
    final url = Uri.parse('${Constant().domain}/APIActivities/GetActivity');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List activitysModel = json.decode(response.body);
      return activitysModel
          .map((json) => ActivitysModel.fromJson(json))
          .where((searchact) {
        final actLower = searchact.activityName.toLowerCase();
        final busLower = searchact.businessName.toLowerCase();
        final searchLower = query.toLowerCase();

        return actLower.contains(searchLower) || busLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}

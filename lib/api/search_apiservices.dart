import 'dart:convert';

import 'package:flutter_raft/models/services_model.dart';
import 'package:flutter_raft/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchServicesIdBusApi {
  static Future<List<ServicesModel>> getSearcdhServicesIdBus(
      String query) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String busid = preferences.getString('busid')!;
    final url =
        Uri.parse('${Constant().domain}/APIServices/GetServices/$busid');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List servicesModel = json.decode(response.body);
      return servicesModel
          .map((json) => ServicesModel.fromJson(json))
          .where((searchser) {
        final serbusLower = searchser.servicesName.toLowerCase();
        final busLower = searchser.businessName.toLowerCase();
        final searchLower = query.toLowerCase();

        return serbusLower.contains(searchLower) ||
            busLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}

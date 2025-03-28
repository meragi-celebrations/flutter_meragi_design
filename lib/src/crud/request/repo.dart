import 'package:flutter_meragi_design/flutter_meragi_design.dart';

import 'model.dart';

abstract class MDRepository {
  Future<ListResponse> getList(String url,
      {List<MDFilter> filters = const [], List<Map<String, String>> sorters = const []});
  Future<dynamic> getOne(String url, dynamic? id, {List<Map<String, String>> filters = const []});
  Future<dynamic> create(String url, {Map<String, dynamic> data = const {}, Map<String, dynamic> files = const {}});
  Future<dynamic> update(String url, dynamic id, {Map<String, dynamic> data = const {}});
  Future<dynamic> delete(String url, dynamic id, {Map<String, dynamic>? params});
  Future<dynamic> custom(String url, {List<Map<String, String>> filters = const []});
}

import 'package:flutter_meragi_design/src/components/filter_form.dart';

import 'model.dart';

abstract class MDRepository {
  Future<ListResponse> getList(String url,
      {List<MDFilter> filters = const [], List<Map<String, String>> sorters = const []});
  Future<dynamic> getOne(String url, dynamic id, {List<MDFilter> filters = const []});
  Future<dynamic> create(String url, {Map<String, dynamic> data = const {}, Map<String, dynamic> files = const {}});
  Future<dynamic> update(String url, dynamic id, {Map<String, dynamic> data = const {}});
  Future<dynamic> delete(String url, dynamic id, {Map<String, dynamic>? params});
  Future<dynamic> custom(String url, {List<MDFilter> filters = const []});
}

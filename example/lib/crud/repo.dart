import 'package:dio/dio.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class ExampleRepo extends MDRepository {
  Dio dio = Dio();

  @override
  Future create(String url,
      {Map<String, dynamic> data = const {},
      Map<String, dynamic> files = const {}}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future custom(url, {List<Map<String, String>> filters = const []}) {
    // TODO: implement custom
    throw UnimplementedError();
  }

  @override
  Future delete(String url, id, {Map<String, dynamic>? params}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<ListResponse> getList(String url,
      {List<MDFilter> filters = const [],
      List<Map<String, String>> sorters = const []}) async {
    Response res = await dio.get(url);
    if (res.statusCode == 200) {
      var rData = res.data;
      print(rData);
      return ListResponse(count: rData.length, url: url, result: rData);
    }
    return ListResponse(count: 0, url: url, result: []);
  }

  @override
  Future getOne(String url, id,
      {List<Map<String, String>> filters = const []}) async {
    Response res = await dio.get("$url/$id");
    if (res.statusCode == 200) {
      var rData = res.data;
      return rData;
    }
    return null;
  }

  @override
  Future update(String url, id, {Map<String, dynamic> data = const {}}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}

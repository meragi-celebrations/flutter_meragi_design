abstract class MDRepository {
  Future<dynamic> getList(String url,
      {List<Map<String, String>> filters = const [], List<Map<String, String>> sorters = const []});
  Future<dynamic> getOne(String url, dynamic? id, {List<Map<String, String>> filters = const []});
  Future<dynamic> create(String url, {Map<String, dynamic> data = const {}, Map<String, dynamic> files = const {}});
  Future<dynamic> update(String url, dynamic id, {Map<String, dynamic> data = const {}});
  Future<dynamic> delete(String url, dynamic id, {Map<String, dynamic>? params});
  Future<dynamic> custom(dynamic id);
}

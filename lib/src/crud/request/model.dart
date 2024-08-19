class ListResponse<T> {
  ListResponse({
    required this.count,
    required this.url,
    required this.result,
  });

  ListResponse.fromJson(dynamic json, T data) {
    count = json['count'];
    url = json['url'];
    if (json['results'] != null) {
      result = data;
    }
  }
  late num count;
  late String url;
  late T result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;
    map['url'] = url;
    map['results'] = result;
    return map;
  }
}

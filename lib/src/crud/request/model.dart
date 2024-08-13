class PaginatedResponse<T> {
  PaginatedResponse({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  PaginatedResponse.fromJson(dynamic json, T? data) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = data;
    }
  }
  num? count;
  String? next;
  String? previous;
  T? results;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;
    map['next'] = next;
    map['previous'] = previous;
    // if (results != null) {
    //   map['results'] = results?.map((v) => v.toJson()).toList();
    // }
    return map;
  }
}

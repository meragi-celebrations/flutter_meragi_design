import 'package:flutter/material.dart';

Map<String, dynamic> convertQueryStringToMap(String queryString) {
  Map<String, dynamic> result = {};

  List<String> queryParameters = queryString.split('&');

//   print("queryParameters $queryParameters");

  Map<String, dynamic> sorters = {};
  Map<String, dynamic> filters = {};

  for (String parameter in queryParameters) {
    List<String> keyValue = parameter.split('=');
    String key = keyValue[0];
    String value = Uri.decodeComponent(keyValue[1]);

    print("======> Value : $value");

    if (key.contains('sorter')) {
      sorters[key] = value;
    } else if (key.contains('filters')) {
      filters[key] = value;
    } else {
      result[key] = value;
    }
  }

//   print("result $result ");
//   print("sorter $sorters");
//   print("filter $filters ");
  List<Map<String, String>> resultSorter = mapFiltersAndSorters(sorters);
  List<Map<String, String>> resultFilter = mapFiltersAndSorters(filters);

  result['sorter'] = resultSorter;
  result['filters'] = resultFilter;

  debugPrint("sorter $resultSorter");
  debugPrint("filter $resultFilter ");
  return result;
}

List<Map<String, String>> mapFiltersAndSorters(Map<String, dynamic> sorters) {
  int sorterIndex = 0;
  Map<String, String> tempSorterData = {};
  List<Map<String, String>> resultSorter = [];

  for (MapEntry<String, dynamic> sorter in sorters.entries) {
    String key = sorter.key;
    var value = sorter.value;
    int startIndex = key.lastIndexOf('[');
    int endIndex = key.lastIndexOf(']');
    String mapKey = key.substring(startIndex + 1, endIndex);

    startIndex = key.indexOf('[');
    int newIndex = int.parse(key.substring(startIndex + 1, key.indexOf(']')));
    if (newIndex == sorterIndex) {
      tempSorterData[mapKey] = value;
    } else {
      sorterIndex = newIndex;
      resultSorter.add(tempSorterData);
      tempSorterData = {};
      tempSorterData[mapKey] = value;
    }
  }

  resultSorter.add(tempSorterData);
  return resultSorter;
}

String parseInputToQueryString(Map<String, dynamic> input) {
  List<String> queryParams = [];

  // Parse sorters
  if (input.containsKey('sorters')) {
    List<dynamic> sorters = input['sorters'];
    for (int i = 0; i < sorters.length; i++) {
      String field = sorters[i]['field'];
      String order = sorters[i]['order'];
      String ordering = order.toLowerCase() == 'desc' ? '-$field' : '+$field';
      queryParams.add('ordering=$ordering');
    }
  }

  // Parse other parameters
  List<String> otherParams = ['page=${input['current'] ?? 1}', 'page_size=${input['pageSize'] ?? 25}'];

  List<dynamic> filters = input['filters'];
  for (int i = 0; i < filters.length; i++) {
    String field = filters[i]['field'];
    late String operator;

    switch (filters[i]['operator']) {
      case 'in':
      case 'ne':
      case 'eq':
      case 'gte':
      case 'lte':
        operator = '__${filters[i]['operator']}';
        break;
      case 'between':
        operator = '__range';
        break;
      case 'contains':
        operator = '__icontains';
        break;
      default:
        operator = "";
    }
    String value = filters[i]['value'];
    otherParams.add("${filters[i]['field']}$operator=$value");
  }

  // Concatenate all parameters
  queryParams.addAll(otherParams);

  return queryParams.join('&');
}

Map<String, String> parseSorterListToMap(List<Map<String, String>> query) {
  Map<String, String> result = {};
  String value = "";
  for (int i = 0; i < query.length; i++) {
    String field = query[i]['field'] ?? "";
    String order = query[i]['order'] ?? "";
    if (value.isEmpty) {
      value = order.toLowerCase() == 'desc' ? '-$field' : field;
    } else {
      value = "$value,${order.toLowerCase() == 'desc' ? '-$field' : field}";
    }
  }
  result['ordering'] = value;
  return result;
}

Map<String, String> parseFilterListToMap(List<Map<String, String>> filters) {
  Map<String, String> result = {};
  for (int i = 0; i < filters.length; i++) {
    late String operator;
    switch (filters[i]['operator']) {
      case 'in':
      case 'ne':
      // case 'eq':
      case 'gte':
      case 'lte':
        operator = '__${filters[i]['operator']}';
        break;
      case 'between':
        operator = '__range';
        break;
      case 'contains':
        operator = '__icontains';
        break;
      default:
        operator = "";
    }
    String value = filters[i]['value'] ?? "";
    result['${filters[i]['field']}$operator'] = value;
  }
  return result;
}

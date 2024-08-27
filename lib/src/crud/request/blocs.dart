import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/crud/request/cache.dart';
import 'package:flutter_meragi_design/src/crud/request/enums.dart';
import 'package:flutter_meragi_design/src/crud/request/model.dart';
import 'package:flutter_meragi_design/src/crud/request/repo.dart';
import 'package:flutter_meragi_design/src/utils/property_notifier.dart';
import 'package:flutter_meragi_design/src/utils/qs.dart';

abstract class BaseBloc<T> {
  String? url;
  final MDRepository repo;
  final T Function(dynamic json) fromJson;

  Function(dynamic data)? onSuccess;
  Function(Object error)? onError;
  VoidCallback? onSettled;

  BaseBloc({
    required this.repo,
    required this.fromJson,
    this.url,
    this.onSuccess,
    this.onError,
    this.onSettled,
  });
}

class GetListBloc<T> extends BaseBloc<T> {
  GetListBloc({
    required super.url,
    required super.repo,
    required super.fromJson,
    this.isInfinite = false,
    super.onSuccess,
    super.onError,
    super.onSettled,
  });

  //#region -List
  PropertyNotifier<ListResponse<List<T>>?> pageResponse = PropertyNotifier(null);
  PropertyNotifier<List<T>> list = PropertyNotifier([]);
  ValueNotifier<RequestState> requestState = PropertyNotifier(RequestState.done);
  ValueNotifier<int> currentPage = ValueNotifier(1);
  ValueNotifier<int> totalPages = ValueNotifier(1);
  ValueNotifier<int> totalCount = ValueNotifier(0);
  ValueNotifier<int> pageSize = ValueNotifier(20);
  ValueNotifier<bool> isPaginationEnabled = ValueNotifier(true);
  List<Map<String, String>> customFilters = [];
  List<Map<String, String>> customSorters = [];

  final bool isInfinite;

  RequestCache cache = RequestCache();

  addFilters(List<Map<String, String>> newFilters, {ListFilterAddType type = ListFilterAddType.append}) {
    if (type == ListFilterAddType.reset) {
      customFilters = [];
    }
    customFilters.addAll(newFilters);
  }

  removeFilter(int index) {
    customFilters.removeAt(index);
  }

  addSorter(Map<String, String> newSorter) {
    customSorters.add(newSorter);
  }

  removeSorter(int index) {
    customSorters.removeAt(index);
  }

  String getKey(List<Map<String, String>> filters, List<Map<String, String>> sorters) {
    Map<String, String> data = {};
    if (sorters.isNotEmpty) {
      data.addAll(parseSorterListToMap(sorters));
    }
    if (filters.isNotEmpty) {
      data.addAll(parseFilterListToMap(filters));
    }
    return url! + Uri(queryParameters: data).query;
  }

  get() async {
    try {
      List<Map<String, String>> filters = [];
      List<Map<String, String>> sorters = [];
      if (isPaginationEnabled.value) {
        filters.add({
          "field": "page",
          "operator": "eq",
          "value": "${currentPage.value}",
        });
        filters.add({
          "field": "page_size",
          "operator": "eq",
          "value": "${pageSize.value}",
        });
      }

      filters.addAll(customFilters);

      sorters.addAll(customSorters);

      var key = getKey(filters, sorters);

      var cachedResponse = cache.get(key);

      if (cachedResponse == null) {
        if (isInfinite) {
          requestState.value = currentPage.value > 1 ? RequestState.paginating : RequestState.loading;
        } else {
          requestState.value = RequestState.loading;
        }
      } else {
        requestState.value = RequestState.fetching;
        ListResponse cacheResponseInList = ListResponse.fromJson(cachedResponse, cachedResponse["results"]);
        this.handleResponse(cacheResponseInList, cached: true);
        list.notifyListeners();
      }

      ListResponse res = await repo.getList(url!, filters: filters, sorters: sorters);

      cache.put(key, res.toJson());

      this.handleResponse(res);
      list.notifyListeners();

      onSuccess?.call(list.value);

      requestState.value = RequestState.done;
    } catch (e, s) {
      debugPrint("$e");
      debugPrintStack(stackTrace: s);
      onError?.call(e);
      requestState.value = RequestState.error;
    } finally {
      onSettled?.call();
    }
  }

  Map<String, Map<String, int>> urlCallQueue = {};

  void handleResponse(ListResponse response, {bool cached = false}) {
    if (isPaginationEnabled.value) {
      List<T> listData = List.from(((response.result ?? []) as List).map((e) => fromJson(e)));
      pageResponse.value = ListResponse.fromJson(response.toJson(), listData);
      debugPrint("pageResponse ${pageResponse.value?.count} ${pageResponse.value?.url}");
      if (isInfinite) {
        //if result is cached then we need to remove previous results, if not then we need to remove last page results
        if (cached) {
          urlCallQueue[response.url] = {
            "startIndex": list.value.length,
            "endIndex": list.value.length + listData.length,
          };

          list.value.addAll(listData);
        } else {
          Map<String, int>? urlQueueData = urlCallQueue[response.url];
          if (urlQueueData != null) {
            list.value.removeRange(urlQueueData['startIndex']!, urlQueueData['endIndex']!);
            list.value.addAll(listData);
            urlCallQueue.remove(response.url);
          } else {
            list.value.addAll(listData);
          }
        }
      } else {
        list.value = listData;
      }
      totalPages.value = ((pageResponse.value?.count ?? 0) / pageSize.value).ceil();
      totalCount.value = pageResponse.value?.count.toInt() ?? 0;
    } else {
      list.value = List.from(((response.result ?? []) as List).map((e) => fromJson(e)));
    }
  }

  updatePageSize(int newPageSize) {
    pageSize.value = newPageSize;
  }

  nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
    }
    get();
  }

  previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
    get();
  }

  goToPage(int page) {
    if (page > totalPages.value) {
      return;
    }
    currentPage.value = page;
    get();
  }

  onPageSizeChanged(int value) {
    pageSize.value = value;
    currentPage.value = 1;
    get();
  }

  togglePagination(bool value) {
    isPaginationEnabled.value = value;
  }

  reset() {
    currentPage.value = 1;
    totalPages.value = 1;
    list.value.clear();
    list.notifyListeners();
    get();
  }
}

class GetOneBloc<T> extends BaseBloc<T> {
  GetOneBloc({
    required super.url,
    required super.repo,
    required super.fromJson,
    super.onSuccess,
    super.onError,
    super.onSettled,
    String? itemId,
  }) {
    if (itemId != null) {
      id.value = itemId;
    }
  }

  ValueNotifier<RequestState> requestState = PropertyNotifier(RequestState.done);
  ValueNotifier<T?> response = ValueNotifier(null);
  List<Map<String, String>> customFilters = [];

  ValueNotifier<String?> id = ValueNotifier(null);

  RequestCache cache = RequestCache();

  addFilters(List<Map<String, String>> newFilters, {ListFilterAddType type = ListFilterAddType.append}) {
    if (type == ListFilterAddType.reset) {
      customFilters = [];
    }
    customFilters.addAll(newFilters);
  }

  removeFilter(int index) {
    customFilters.removeAt(index);
  }

  String getKey(String url, List<Map<String, String>> filters) {
    Map<String, String> data = {};
    if (filters.isNotEmpty) {
      data.addAll(parseFilterListToMap(filters));
    }
    return url + Uri(queryParameters: data).query;
  }

  get({String? customUrl}) async {
    try {
      String key = getKey(customUrl ?? "$url${id.value}", customFilters);

      var cachedResponse = cache.get(key);

      if (cachedResponse == null) {
        requestState.value = RequestState.loading;
      } else {
        requestState.value = RequestState.fetching;
        handleResponse(cachedResponse);
      }
      dynamic res;
      if (customUrl != null) {
        res = await repo.custom(customUrl, filters: customFilters);
      } else {
        res = await repo.getOne(url!, id.value, filters: customFilters);
      }

      cache.put(key, res);
      handleResponse(res);
      onSuccess?.call(response.value);
      requestState.value = RequestState.done;
    } catch (e, s) {
      debugPrint("$e");
      debugPrintStack(stackTrace: s);
      onError?.call(e);
    } finally {
      onSettled?.call();
    }
  }

  handleResponse(res) {
    response.value = fromJson(res);
  }
}

class CreateBloc<T> extends BaseBloc<T> {
  CreateBloc({
    required super.repo,
    required super.fromJson,
    super.url,
    super.onSuccess,
    super.onError,
    super.onSettled,
  });

  ValueNotifier<RequestState> requestState = PropertyNotifier(RequestState.done);
  ValueNotifier<T?> response = ValueNotifier(null);

  mutate(Map<String, dynamic> data, {Map<String, dynamic> dataFiles = const {}, String? url}) async {
    String finalUrl = url ?? this.url ?? "";
    try {
      requestState.value = RequestState.loading;
      var res = await repo.create(finalUrl, data: data, files: dataFiles);

      response.value = fromJson(res) as T?;
      onSuccess?.call(response.value);
      requestState.value = RequestState.done;
    } catch (e, s) {
      debugPrint("$e");
      debugPrintStack(stackTrace: s);
      onError?.call(e);
      requestState.value = RequestState.error;
    } finally {
      onSettled?.call();
    }
  }
}

class UpdateBloc<T> extends BaseBloc<T> {
  UpdateBloc({
    required super.repo,
    required super.fromJson,
    super.url,
    super.onSuccess,
    super.onError,
    super.onSettled,
  });

  ValueNotifier<RequestState> requestState = PropertyNotifier(RequestState.done);
  ValueNotifier<T?> response = ValueNotifier(null);

  RequestCache cache = RequestCache();

  mutate(dynamic id, Map<String, dynamic> data, {String? url}) async {
    String finalUrl = url ?? this.url ?? "";
    try {
      requestState.value = RequestState.loading;
      var res = await repo.update(finalUrl, id, data: data);
      response.value = fromJson(res);
      onSuccess?.call(response.value);
      requestState.value = RequestState.done;
    } catch (e, s) {
      debugPrint("$e");
      debugPrintStack(stackTrace: s);
      onError?.call(e);
      requestState.value = RequestState.error;
    } finally {
      onSettled?.call();

      // Request is successful, remove from cache
      // so it get updated in next fetch
      String key = "$finalUrl$id";
      cache.delete(key);
    }
  }
}

class DeleteBloc<T> extends BaseBloc<T> {
  DeleteBloc({
    required super.repo,
    required super.fromJson,
    super.url,
    super.onSuccess,
    super.onError,
    super.onSettled,
  });

  ValueNotifier<RequestState> requestState = PropertyNotifier(RequestState.done);
  ValueNotifier<T?> response = ValueNotifier(null);

  RequestCache cache = RequestCache();

  mutate(dynamic id, {String? url}) async {
    String finalUrl = url ?? this.url ?? "";
    try {
      requestState.value = RequestState.loading;
      await repo.delete(finalUrl, id);
      onSuccess?.call(response.value);
      requestState.value = RequestState.done;
    } catch (e, s) {
      debugPrint("$e");
      debugPrintStack(stackTrace: s);
      onError?.call(e);
      requestState.value = RequestState.error;
    } finally {
      onSettled?.call();
      String key = "$finalUrl$id";
      cache.delete(key);
    }
  }
}

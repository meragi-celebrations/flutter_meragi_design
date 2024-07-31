import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/crud/request/cache.dart';
import 'package:flutter_meragi_design/src/crud/request/enums.dart';
import 'package:flutter_meragi_design/src/crud/request/model.dart';
import 'package:flutter_meragi_design/src/crud/request/repo.dart';
import 'package:flutter_meragi_design/src/utils/property_notifier.dart';

enum MessageTypeEnum { success, error, info, warning }

class MessageType {
  final String message;
  final MessageTypeEnum type;
  final dynamic data;

  const MessageType(this.message, this.type, this.data);

  const MessageType.success(String message, {dynamic data})
      : this(message, MessageTypeEnum.success, data);

  const MessageType.error(String message, {dynamic data})
      : this(message, MessageTypeEnum.error, data);

  const MessageType.info(String message, {dynamic data})
      : this(message, MessageTypeEnum.info, data);

  const MessageType.warning(String message, {dynamic data})
      : this(message, MessageTypeEnum.warning, data);
}

abstract class BaseBloc<T extends CRUDModel> {
  final String url;
  final CRUDRepository repo;
  final T Function(dynamic json) fromJson;

  Function(dynamic data)? onSuccess;
  Function(Object error)? onError;
  VoidCallback? onSettled;

  StreamController<MessageType>? msgController;

  void showMessage(MessageType message) {
    msgController?.sink.add(message);
  }

  void dispose() {
    msgController?.close();
  }

  BaseBloc({
    required this.url,
    required this.repo,
    required this.fromJson,
    this.onSuccess,
    this.onError,
    this.onSettled,
    this.msgController,
  }) {
    msgController ??= StreamController.broadcast();
  }
}

class GetListBloc<T extends CRUDModel> extends BaseBloc<T> {
  GetListBloc({
    required super.url,
    required super.repo,
    required super.fromJson,
    super.onSuccess,
    super.onError,
    super.onSettled,
    super.msgController,
  });

  //#region -List
  PropertyNotifier<PaginatedResponse<List<T>>?> pageResponse =
      PropertyNotifier(null);
  PropertyNotifier<List<T>> list = PropertyNotifier([]);
  ValueNotifier<RequestState> requestState =
      PropertyNotifier(RequestState.done);
  ValueNotifier<int> currentPage = ValueNotifier(1);
  ValueNotifier<int> totalPages = ValueNotifier(1);
  ValueNotifier<int> totalCount = ValueNotifier(0);
  ValueNotifier<int> pageSize = ValueNotifier(20);
  ValueNotifier<bool> isPaginationEnabled = ValueNotifier(true);
  List<Map<String, String>> customFilters = [];
  List<Map<String, String>> customSorters = [];

  RequestCache cache = RequestCache();

  addFilters(List<Map<String, String>> newFilters,
      {ListFilterAddType type = ListFilterAddType.append}) {
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

  String getKey(
      List<Map<String, String>> filters, List<Map<String, String>> sorters) {
    return url + json.encode(filters) + json.encode(sorters);
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
        requestState.value = RequestState.loading;
      } else {
        requestState.value = RequestState.fetching;

        this.handleResponse(cachedResponse);
        list.notifyListeners();
      }

      var res = await repo.getList(url, filters: filters, sorters: sorters);

      cache.put(key, res);

      this.handleResponse(res);
      list.notifyListeners();

      onSuccess?.call(list.value);

      showMessage(MessageType.success("", data: list.value));

      requestState.value = RequestState.done;
    } catch (e, s) {
      debugPrint("$e");
      debugPrintStack(stackTrace: s);
      onError?.call(e);
      showMessage(MessageType.error("", data: e));
      requestState.value = RequestState.error;
    } finally {
      onSettled?.call();
    }
  }

  void handleResponse(response) {
    if (isPaginationEnabled.value) {
      List<T> listData = List.from(
          ((response['results'] ?? []) as List).map((e) => fromJson(e)));
      pageResponse.value = PaginatedResponse.fromJson(response, listData);
      list.value = listData;
      totalPages.value =
          ((pageResponse.value?.count ?? 0) / pageSize.value).ceil();
      totalCount.value = pageResponse.value?.count?.toInt() ?? 0;
    } else {
      list.value =
          List.from(((response ?? []) as List).map((e) => fromJson(e)));
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
}

class GetOneBloc<T extends CRUDModel> extends BaseBloc<T> {
  GetOneBloc({
    required super.url,
    required super.repo,
    required super.fromJson,
    super.onSuccess,
    super.onError,
    super.onSettled,
    super.msgController,
    String? itemId,
  }) {
    if (itemId != null) {
      id.value = itemId;
    }
  }

  ValueNotifier<RequestState> requestState =
      PropertyNotifier(RequestState.done);
  ValueNotifier<T?> response = ValueNotifier(null);
  List<Map<String, String>> customFilters = [];

  ValueNotifier<String?> id = ValueNotifier(null);

  RequestCache cache = RequestCache();

  addFilters(List<Map<String, String>> newFilters,
      {ListFilterAddType type = ListFilterAddType.append}) {
    if (type == ListFilterAddType.reset) {
      customFilters = [];
    }
    customFilters.addAll(newFilters);
  }

  removeFilter(int index) {
    customFilters.removeAt(index);
  }

  get() async {
    try {
      String key = "$url${id.value}${json.encode(customFilters)}";

      var cachedResponse = cache.get(key);

      if (cachedResponse == null) {
        requestState.value = RequestState.loading;
      } else {
        requestState.value = RequestState.fetching;
        handleResponse(cachedResponse);
      }
      var res = await repo.getOne(url, id.value, filters: customFilters);
      cache.put(key, res);
      handleResponse(res);
      onSuccess?.call(response.value);
      showMessage(MessageType.success("", data: response.value));
      requestState.value = RequestState.done;
    } catch (e, s) {
      debugPrint("$e");
      debugPrintStack(stackTrace: s);
      onError?.call(e);
      showMessage(MessageType.error("", data: e));
    } finally {
      onSettled?.call();
    }
  }

  handleResponse(res) {
    response.value = fromJson(res);
  }
}

class CreateBloc<T extends CRUDModel> extends BaseBloc<T> {
  CreateBloc({
    required super.url,
    required super.repo,
    required super.fromJson,
    super.onSuccess,
    super.onError,
    super.onSettled,
    super.msgController,
  });

  ValueNotifier<RequestState> requestState =
      PropertyNotifier(RequestState.done);
  ValueNotifier<T?> response = ValueNotifier(null);

  mutate(Map<String, dynamic> data,
      {Map<String, dynamic> dataFiles = const {}}) async {
    try {
      requestState.value = RequestState.loading;
      var res = await repo.create(url, data: data, files: dataFiles);

      response.value = fromJson(res) as T?;
      onSuccess?.call(response.value);
      showMessage(MessageType.success("", data: response.value));
      requestState.value = RequestState.done;
    } catch (e, s) {
      debugPrint("$e");
      debugPrintStack(stackTrace: s);
      onError?.call(e);
      showMessage(MessageType.error("", data: e));
      requestState.value = RequestState.error;
    } finally {
      onSettled?.call();
    }
  }
}

class UpdateBloc<T extends CRUDModel> extends BaseBloc<T> {
  UpdateBloc({
    required super.url,
    required super.repo,
    required super.fromJson,
    super.onSuccess,
    super.onError,
    super.onSettled,
    super.msgController,
  });

  ValueNotifier<RequestState> requestState =
      PropertyNotifier(RequestState.done);
  ValueNotifier<T?> response = ValueNotifier(null);

  RequestCache cache = RequestCache();

  mutate(dynamic id, Map<String, dynamic> data) async {
    try {
      requestState.value = RequestState.loading;
      var res = await repo.update(url, id, data: data);
      response.value = fromJson(res);
      onSuccess?.call(response.value);
      showMessage(MessageType.success("", data: response.value));
      requestState.value = RequestState.done;
    } catch (e, s) {
      debugPrint("$e");
      debugPrintStack(stackTrace: s);
      onError?.call(e);
      showMessage(MessageType.error("", data: e));
      requestState.value = RequestState.error;
    } finally {
      onSettled?.call();

      // Request is successful, remove from cache
      // so it get updated in next fetch
      String key = "$url$id";
      cache.delete(key);
    }
  }
}

class DeleteBloc<T extends CRUDModel> extends BaseBloc<T> {
  DeleteBloc({
    required super.url,
    required super.repo,
    required super.fromJson,
    super.onSuccess,
    super.onError,
    super.onSettled,
    super.msgController,
  });

  ValueNotifier<RequestState> requestState =
      PropertyNotifier(RequestState.done);
  ValueNotifier<T?> response = ValueNotifier(null);

  RequestCache cache = RequestCache();

  mutate(dynamic id) async {
    try {
      requestState.value = RequestState.loading;
      await repo.delete(url, id);
      onSuccess?.call(response.value);
      showMessage(MessageType.success("", data: response.value));
      requestState.value = RequestState.done;
    } catch (e, s) {
      debugPrint("$e");
      debugPrintStack(stackTrace: s);
      onError?.call(e);
      showMessage(MessageType.error("", data: e));
      requestState.value = RequestState.error;
    } finally {
      onSettled?.call();
      String key = "$url$id";
      cache.delete(key);
    }
  }
}

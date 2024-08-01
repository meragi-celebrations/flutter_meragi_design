import 'package:example/crud/repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class TodoModel extends CRUDModel {
  int? userId;
  int? id;
  String? title;
  bool? completed;

  TodoModel({this.userId, this.id, this.title, this.completed});

  @override
  TodoModel.buildFromJson(dynamic json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    completed = json['completed'];
  }

  @override
  Map<String, dynamic> toJson() {
    final dynamic data = {};
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    data['completed'] = completed;
    return data;
  }

  @override
  TodoModel fromJson(json) {
    return TodoModel.buildFromJson(json);
  }

  static TodoModel staticFromJson(json) {
    return TodoModel.buildFromJson(json);
  }
}

class CrudMain extends StatefulWidget {
  const CrudMain({super.key});

  @override
  State<CrudMain> createState() => _CrudMainState();
}

class _CrudMainState extends State<CrudMain> {
  late final GetListBloc<TodoModel> getListBloc;
  late final GetOneBloc<TodoModel> getOneBloc;

  @override
  void initState() {
    getOneBloc = GetOneBloc<TodoModel>(
      url: "https://jsonplaceholder.typicode.com/todos/",
      repo: ExampleRepo(),
      fromJson: TodoModel.staticFromJson,
      itemId: "1",
    );

    getListBloc = GetListBloc<TodoModel>(
      url: "https://jsonplaceholder.typicode.com/todos/",
      repo: ExampleRepo(),
      fromJson: TodoModel.staticFromJson,
    );
    getListBloc.isPaginationEnabled.value = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getListBloc.onSuccess = (data) {
      print("On Success called, and has context");
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD Main"),
      ),
      body: Column(
        children: [
          const Text("Get One"),
          Button(
            type: ButtonType.primary,
            onTap: () {
              getOneBloc.get();
            },
            child: const Text("Fetch"),
          ),
          Column(
            children: [
              Row(
                children: [
                  const Text("Request state"),
                  const SizedBox(width: 10),
                  ValueListenableBuilder(
                    valueListenable: getOneBloc.requestState,
                    builder: (context, value, child) {
                      return Text(getOneBloc.requestState.value.toString());
                    },
                  )
                ],
              ),
              ValueListenableBuilder(
                valueListenable: getOneBloc.response,
                builder: (context, value, child) {
                  return Text(value?.title ?? "No response");
                },
              ),
            ],
          ),
          const Text("Get List"),
          Button(
            type: ButtonType.primary,
            onTap: () {
              getListBloc.get();
            },
            child: const Text("Fetch"),
          ),
          Row(
            children: [
              const Text("Request state"),
              const SizedBox(width: 10),
              ValueListenableBuilder(
                  valueListenable: getListBloc.requestState,
                  builder: (context, value, child) {
                    return Text(getListBloc.requestState.value.toString());
                  }),
              const SizedBox(width: 10),
              const Text("List Length: "),
              ValueListenableBuilder(
                valueListenable: getListBloc.list,
                builder: (context, value, child) {
                  return Text(value.length.toString());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

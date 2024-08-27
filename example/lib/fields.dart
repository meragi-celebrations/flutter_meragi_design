import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class FieldDetails extends StatefulWidget {
  const FieldDetails({super.key});

  @override
  State<FieldDetails> createState() => _FieldDetailsState();
}

class _FieldDetailsState extends State<FieldDetails> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fields"),
      ),
      body: FormBuilder(
        key: _formKey,
        onChanged: () {
          _formKey.currentState!.save();
          debugPrint(_formKey.currentState!.value.toString());
        },
        child: Column(
          children: [
            MDFormItem(
              label: Text("Name"),
              isGrid: true,
              child: MDTextField(
                name: "name",
                isClearable: true,
                validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required()]),
                errorBuilder: (error) {
                  return Text("This is error");
                },
              ),
            ),
            MDFormItem(
              label: Text("Name2"),
              isGrid: true,
              child: MDTextField(
                name: "name1",
                validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required()]),
                errorBuilder: (error) {
                  return Text("This is error");
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: MDFormItem(
                    label: Text("Dropdown 1"),
                    // isGrid: true,
                    labelPosition: Axis.horizontal,
                    child: MDDropdown(
                      name: "dropdown",
                      isClearable: true,
                      initialValue: "b",
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: const ["a", "b", "c"].map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: MDFormItem(
                    label: Text("dropdown 2"),
                    // isGrid: true,
                    labelPosition: Axis.horizontal,
                    child: MDDropdown(
                      name: "dropdown2",
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: const [
                        "a",
                        "b",
                        "c",
                        "d",
                        "e",
                        "f",
                        "g",
                        "h",
                        "i",
                        "j",
                        "k",
                        "l",
                        "m",
                        "n",
                        "o",
                        "p",
                        "q",
                        "r",
                        "s",
                        "t",
                        "u",
                        "v",
                        "w",
                        "x",
                        "y",
                        "z"
                      ].map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            MDFormItem(
              label: Text("Switch"),
              isGrid: true,
              child: MDSwitch(
                name: "switch",
                validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required()]),
              ),
            ),
            Button(
                onTap: () {
                  _formKey.currentState!.validate();
                },
                child: const Text("Submit")),
          ],
        ),
      ),
    );
  }
}

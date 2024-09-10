import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class ButtonsDetails extends StatefulWidget {
  const ButtonsDetails({super.key});

  @override
  State<ButtonsDetails> createState() => _ButtonsDetailsState();
}

class _ButtonsDetailsState extends State<ButtonsDetails> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      appBar: const MDAppBar(
        title: Text("Buttons"),
      ),
      body: ListView.builder(
        itemCount: ButtonVariant.values.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          ButtonVariant variant = ButtonVariant.values[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${variant.name}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              ...ButtonType.values.map((type) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ...ButtonSize.values.map(
                          (size) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              children: [
                                Button(
                                  decoration: ButtonDecoration(
                                    context: context,
                                    variant: variant,
                                    type: type,
                                    size: size,
                                  ),
                                  onTap: () {},
                                  icon: Icons.filter,
                                  child: Text(type.name),
                                ),
                                const SizedBox(height: 10),
                                Button.dropdown(
                                  decoration: ButtonDecoration(
                                    context: context,
                                    variant: variant,
                                    type: type,
                                    size: size,
                                  ),
                                  onTap: () {},
                                  icon: Icons.filter,
                                  menuChildren: [
                                    Button(
                                      decoration: ButtonDecoration(
                                        context: context,
                                        variant: variant,
                                        type: type,
                                        size: size,
                                      ),
                                      onTap: () {},
                                      icon: Icons.filter,
                                      child: Text(type.name),
                                    )
                                  ],
                                  builder: (context, controller, child) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (!controller.isOpen) {
                                          controller.open();
                                        } else {
                                          controller.close();
                                        }
                                      },
                                      child: const Icon(Icons.add),
                                    );
                                  },
                                  child: Text(type.name),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: isLoading,
                          builder: (context, value, _) {
                            return Column(
                              children: [
                                Button(
                                  decoration: ButtonDecoration(
                                    context: context,
                                    variant: variant,
                                    type: type,
                                  ),
                                  onTap: () {
                                    isLoading.value = !value;
                                  },
                                  isLoading: value,
                                  icon: Icons.filter,
                                  child: const Text("Loading (click)"),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Button.dropdown(
                                  builder: (context, controller, child) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (!controller.isOpen) {
                                          controller.open();
                                        } else {
                                          controller.close();
                                        }
                                      },
                                      child: const Icon(Icons.add),
                                    );
                                  },
                                  menuChildren: const [],
                                  decoration: ButtonDecoration(
                                    context: context,
                                    variant: variant,
                                    type: type,
                                  ),
                                  onTap: () {
                                    isLoading.value = !value;
                                  },
                                  isLoading: value,
                                  loadingWidget:
                                      const CircularProgressIndicator(),
                                  child: const Text(
                                      "Loading custom indicator (click)"),
                                ),
                                Button(
                                  decoration: ButtonDecoration(
                                    context: context,
                                    variant: variant,
                                    type: type,
                                    size: ButtonSize.sm,
                                  ),
                                  onTap: () {},
                                  icon: Icons.image,
                                  isLoading: value,
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

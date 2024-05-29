import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class ButtonsDetails extends StatefulWidget {
  const ButtonsDetails({super.key});

  @override
  State<ButtonsDetails> createState() => _ButtonsDetailsState();
}

class _ButtonsDetailsState extends State<ButtonsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  Text("${variant.name}", style: TextStyle(fontSize: 20),),
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
                        ...ButtonSize.values.map((size) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Button(
                            variant: variant,
                            type: type,
                            size: size,
                            onTap: () {},
                            icon: Icons.filter,
                            child: Text(type.name),
                          ),
                        ),),
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

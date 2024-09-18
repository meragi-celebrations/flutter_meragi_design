import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class TypographyDetails extends StatefulWidget {
  const TypographyDetails({super.key});

  @override
  State<TypographyDetails> createState() => _TypographyDetailsState();
}

class _TypographyDetailsState extends State<TypographyDetails> {
  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      appBar: MDAppBar(title: H3(text: "Typography")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DisplayText(text: "Display"),
            H1(
              text: "H1 primary",
              type: TextType.primary,
            ),
            H2(text: "H2"),
            H3(text: "H3"),
            H4(text: "H4"),
            H5(text: "H5"),
            H6(text: "H6"),
            BodyText(
              text: "Body",
              type: TextType.error,
            ),
            LinkText(text: "Link"),
            CaptionText(text: "Caption"),
            CodeText(text: "Code"),
            QuoteText(text: "Quote"),
            H2(
              text: "H2 with custom style",
              style:
                  TextStyle(color: Colors.pink, backgroundColor: Colors.amber),
            ),
            GestureDetector(
              onTap: () {
                print("this was called");
              },
              child: MDNetworkImage(
                src:
                    "https://d1p55htxo8z8mf.cloudfront.net/vendor_profile_image/93ac05bb-356f-4ec3-8603-c141663f3fa6.jpg",
                width: 250,
                // preview: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}

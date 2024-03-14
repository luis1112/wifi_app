import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

class PageTest extends StatefulWidget {
  const PageTest({super.key});

  @override
  State<PageTest> createState() => _PageTestState();
}

class _PageTestState extends State<PageTest> {
  ProviderConnection pvC = ProviderConnection.of();


  @override
  Widget build(BuildContext context) {
    pvC = ProviderConnection.of(context, true);
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 10.0),
            TestPageCustom(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

class PageExternal extends StatefulWidget {
  const PageExternal({super.key});

  @override
  State<PageExternal> createState() => _PageExternalState();
}

class _PageExternalState extends State<PageExternal> {
  ProviderConnection pvC = ProviderConnection.of();

  @override
  Widget build(BuildContext context) {
    pvC = ProviderConnection.of(context, true);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: itemExternalData(pvC.external, pvC.getTypeConnection),
      ),
    );
  }


}

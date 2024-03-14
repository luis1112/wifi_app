import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

class PageConnection extends StatefulWidget {
  const PageConnection({super.key});

  @override
  State<PageConnection> createState() => _PageConnectionState();
}

class _PageConnectionState extends State<PageConnection> {
  ProviderConnection pvC = ProviderConnection.of();

  @override
  Widget build(BuildContext context) {
    pvC = ProviderConnection.of(context, true);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: itemConnection(pvC.connection, pvC.getTypeConnection),
      ),
    );
  }
}

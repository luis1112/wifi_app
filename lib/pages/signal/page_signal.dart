import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

enum TypeChanel { ghz2, ghz5 }

class PageSignal extends StatefulWidget {
  const PageSignal({super.key});

  @override
  State<PageSignal> createState() => _PageSignalState();
}

class _PageSignalState extends State<PageSignal> {
  ProviderConnection pvC = ProviderConnection.of();


  @override
  Widget build(BuildContext context) {
    pvC = ProviderConnection.of(context, true);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: BtnC(
                    title: "2.4 GHZ",
                    isActive: pvC.typeSignal == TypeChanel.ghz2,
                    onTap: () {
                      if (pvC.typeSignal == TypeChanel.ghz2) {
                        pvC.typeSignal = null;
                      } else {
                        pvC.typeSignal = TypeChanel.ghz2;
                      }
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: BtnC(
                    title: "5GHZ",
                    isActive: pvC.typeSignal == TypeChanel.ghz5,
                    onTap: () {
                      if (pvC.typeSignal == TypeChanel.ghz5) {
                        pvC.typeSignal = null;
                      } else {
                        pvC.typeSignal = TypeChanel.ghz5;
                      }
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: BtnC(
                    title: pvC.isActiveNetwork ? "Ocultar" : "Redes",
                    isActive: pvC.isActiveNetwork,
                    onTap: () {
                      pvC.isActiveNetwork = !pvC.isActiveNetwork;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Stack(
              alignment: Alignment.topRight,
              children: [
                AspectRatio(
                  aspectRatio: 0.7,
                  child: itemChartSignal(pvC.listSignal, pvC.limitCount),
                ),
                if (pvC.isActiveNetwork)
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    alignment: Alignment.topRight,
                    child: Card(
                      elevation: 5.0,
                      child: Container(
                        height: 200.0,
                        width: 180.0,
                        padding: const EdgeInsets.all(5.0),
                        child: SingleChildScrollView(
                          child: itemNetworksSignal(pvC.listSignal),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

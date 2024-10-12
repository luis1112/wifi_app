import 'dart:io';
import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wifi/docs.dart';

class PageInform extends StatefulWidget {
  static String route = "PageInform";

  const PageInform({super.key});

  @override
  State<PageInform> createState() => _PageInformState();
}

class _PageInformState extends State<PageInform> {
  ProviderConnection pvC = ProviderConnection.of();
  ProviderTest pvT = ProviderTest.of();
  ScreenshotController sVelocity = ScreenshotController();
  ScreenshotController sChanel = ScreenshotController();
  ScreenshotController sSignal = ScreenshotController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pvC = ProviderConnection.of(context, true);

    return Scaffold(
      body: itemPdf(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BtnC(
        title: "Exportar PDF",
        onTap: () async {
          onLoad(true);
          var args = Tuple8(
            pvC.connection,
            pvC.external,
            sVelocity,
            sChanel,
            sSignal,
            pvC.lineBarsData,
            pvC.listSignal,
            pvT.test,
          );
          // String? path = await compute(getPathPdf, args);
          String? path = await getPathPdf(args);
          if (path != null) {
            await Share.shareXFiles([XFile(path)]);
          } else {
            pvG.showMessage("Ocurrión un problema al generar pdf");
          }
          onLoad(false);
        },
      ),
    );
  }

  Widget itemPdf() {
    return MainPdf(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              itemFrontPage(),
              itemTextTitle("Datos de conexión"),
              itemConnection(pvC.connection, null),
              itemTextTitle("Datos externos"),
              itemExternalData(pvC.external, null),
              itemTextTitle("Gráfica de intensidad"),
              Screenshot(
                controller: sVelocity,
                child: AspectRatio(
                  aspectRatio: 1.9,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: itemChartVelocity(
                        pvC.listPoints, pvC.level, pvC.limitCount),
                  ),
                ),
              ),
              itemTextTitle("Test de velocidad"),
              itemTest(pvT.test),
              itemTextTitle("Gráfica de canales"),
              Screenshot(
                controller: sChanel,
                child: AspectRatio(
                  aspectRatio: 0.9,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 20.0, top: 20.0, left: 20.0),
                    child: LineChart(itemChartChanel(pvC.lineBarsData, pvC.typeChannel)),
                  ),
                ),
              ),
              itemTextTitle("Puntos de red para canales"),
              itemNetworksChanel(pvC.lineBarsData),
              itemTextTitle("Gráfica de señal"),
              Screenshot(
                controller: sSignal,
                child: AspectRatio(
                  aspectRatio: 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: itemChartSignal(pvC.listSignal, pvC.limitCount),
                  ),
                ),
              ),
              itemTextTitle("Puntos de red para señal"),
              itemNetworksSignal(pvC.listSignal),
              const SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemFrontPage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/image/logo_horizontal.png",
            height: 60.0,
          ),
          itemTextTitle("Universidad Nacional de Loja"),
          const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              '"Análisis Estadístico de la Red Wi-Fi: Puntos de Acceso y Conectividad"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          itemTextG("FECHA:", DateFormat("yMd").format(DateTime.now())),
          const Text(
            "LOJA - ECUADOR",
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget itemTextTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

Future<String?> getPathPdf(
    Tuple8<
            ItemConnection,
            ExternalConnection?,
            ScreenshotController,
            ScreenshotController,
            ScreenshotController,
            List<ItemChartChanel>,
            List<ItemChartSignal>,
            ModelTest?>
        args) async {
  ItemConnection connection = args.item1;
  ExternalConnection? redInfo = args.item2;
  ScreenshotController sVelocity = args.item3;
  ScreenshotController sChanel = args.item4;
  ScreenshotController sSignal = args.item5;
  List<ItemChartChanel> lineBarsData = args.item6;
  List<ItemChartSignal> listSignal = args.item7;
  ModelTest? test = args.item8;
  return await generatePDF(connection, redInfo, sVelocity, sChanel, sSignal,
      lineBarsData, listSignal, test);
}

Future<String?> generatePDF(
  ItemConnection connection,
  ExternalConnection? redInfo,
  ScreenshotController sVelocity,
  ScreenshotController sChanel,
  ScreenshotController sSignal,
  List<ItemChartChanel> lineBarsData,
  List<ItemChartSignal> listSignal,
  ModelTest? test,
) async {
  try {
    final pdf = pw.Document();

    var widgetFrontPage = await itemFrontPagePdf();

    pdf.addPage(itemPagePdf(
      [widgetFrontPage],
      mainAxisAlignment: pw.MainAxisAlignment.center,
    ));

    // Create a PDF page
    pdf.addPage(itemPagePdf([
      itemTextTitlePdf("Datos de conexión"),
      itemConnectionPdf(connection),
    ]));
    pdf.addPage(itemPagePdf([
      itemTextTitlePdf("Datos externos"),
      itemExternalDataPdf(redInfo),
    ]));
    var bVelocity = await sVelocity.capture();
    if (bVelocity != null) {
      pdf.addPage(itemPagePdf([
        itemTextTitlePdf("Gráfica de intensidad"),
        itemImagePdf(bVelocity, width: 500.0, height: 600.00),
      ]));
    }
    var bChanel = await sChanel.capture();
    if (test != null) {
      pdf.addPage(itemPagePdf([
        itemTextTitlePdf("Test de velocidad"),
        itemTestPdf(test),
      ]));
    }
    if (bChanel != null) {
      pdf.addPage(itemPagePdf([
        itemTextTitlePdf("Gráfica de señal"),
        itemImagePdf(bChanel),
      ]));
      pdf.addPage(itemPagePdf([
        itemTextTitlePdf("Puntos de red para canales"),
        itemNetworksChanelPdf(lineBarsData),
      ]));
    }
    var bSignal = await sSignal.capture();
    if (bSignal != null) {
      pdf.addPage(itemPagePdf([
        itemTextTitlePdf("Gráfica de señal"),
        itemImagePdf(bSignal),
      ]));
      pdf.addPage(itemPagePdf([
        itemTextTitlePdf("Puntos de red para señal"),
        itemNetworksChanelPdf(lineBarsData),
      ]));
    }

    // Save the PDF document to a file
    final Uint8List bytes = await pdf.save();

    // Get a temporary directory
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    // Write the PDF to a temporary file
    final tempPdf = File('$tempPath/informe_wifi.pdf');
    await tempPdf.writeAsBytes(bytes);

    // Share the PDF file
    return tempPdf.path;
  } catch (er) {
    printC(er);
    return null;
  }
}

class Tuple8<A, B, C, D, E, F, G, H> {
  final A item1;
  final B item2;
  final C item3;
  final D item4;
  final E item5;
  final F item6;
  final G item7;
  final H item8;

  const Tuple8(this.item1, this.item2, this.item3, this.item4, this.item5,
      this.item6, this.item7, this.item8);
}

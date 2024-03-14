import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' as m;

Widget itemTextTitlePdf(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget itemTextGPdf(String? label, String? text) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label ?? "",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          text ?? "",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

Page itemPagePdf(
  List<Widget> list, {
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return Page(
    build: (Context context) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: list,
      );
    },
  );
}

Widget itemImagePdf(
  Uint8List imageBytes, {
  double width = 600.0,
  double height = 500.0,
}) {
  return Image(
    MemoryImage(imageBytes),
    width: width,
    height: height,
  );
}

Future<Widget> itemAssetsImagePdf(
  String asset, {
  double width = 600.0,
  double height = 500.0,
}) async {
  var imageBytes = await loadImageFromAssets(asset);
  return itemImagePdf(imageBytes, height: height, width: width);
}

Future<Uint8List> loadImageFromAssets(String ruta) async {
  final ByteData data = await rootBundle.load(ruta);
  return data.buffer.asUint8List();
}

PdfColor colorPdf(m.Color color) {
  return PdfColor.fromInt(
    (color.alpha << 24) | (color.red << 16) | (color.green << 8) | color.blue,
  );
}

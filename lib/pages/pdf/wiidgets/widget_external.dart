import 'package:pdf/widgets.dart';
import 'package:wifi/docs.dart';

Widget itemExternalDataPdf(ExternalConnection? redInfo) {
  ConnectionRedInfo? connection = redInfo?.connection;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      itemTextGPdf("IP Pública:", DeviceInfo.ipPublic),
      itemTextGPdf("ISP:", connection?.isp ?? "---"),
      itemTextGPdf("Dominio:", connection?.domain ?? "---"),
      itemTextGPdf("ASN:", connection?.asn.toString() ?? "---"),
      Divider(),
      itemTextGPdf(
        "Continente:",
        "${redInfo?.continent ?? "---"} "
            "(${redInfo?.continentCode ?? "---"})",
      ),
      itemTextGPdf(
        "País:",
        "${redInfo?.country ?? "---"} "
            "(${redInfo?.countryCode ?? "---"})",
      ),
      itemTextGPdf("Capital:", redInfo?.capital ?? "---"),
      itemTextGPdf("Ciudad:", redInfo?.city ?? "---"),
      itemTextGPdf(
        "Región:",
        "${redInfo?.region ?? "---"} "
            "(${redInfo?.regionCode ?? "---"})",
      ),
      itemTextGPdf("Latitud:", redInfo?.latitude.toString() ?? "---"),
      itemTextGPdf("Longitud:", redInfo?.longitude.toString() ?? "---"),
    ],
  );
}


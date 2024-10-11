import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

Widget itemConnection(ItemConnection? c, String? getTypeConnection) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      if (getTypeConnection != null) ...{
        itemTextG("Tipo de conexión:", getTypeConnection),
        const DividerC(),
      },
      itemTextG("SSID:", c?.ssid),
      itemTextG("MAC:", c?.bssid),
      itemTextG("Rssi:", "${c?.signal} dBm"),
      itemTextG("Banda de frecuencia:", c?.freq),
      itemTextG("Ancho de banda:", c?.chanelWidth),
      itemTextG("Canal:", c?.chanel.toString()),
      const DividerC(),
      itemTextG("Latitud:", c?.latitude),
      itemTextG("Longitud:", c?.longitude),
      const DividerC(),
      itemTextG("Dirección IP:", c?.ipV4),
      itemTextG("Dirección IPV6:", c?.ipV6),
      itemTextG("Gateway:", c?.gateway),
      itemTextG("Broadcast:", c?.broadcast),
      itemTextG("Máscara de red:", c?.submask),
      const DividerC(),
      itemTextG("Fabricante de access point:", c?.brandRouter),
      itemTextG("Distancia aproximada al access point:", c?.distance),
    ],
  );
}

Widget itemTextG(String? label, String? text) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10.0),
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        Text(
          label ?? "",
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 5.0),
        Text(
          text ?? "",
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}

class DividerC extends StatelessWidget {
  const DividerC({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 1, color: Theme
        .of(context)
        .primaryColor);
  }
}

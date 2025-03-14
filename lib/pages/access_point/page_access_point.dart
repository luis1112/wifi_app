import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

class PageAccessPoint extends StatefulWidget {
  const PageAccessPoint({super.key});

  @override
  State<PageAccessPoint> createState() => _PageAccessPointState();
}

class _PageAccessPointState extends State<PageAccessPoint> {
  ProviderConnection pvC = ProviderConnection.of();

  @override
  Widget build(BuildContext context) {
    pvC = ProviderConnection.of(context, true);
    return Scaffold(
      body: ListView.builder(
        itemCount: pvC.accessPoints.length,
        padding: const EdgeInsets.all(20.0).copyWith(bottom: 80.0),
        itemBuilder: (_, i) {
          var e = pvC.accessPoints[i];
          var title = e.ssid.trim().isNotEmpty ? e.ssid : "-------";
          var signalIcon = e.level >= -80
              ? Icons.signal_wifi_4_bar
              : Icons.signal_wifi_0_bar;
          // var channelWidth = (e.channelWidth?.name ?? "").replaceAll("mhz", "");
          // print(item.venueName);

          return ListTile(
            leading: Column(
              children: [
                Icon(signalIcon),
                Text("${e.level}dBm"),
              ],
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(e.bssid),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("CH ${e.chanel}"),
                Text("${(e.frequency / 1000).toStringAsFixed(4)}GHz"),
              ],
            ),
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildInfo("BSSDI", e.bssid),
                    _buildInfo("Capability", e.capabilities),
                    _buildInfo("Frequency", "${e.frequency / 1000}GHz"),
                    _buildInfo("Level", e.level),
                    _buildInfo("CenterFrequency0",
                        "${e.centerFrequency0}GHz"),
                    _buildInfo("CenterFrequency1",
                        "${e.centerFrequency1}GHz"),
                    _buildInfo("ChannelWidth", e.channelWidth),
                    _buildInfo("VenueName", e.venueName),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfo(String label, dynamic value) => Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(value.toString()))
          ],
        ),
      );
}

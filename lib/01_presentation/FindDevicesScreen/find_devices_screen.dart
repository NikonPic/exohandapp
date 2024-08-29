// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants.dart';
import '../DeviceScreen/device_screen.dart';
import '../Exoskeleton/exoscreen.dart';
import 'widgets/scan_result_tile.dart';

class FindDevicesScreen extends StatelessWidget {
  final String name;

  static String routeName = "/find_devices_screen";

  const FindDevicesScreen({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Search for Bluetooth devices')),
        backgroundColor: kPrimaryColor,
      ),
      body: FutureBuilder(
        future: _getPermissions(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return RefreshIndicator(
                onRefresh: () => FlutterBluePlus.startScan(
                    timeout: const Duration(seconds: 4)),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      StreamBuilder<List<BluetoothDevice>>(
                        stream: Stream.periodic(const Duration(seconds: 2))
                            .asyncMap((_) => FlutterBluePlus.connectedDevices),
                        initialData: const [],
                        builder: (c, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data!
                                  .map((d) => ListTile(
                                        title: highLightText(d),
                                        subtitle: Text(d.remoteId.toString()),
                                        trailing: StreamBuilder<
                                            BluetoothConnectionState>(
                                          stream: d.connectionState,
                                          initialData: BluetoothConnectionState
                                              .disconnected,
                                          builder: (c, snapshot) {
                                            if (snapshot.data ==
                                                BluetoothConnectionState
                                                    .connected) {
                                              return ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(kPrimaryColor),
                                                ),
                                                child: const Text('OPEN'),
                                                onPressed: () async {
                                                  List<BluetoothCharacteristic>
                                                      myChars =
                                                      await getChars(d);
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return ExoScreen(
                                                            myChars: myChars,
                                                            myDevice: d,
                                                            name: name);
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                            return Text(
                                                snapshot.data.toString());
                                          },
                                        ),
                                      ))
                                  .toList(),
                            );
                          }
                          return const Text('Noch keine Geräte verbunden.');
                        },
                      ),
                      StreamBuilder<List<ScanResult>>(
                        stream: FlutterBluePlus.scanResults,
                        initialData: const [],
                        builder: (c, snapshot) => Column(
                          children: snapshot.data!
                              .map(
                                (r) => ScanResultTile(
                                  result: r,
                                  onTap: () async {
                                    await r.device.connect();
                                    List<BluetoothCharacteristic> myChars =
                                        await getChars(r.device);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ExoScreen(
                                              myChars: myChars,
                                              myDevice: r.device,
                                              name: name);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Text('Keine Berechtigung.');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
      floatingActionButton: const StreamingActionButton(),
    );
  }

  Widget highLightText(BluetoothDevice d) {
    if (d.platformName.contains('DSD')) {
      return Text(
        'Exoskelett',
        style: TextStyle(color: Colors.green.shade800, fontSize: 20),
      );
    }
    return Text(d.platformName);
  }

  Future<bool> _getPermissions() async {
    await Permission.locationWhenInUse.request();
    await Permission.locationAlways.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();

    Location location = new Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    return true;
  }
}

class StreamingActionButton extends StatelessWidget {
  const StreamingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: FlutterBluePlus.isScanning,
      initialData: false,
      builder: (c, snapshot) {
        if (snapshot.data!) {
          return FloatingActionButton(
            onPressed: () => FlutterBluePlus.stopScan(),
            backgroundColor: Colors.redAccent,
            child: const Icon(Icons.stop),
          );
        } else {
          return FloatingActionButton(
              backgroundColor: kPrimaryColor,
              child: const Icon(
                Icons.search,
              ),
              onPressed: () => FlutterBluePlus.startScan(
                  timeout: const Duration(seconds: 4)));
        }
      },
    );
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_internet_speed_test/src/models/server_selection_response.dart';
import 'package:flutter_internet_speed_test/src/speed_test_utils.dart';
import 'package:http/http.dart' as http;
import 'package:tuple_dart/tuple.dart';

import 'callbacks_enum.dart';
import 'flutter_internet_speed_test_platform_interface.dart';

/// An implementation of [FlutterInternetSpeedTestPlatform] that uses method channels.
class MethodChannelFlutterInternetSpeedTest
    extends FlutterInternetSpeedTestPlatform {
  /// The method channel used to interact with the native platform.
  final _channel = const MethodChannel('com.shaz.plugin.fist/method');

  Future<void> _methodCallHandler(MethodCall call) async {
    if (isLogEnabled) {
      debugPrint('arguments are ${call.arguments}');
      debugPrint('callbacks are $callbacksById');
    }
    switch (call.method) {
      case 'callListener':
        if (call.arguments["id"] as int ==
            CallbacksEnum.startDownLoadTesting.index) {
          if (call.arguments['type'] == ListenerEnum.complete.index) {
            downloadSteps++;
            downloadRate +=
                int.parse((call.arguments['transferRate'] ~/ 1000).toString());

            double average = (downloadRate ~/ downloadSteps).toDouble();
            SpeedUnit unit = SpeedUnit.kbps;
            average /= 1000;
            unit = SpeedUnit.mbps;
            callbacksById[call.arguments["id"]]!.item3(average, unit);
            downloadSteps = 0;
            downloadRate = 0;
            callbacksById.remove(call.arguments["id"]);
          } else if (call.arguments['type'] == ListenerEnum.error.index) {
            callbacksById[call.arguments["id"]]!.item1(
                call.arguments['errorMessage'],
                call.arguments['speedTestError']);
            downloadSteps = 0;
            downloadRate = 0;
            callbacksById.remove(call.arguments["id"]);
          } else if (call.arguments['type'] == ListenerEnum.progress.index) {
            double rate = (call.arguments['transferRate'] ~/ 1000).toDouble();
            if (rate != 0) downloadSteps++;
            downloadRate += rate.toInt();
            SpeedUnit unit = SpeedUnit.kbps;
            rate /= 1000;
            unit = SpeedUnit.mbps;
            callbacksById[call.arguments["id"]]!
                .item2(call.arguments['percent'].toDouble(), rate, unit);
          } else if (call.arguments['type'] == ListenerEnum.cancel.index) {

            callbacksById[call.arguments["id"]]!.item4();
            downloadSteps = 0;
            downloadRate = 0;
            callbacksById.remove(call.arguments["id"]);
          }
        } else if (call.arguments["id"] as int ==
            CallbacksEnum.startUploadTesting.index) {
          if (call.arguments['type'] == ListenerEnum.complete.index) {

            uploadSteps++;
            uploadRate +=
                int.parse((call.arguments['transferRate'] ~/ 1000).toString());
            double average = (uploadRate ~/ uploadSteps).toDouble();
            SpeedUnit unit = SpeedUnit.kbps;
            average /= 1000;
            unit = SpeedUnit.mbps;
            callbacksById[call.arguments["id"]]!.item3(average, unit);
            uploadSteps = 0;
            uploadRate = 0;
            callbacksById.remove(call.arguments["id"]);
          } else if (call.arguments['type'] == ListenerEnum.error.index) {
            callbacksById[call.arguments["id"]]!.item1(
                call.arguments['errorMessage'],
                call.arguments['speedTestError']);
          } else if (call.arguments['type'] == ListenerEnum.progress.index) {
            double rate = (call.arguments['transferRate'] ~/ 1000).toDouble();
            if (rate != 0) uploadSteps++;
            uploadRate += rate.toInt();
            SpeedUnit unit = SpeedUnit.kbps;
            rate /= 1000.0;
            unit = SpeedUnit.mbps;
            callbacksById[call.arguments["id"]]!
                .item2(call.arguments['percent'].toDouble(), rate, unit);
          } else if (call.arguments['type'] == ListenerEnum.cancel.index) {
            callbacksById[call.arguments["id"]]!.item4();
            downloadSteps = 0;
            downloadRate = 0;
            callbacksById.remove(call.arguments["id"]);
          }
        }
//        callbacksById[call.arguments["id"]](call.arguments["args"]);
        break;
      default:
        if (isLogEnabled) {
          debugPrint(
              'TestFairy: Ignoring invoke from native. This normally shouldn\'t happen.');
        }
    }

    _channel.invokeMethod("cancelListening", call.arguments["id"]);
  }

  Future<CancelListening> _startListening(
      Tuple4<ErrorCallback, ProgressCallback, DoneCallback, CancelCallback>
          callback,
      CallbacksEnum callbacksEnum,
      String testServer,
      {Map<String, dynamic>? args,
      int fileSize = 10000000}) async {
    _channel.setMethodCallHandler(_methodCallHandler);
    int currentListenerId = callbacksEnum.index;
    if (isLogEnabled) {
      debugPrint('test $currentListenerId');
    }
    callbacksById[currentListenerId] = callback;
    await _channel.invokeMethod(
      "startListening",
      {
        'id': currentListenerId,
        'args': args,
        'testServer': testServer,
        'fileSize': fileSize,
      },
    );
    return () {
      _channel.invokeMethod("cancelListening", currentListenerId);
      callbacksById.remove(currentListenerId);
    };
  }

  Future<void> _toggleLog(bool value) async {
    await _channel.invokeMethod(
      "toggleLog",
      {
        'value': value,
      },
    );
  }

  @override
  Future<CancelListening> startDownloadTesting(
      {required DoneCallback onDone,
      required ProgressCallback onProgress,
      required ErrorCallback onError,
      required CancelCallback onCancel,
      required fileSize,
      required String testServer}) async {
    return await _startListening(Tuple4(onError, onProgress, onDone, onCancel),
        CallbacksEnum.startDownLoadTesting, testServer,
        fileSize: fileSize);
  }

  @override
  Future<CancelListening> startUploadTesting(
      {required DoneCallback onDone,
      required ProgressCallback onProgress,
      required ErrorCallback onError,
      required CancelCallback onCancel,
      required int fileSize,
      required String testServer}) async {
    return await _startListening(Tuple4(onError, onProgress, onDone, onCancel),
        CallbacksEnum.startUploadTesting, testServer,
        fileSize: fileSize);
  }

  @override
  Future<void> toggleLog({required bool value}) async {
    logEnabled = value;
    await _toggleLog(logEnabled);
  }

  @override
  Future<ServerSelectionResponse?> getDefaultServer() async {
    try {
      if (await isInternetAvailable()) {
        const tag = 'token:"';
        var tokenUrl = Uri.parse('https://fast.com/app-a32983.js');
        var tokenResponse = await http.get(tokenUrl);
        if (tokenResponse.body.contains(tag)) {
          int start = tokenResponse.body.lastIndexOf(tag) + tag.length;
          String token = tokenResponse.body.substring(start, start + 32);
          var serverUrl = Uri.parse(
              'https://api.fast.com/netflix/speedtest/v2?https=true&token=$token&urlCount=5');
          var serverResponse = await http.get(serverUrl);
          var serverSelectionResponse = ServerSelectionResponse.fromJson(
              json.decode(serverResponse.body));
          if (serverSelectionResponse.targets?.isNotEmpty == true) {
            return serverSelectionResponse;
          }
        }
      }
    } catch (e) {
      if (logEnabled) {
      }
    }
    return null;
  }

  @override
  Future<bool> cancelTest() async {
    var result = false;
    try {
      result = await _channel.invokeMethod("cancelTest", {
        'id1': CallbacksEnum.startDownLoadTesting.index,
        'id2': CallbacksEnum.startUploadTesting.index,
      });
    } on PlatformException {
      result = false;
    }
    return result;
  }
}

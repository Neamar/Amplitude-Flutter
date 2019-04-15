import 'dart:io';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';

class DeviceInfo {
  DeviceInfo() {
    getPlatformInfo();
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Map<String, dynamic> get() {
    return _deviceData;
  }

  Future<Map<String, dynamic>> getPlatformInfo() async {
    if (_deviceData.isNotEmpty) {
      return _deviceData;
    }

    Map<String, dynamic> deviceData;
    try {
      if (Platform.isAndroid) {
        deviceData = _parseAndroidInfo(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _parseIosInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      // log error
    }
    _deviceData = deviceData;
    return deviceData;
  }

  Map<String, dynamic> _parseAndroidInfo(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'os_name': build.version.baseOS,
      'device_brand': build.brand,
      'device_model': build.device,
      'device_id': build.androidId,
      'android_id': build.androidId,
      'platform': 'Android'
    };
  }

  Map<String, dynamic> _parseIosInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'os_name': data.systemName,
      'os_version': data.systemVersion,
      'device_brand': data.name,
      'device_model': data.model,
      'device_id': data.identifierForVendor,
      'idfv': data.identifierForVendor,
      'platform': 'iOS'
    };
  }
}
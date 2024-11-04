// import 'package:flutter/foundation.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class LocationPermission {
//    Future<void> requestLocationPermission() async {
//     var status = await Permission.locationWhenInUse.status;
//     if (!status.isGranted) {
//       status = await Permission.locationWhenInUse.request();
//     }

//     if (status.isGranted) {
//       getCurrentLocation();
//     } else if (status.isDenied) {
//       // Permission denied
//     } else if (status.isPermanentlyDenied) {
//       // Open app settings
//       openAppSettings();
//     }
//   }

//   Future<void> getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     if (kDebugMode) {
//       print(position);
//     }
//   }

// }



import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermission {
  Future<void> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isGranted) {
      try {
        await getCurrentLocation();
      } catch (e) {
        if (kDebugMode) {
          print('Error retrieving location: $e');
        }
      }
    } else if (status.isDenied) {
      // Notify the user that permission was denied
      if (kDebugMode) {
        print('Location permission denied');
      }
    } else if (status.isPermanentlyDenied) {
      // Open app settings to allow the user to grant permission manually
      openAppSettings();
    }
  }

  Future<Position> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (kDebugMode) {
        print('Current location: $position');
      }
      return position;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get location: $e');
      }
      rethrow; // Propagate the error if necessary
    }
  }
}

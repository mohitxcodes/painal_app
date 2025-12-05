import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';

class UpdateService {
  /// Forces an immediate update from Google Play if available.
  static Future<void> checkForImmediateUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable &&
          updateInfo.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate().catchError((e) {
          // Close the app if update is canceled or fails
          SystemNavigator.pop();
        });
      }
    } catch (e) {
      print("Update check failed: $e");
    }
  }
}

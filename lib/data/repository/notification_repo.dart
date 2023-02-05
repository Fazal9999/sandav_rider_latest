import 'package:delivery_man/data/api/api_client.dart';
import 'package:delivery_man/util/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  NotificationRepo({ this.apiClient,  this.sharedPreferences});

  Future<Response> getNotificationList() async {
    return await apiClient.getData('${AppConstants.NOTIFICATION_URI}${getUserToken()}');
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  void saveSeenNotificationCount(int count) {
    sharedPreferences.setInt(AppConstants.NOTIFICATION_COUNT, count);
  }

  int getSeenNotificationCount() {
    return sharedPreferences.getInt(AppConstants.NOTIFICATION_COUNT);
  }
}

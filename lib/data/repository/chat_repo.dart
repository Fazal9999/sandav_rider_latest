import 'dart:async';
import 'package:delivery_man/data/api/api_client.dart';
import 'package:delivery_man/helper/user_type.dart';
import 'package:delivery_man/util/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChatRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ChatRepo({ this.apiClient,  this.sharedPreferences});

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }
  Future<Response> getConversationList(int offset) async {
    return await apiClient.getData('${AppConstants.GET_CONVERSATION_LIST}?token=${getUserToken()}&offset=$offset&limit=10');
  }

  Future<Response> searchConversationList(String name) async {
    return apiClient.getData(AppConstants.SEARCH_CONVERSATION_LIST_URI + '?name=$name&token=${getUserToken()}&limit=20&offset=1');
  }

  Future<Response> getMessages(int offset, int userId, UserType userType, int conversationID) async {
    return await apiClient.getData('${AppConstants.GET_MESSAGE_LIST_URI}?${conversationID != null ?
    'conversation_id' : userType == UserType.user ? 'user_id' : 'vendor_id'}=${conversationID ?? userId}&token=${getUserToken()}&offset=$offset&limit=10');
  }

  Future<Response> sendMessage(String message, List<MultipartBody> file, int conversationId, int userId, UserType userType) async {
    return apiClient.postMultipartData(
        AppConstants.SEND_MESSAGE_URI,
        {'message': message, 'receiver_type': userType.name,
          '${conversationId != null ? 'conversation_id' : 'receiver_id'}': '${conversationId != null ?
          conversationId : userId}', 'token': getUserToken(), 'offset': '1', 'limit': '10'},
        file,null,null,null,"",""
    );
  }

}

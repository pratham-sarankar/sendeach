import 'package:get/get.dart';
import 'package:ja/app/data/services/auth_service.dart';

class SmsProvider extends GetConnect {
  @override
  void onInit() {
    baseUrl = const String.fromEnvironment("host");
    super.onInit();
  }

  Future<void> updateStatus(int smsId, SmsStatus status) async {
    await Get.putAsync(() => AuthService().init());
    var token = Get.find<AuthService>().readToken();
    var response = await post(
      '/update-status',
      {
        'id': smsId,
        'status': status.code,
      },
      contentType: 'application/json',
      headers: {"Authorization": "Bearer $token"},
    );
    print(response.body);
    if (response.body['status'] == false) {
      throw response.body['data']['message'];
    }
  }
}

enum SmsStatus {
  sent,
  delivered,
}

extension SmsStatusExtension on SmsStatus {
  int get code {
    switch (this) {
      case SmsStatus.sent:
        return 5;
      case SmsStatus.delivered:
        return 4;
    }
  }

  String get value {
    switch (this) {
      case SmsStatus.sent:
        return "sent";
      case SmsStatus.delivered:
        return "delivered";
    }
  }
}

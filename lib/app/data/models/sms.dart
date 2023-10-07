class Sms {
  int id;
  String message;
  int androidDeviceId;
  List<String> to;
  String batchId;
  DateTime initiatedTime;
  int smsType;
  DateTime createdAt;

  Sms({
    required this.id,
    required this.message,
    required this.androidDeviceId,
    required this.to,
    required this.batchId,
    required this.initiatedTime,
    required this.smsType,
    required this.createdAt,
  });

  //Create fromJson function
  factory Sms.fromJson(Map<String, dynamic> json) {
    var toList = json['to'].toString().split(", ");
    //All the items should start with +
    toList = toList.map((e) => e.startsWith("+") ? e : "+$e").toList();
    return Sms(
      id: json['id'],
      message: json['message'],
      androidDeviceId: json['android_device_id'],
      to: toList,
      batchId: json['batch_id'],
      initiatedTime: DateTime.parse(json['initiated_time']),
      smsType: json['sms_type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  //Create toJson function
  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "android_device_id": androidDeviceId,
        "to": to,
        "batch_id": batchId,
        "initiated_time": initiatedTime.toIso8601String(),
        "sms_type": smsType,
        "created_at": createdAt.toIso8601String(),
      };
}

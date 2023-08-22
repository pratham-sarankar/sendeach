import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';

extension ContactExtension on Contact {
  String get name => displayName ?? '';
  String get phoneNumber => phones?.first.value ?? '';

  ContactType get contactType {
    var name = androidAccountTypeRaw?.toLowerCase() ?? "";
    if (name.contains("whatsapp")) {
      return ContactType.whatsapp;
    }
    else if(emails?.isNotEmpty??false){
      return ContactType.email;
    }
    return ContactType.phone;
  }

  ImageProvider get imageProvider {
    switch (contactType) {
      case ContactType.whatsapp:
        return AssetImage("assets/whatsapp.png");
      case ContactType.email:
        return AssetImage("assets/email.png");
      case ContactType.phone:
        return AssetImage("assets/phone.png");
    }
  }
}

enum ContactType {
  whatsapp,
  email,
  phone,
}

class Contact {
  int id;
  String name;
  String phoneNumber;
  String avatar;

  Contact({this.name, this.phoneNumber, this.avatar});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["Name"] = name;
    map["PhoneNumber"] = phoneNumber;
    map["Avatar"] = avatar;
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Contact.fromMap(Map<String, dynamic> map) {
    id = map["Id"];
    name = map["Name"];
    phoneNumber = map["PhoneNumber"];
    avatar = map["Avatar"];
  }

    Contact.fromObject(dynamic o) {
    this.id = o["Id"];
    this.name = o["Name"];
    this.phoneNumber = o["PhoneNumber"];
    this.avatar = o["Avatar"];
  }
}

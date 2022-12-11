class ChatModel {
  String name;
  String? icon;
  bool? isGroup;
  String? time;
  String? currentMessage;
  String? status;
  bool select = false;
  int? id;
  ChatModel({
    required this.name,
    this.icon,
    this.isGroup,
    this.time,
    this.currentMessage,
    this.status,
    this.select = false,
    this.id,
  });
}

class UserModel {
  String name;
  String? bio;
  String? status;
  String? uid;
  bool select = false;
  UserModel(
      {required this.name,
      this.bio,
      this.uid,
      this.status,
      this.select = false});
}

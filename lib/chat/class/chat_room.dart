import 'dart:convert';

class ChatRoom{
  final int id;
  final String anotherUserNickname;
  final String imageUrl;
  
  ChatRoom({required this.id, required this.anotherUserNickname, required this.imageUrl});
  
  factory ChatRoom.fromJson(Map<String, dynamic> json){
    return ChatRoom(id: json['id'], anotherUserNickname: json['another_user_nickname'], imageUrl: json['image_url']);
  }
}
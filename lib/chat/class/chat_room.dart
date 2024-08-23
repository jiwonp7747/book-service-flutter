import 'dart:convert';

class ChatRoom{
  final String anotherUserNickname;
  final String imageUrl;
  
  ChatRoom({required this.anotherUserNickname, required this.imageUrl});
  
  factory ChatRoom.fromJson(Map<String, dynamic> json){
    return ChatRoom(anotherUserNickname: json['another_user_nickname'], imageUrl: json['image_url']);
  }
}
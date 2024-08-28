class ChatMessage {
  final int id;
  final String content;
  final DateTime registeredAt;
  final int chatRoomId;

  ChatMessage({required this.id,
    required this.content,
    required this.registeredAt,
    required this.chatRoomId
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json){
    return ChatMessage(
        id: json['id'],
        content: json['content'],
        registeredAt: DateTime.parse(json['registered_at']),
        chatRoomId: json['chat_room_id']);
  }
}

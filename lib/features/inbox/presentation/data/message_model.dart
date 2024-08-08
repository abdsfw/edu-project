class Message {
  final String message;

  final int senderId;
  final int receiverId;

  Message({
    required this.message,
    required this.senderId,
    required this.receiverId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
    );
  }
}

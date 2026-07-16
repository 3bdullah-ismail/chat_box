class MessageModel {
  final String id;

  final String senderId;

  final String receiverId;

  final String text;

  final int timestamp;

  final bool isSeen;

  final bool isDeletedForEveryone;

  final List<String> deletedForUsers;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.isSeen,
    required this.isDeletedForEveryone,
    required this.deletedForUsers,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, String id) {
    return MessageModel(
      id: id,
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      text: json['text'] ?? '',
      timestamp: (json['timestamp'] ?? 0) as int,
      isSeen: json['isSeen'] ?? false,
      isDeletedForEveryone: json['isDeletedForEveryone'] ?? false,
      deletedForUsers: List<String>.from(json['deletedForUsers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
      'isSeen': isSeen,
      'isDeletedForEveryone': isDeletedForEveryone,
      'deletedForUsers': deletedForUsers,
    };
  }
}

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final int timestamp;
  final bool isSeen;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isSeen,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, String docId) {
    return MessageModel(
      id: docId,
      senderId: json['senderId'] ?? '',
      text: json['text'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      isSeen: json['isSeen'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "text": text,
      "timestamp": timestamp,
      "isSeen": isSeen,
    };
  }
}

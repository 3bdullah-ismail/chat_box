class ConversationModel {
  final String id;
  final Map<String, bool> participants;
  final Map<String, String> userNames;
  final Map<String, String> userImages;
  final String lastMessage;
  final int lastMessageTime;

  ConversationModel({
    required this.id,
    required this.participants,
    required this.userNames,
    required this.userImages,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json, String docId) {
    return ConversationModel(
      id: docId,
      participants: Map<String, bool>.from(json['participants'] ?? {}),
      userNames: Map<String, String>.from(json['userNames'] ?? {}),
      userImages: Map<String, String>.from(json['userImages'] ?? {}),
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "participants": participants,
      "userNames": userNames,
      "userImages": userImages,
      "lastMessage": lastMessage,
      "lastMessageTime": lastMessageTime,
    };
  }
}

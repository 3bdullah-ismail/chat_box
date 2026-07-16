class ConversationModel {
  final String id;
  final Map<String, bool> participants;
  final Map<String, String> userNames;
  final Map<String, String> userImages;
  final String lastMessage;
  final String lastMessageSenderId;
  final int lastMessageTime;
  final int createdAt;
  final Map<String, int> unreadCountMap;

  const ConversationModel({
    required this.id,
    required this.participants,
    required this.userNames,
    required this.userImages,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.lastMessageTime,
    required this.createdAt,
    required this.unreadCountMap,
  });
  int getUnreadCount(String currentUserId) {
    return unreadCountMap[currentUserId] ?? 0;
  }

  factory ConversationModel.fromJson(Map<String, dynamic> json, String id) {
    final rawUnread = json['unreadCount'] as Map<dynamic, dynamic>? ?? {};
    final Map<String, int> unreadMap = {};
    rawUnread.forEach((key, value) {
      unreadMap[key.toString()] = (value as num).toInt();
    });

    return ConversationModel(
      id: id,
      participants: Map<String, bool>.from(json['participants'] ?? {}),
      userNames: Map<String, String>.from(json['userNames'] ?? {}),
      userImages: Map<String, String>.from(json['userImages'] ?? {}),
      lastMessage: json['lastMessage'] ?? '',
      lastMessageSenderId: json['lastMessageSenderId'] ?? '',
      lastMessageTime: (json['lastMessageTime'] ?? 0) as int,
      createdAt: (json['createdAt'] ?? 0) as int,
      unreadCountMap: unreadMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'userNames': userNames,
      'userImages': userImages,
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageTime': lastMessageTime,
      'createdAt': createdAt,
      'unreadCount': unreadCountMap,
    };
  }
}

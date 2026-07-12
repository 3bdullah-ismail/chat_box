import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestModel {
  final String id;
  final String senderId;
  final String senderName;
  final String senderEmail;
  final String senderUsername;
  final String receiverId;
  final String receiverName;
  final String receiverEmail;
  final String receiverUsername;
  final String status;
  final DateTime? createdAt;

  FriendRequestModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderEmail,
    required this.senderUsername,
    required this.receiverId,
    this.receiverName = '',
    this.receiverEmail = '',
    this.receiverUsername = '',
    required this.status,
    this.createdAt,
  });

  factory FriendRequestModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final json = doc.data()!;

    return FriendRequestModel(
      id: doc.id,
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderEmail: json['senderEmail'] ?? '',
      senderUsername:
          json['senderUsername'] ??
          (json['senderEmail'] != null && json['senderEmail'] != ''
              ? json['senderEmail'].split('@')[0]
              : ''),
      receiverId: json['receiverId'] ?? '',
      receiverName: json['receiverName'] ?? '',
      receiverEmail: json['receiverEmail'] ?? '',
      receiverUsername: json['receiverUsername'] ?? '',
      status: json['status'] ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'senderUsername': senderUsername,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverEmail': receiverEmail,
      'receiverUsername': receiverUsername,
      'status': status,
      'createdAt': createdAt,
    };
  }
}

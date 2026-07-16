import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String username;
  final String? bio;
  final String? address;
  final DateTime? joinedAt;
  final bool? isProfileCompleted;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.bio,
    this.address,
    this.joinedAt,
    this.isProfileCompleted,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data()!;

    return UserModel(
      id: doc.id,
      name: json['name'],
      email: json['email'],
      username: json['username'] ?? '',
      bio: json['bio'],
      address: json['address'],
      joinedAt: json['joinedAt'] != null
          ? (json['joinedAt'] as Timestamp).toDate()
          : null,
      isProfileCompleted: json['isProfileCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'username': username,
      'bio': bio,
      'address': address,
      'joinedAt': joinedAt != null ? Timestamp.fromDate(joinedAt!) : null,
      'isProfileCompleted': isProfileCompleted,
    };
  }
}

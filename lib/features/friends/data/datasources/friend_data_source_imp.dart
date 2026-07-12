import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/friends/data/datasources/friend_data_source.dart';
import 'package:chat_app/features/friends/data/models/friend_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: FriendDataSource)
class FriendDataSourceImp implements FriendDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore fireStore;

  FriendDataSourceImp({required this.firebaseAuth, required this.fireStore});

  @override
  Future<List<UserModel>> getUsers() async {
    final currentUserId = firebaseAuth.currentUser!.uid;

    // جلب الأصدقاء الحاليين لاستبعادهم من قائمة "البحث عن مستخدمين جدد"
    final friendsSnapshot = await fireStore
        .collection('friends')
        .doc(currentUserId)
        .collection('user_friends')
        .get();
    final friendIds = friendsSnapshot.docs.map((doc) => doc.id).toSet();

    // جلب طلبات الصداقة المعلقة (سواء مرسلة أو مستقبلة) لاستبعادها أيضاً
    final sentRequestsSnapshot = await fireStore
        .collection('friend_requests')
        .where('senderId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .get();

    final receivedRequestsSnapshot = await fireStore
        .collection('friend_requests')
        .where('receiverId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .get();

    final pendingUserIds = {
      ...sentRequestsSnapshot.docs.map(
        (doc) => doc.data()['receiverId'] as String? ?? '',
      ),
      ...receivedRequestsSnapshot.docs.map(
        (doc) => doc.data()['senderId'] as String? ?? '',
      ),
    };

    final snapshot = await fireStore.collection('users').get();

    return snapshot.docs
        .where(
          (doc) =>
              doc.id != currentUserId &&
              !friendIds.contains(doc.id) &&
              !pendingUserIds.contains(doc.id),
        )
        .map(UserModel.fromFirestore)
        .toList();
  }

  @override
  Future<void> sendFriendRequest(String receiverId) async {
    final senderId = firebaseAuth.currentUser!.uid;

    // الفحص العكسي والمستقيم في نفس الوقت لمنع التكرار والتداخل المعلق
    final existingRequest = await fireStore
        .collection('friend_requests')
        .where('status', isEqualTo: 'pending')
        .get();

    final hasRequest = existingRequest.docs.any((doc) {
      final data = doc.data();
      return (data['senderId'] == senderId &&
              data['receiverId'] == receiverId) ||
          (data['senderId'] == receiverId && data['receiverId'] == senderId);
    });

    if (hasRequest) {
      throw Exception('There is already a pending request between you.');
    }

    final senderDoc = await fireStore.collection('users').doc(senderId).get();
    final sender = UserModel.fromFirestore(senderDoc);

    final receiverDoc = await fireStore
        .collection('users')
        .doc(receiverId)
        .get();
    final receiver = UserModel.fromFirestore(receiverDoc);

    await fireStore.collection('friend_requests').add({
      'senderId': sender.id,
      'senderName': sender.name,
      'senderEmail': sender.email,
      'senderUsername': sender.username,
      'receiverId': receiverId,
      'receiverName': receiver.name,
      'receiverEmail': receiver.email,
      'receiverUsername': receiver.username,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<FriendRequestModel>> getFriendRequests() async {
    final myId = firebaseAuth.currentUser!.uid;
    final snapshot = await fireStore
        .collection('friend_requests')
        .where('receiverId', isEqualTo: myId)
        .where('status', isEqualTo: 'pending')
        .get();

    final rawRequests = snapshot.docs
        .map(FriendRequestModel.fromFirestore)
        .toList();

    final updatedRequests = await Future.wait(
      rawRequests.map((request) async {
        try {
          final senderDoc = await fireStore
              .collection('users')
              .doc(request.senderId)
              .get();
          if (senderDoc.exists) {
            final senderData = senderDoc.data()!;
            return FriendRequestModel(
              id: request.id,
              senderId: request.senderId,
              senderName: senderData['name'] as String? ?? request.senderName,
              senderEmail:
                  senderData['email'] as String? ?? request.senderEmail,
              senderUsername:
                  senderData['username'] as String? ?? request.senderUsername,
              receiverId: request.receiverId,
              status: request.status,
              createdAt: request.createdAt,
            );
          }
        } catch (_) {}
        return request;
      }),
    );

    _sortRequests(updatedRequests);
    return updatedRequests;
  }

  @override
  Future<List<FriendRequestModel>> getSentFriendRequests() async {
    final myId = firebaseAuth.currentUser!.uid;
    final snapshot = await fireStore
        .collection('friend_requests')
        .where('senderId', isEqualTo: myId)
        .where('status', isEqualTo: 'pending')
        .get();

    final rawRequests = snapshot.docs
        .map(FriendRequestModel.fromFirestore)
        .toList();

    final updatedRequests = await Future.wait(
      rawRequests.map((request) async {
        if (request.receiverName.isNotEmpty) {
          return request;
        }
        try {
          final receiverDoc = await fireStore
              .collection('users')
              .doc(request.receiverId)
              .get();
          if (receiverDoc.exists) {
            final receiverData = receiverDoc.data()!;
            return FriendRequestModel(
              id: request.id,
              senderId: request.senderId,
              senderName: request.senderName,
              senderEmail: request.senderEmail,
              senderUsername: request.senderUsername,
              receiverId: request.receiverId,
              receiverName: receiverData['name'] as String? ?? '',
              receiverEmail: receiverData['email'] as String? ?? '',
              receiverUsername: receiverData['username'] as String? ?? '',
              status: request.status,
              createdAt: request.createdAt,
            );
          }
        } catch (_) {}
        return request;
      }),
    );

    _sortRequests(updatedRequests);
    return updatedRequests;
  }

  @override
  Future<void> acceptFriendRequest(FriendRequestModel request) async {
    final senderDoc = await fireStore
        .collection('users')
        .doc(request.senderId)
        .get();
    final receiverDoc = await fireStore
        .collection('users')
        .doc(request.receiverId)
        .get();

    final sender = UserModel.fromFirestore(senderDoc);
    final receiver = UserModel.fromFirestore(receiverDoc);

    await fireStore.runTransaction((transaction) async {
      transaction.update(
        fireStore.collection('friend_requests').doc(request.id),
        {'status': 'accepted'},
      );

      transaction.set(
        fireStore
            .collection('friends')
            .doc(receiver.id)
            .collection('user_friends')
            .doc(sender.id),
        sender.toJson(),
      );

      transaction.set(
        fireStore
            .collection('friends')
            .doc(sender.id)
            .collection('user_friends')
            .doc(receiver.id),
        receiver.toJson(),
      );
    });
  }

  @override
  Future<List<UserModel>> getFriends() async {
    final myId = firebaseAuth.currentUser!.uid;
    final snapshot = await fireStore
        .collection('friends')
        .doc(myId)
        .collection('user_friends')
        .get();

    return snapshot.docs.map(UserModel.fromFirestore).toList();
  }

  void _sortRequests(List<FriendRequestModel> list) {
    list.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });
  }
}

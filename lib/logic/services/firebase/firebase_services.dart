import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  Future<void> toggleFollow(
    String userId,
    String teamId,
    bool isFollowing,
  ) async {
    final teamRef = FirebaseFirestore.instance.collection('teams').doc(teamId);
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final teamSnap = await transaction.get(teamRef);

      if (!teamSnap.exists) {
        throw Exception("Team does not exist");
      }

      final currentCount = teamSnap['followers'] ?? 0;

      if (isFollowing) {
        transaction.delete(userRef.collection('following').doc(teamId));
        transaction.delete(teamRef.collection('followers').doc(userId));
        transaction.update(teamRef, {'followers': currentCount - 1});
      } else {
        transaction.set(userRef.collection('following').doc(teamId), {
          'followedAt': FieldValue.serverTimestamp(),
        });
        transaction.set(teamRef.collection('followers').doc(userId), {
          'followedAt': FieldValue.serverTimestamp(),
        });
        transaction.update(teamRef, {'followers': currentCount + 1});
      }
    });
  }

  Stream<List<String>> getUserFollowing(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('following')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.id).toList());
  }
}

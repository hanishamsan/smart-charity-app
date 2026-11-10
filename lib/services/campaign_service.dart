import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CampaignService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getCampaigns() {
    return _firestore.collection('campaigns').snapshots();
  }

  Future<void> donateToCampaign({
    required String campaignId,
    required String campaignTitle,
    required double amount,
    required String paymentMethod,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _firestore.runTransaction((transaction) async {
      DocumentReference campaignRef = _firestore
          .collection('campaigns')
          .doc(campaignId);

      DocumentReference userRef = _firestore.collection('users').doc(user.uid);

      // READ ALL FIRST
      DocumentSnapshot campaignSnapshot = await transaction.get(campaignRef);

      DocumentSnapshot userSnapshot = await transaction.get(userRef);

      double currentAmount = (campaignSnapshot['currentAmount'] as num)
          .toDouble();

      double totalDonated = 0;

      if (userSnapshot.exists) {
        totalDonated = (userSnapshot['totalDonated'] as num?)?.toDouble() ?? 0;
      }

      // WRITE AFTER ALL READS
      transaction.update(campaignRef, {
        'currentAmount': currentAmount + amount,
      });

      transaction.update(userRef, {'totalDonated': totalDonated + amount});
    });

    await _firestore.collection('donations').add({
      'userId': user.uid,
      'campaignId': campaignId,
      'campaignTitle': campaignTitle,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'donationDate': Timestamp.fromDate(DateTime.now().toLocal()),
    });
  }
}

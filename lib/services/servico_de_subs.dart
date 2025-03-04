import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionService {
  Future<Map<String, dynamic>> getUserSubscriptionInfo(String uid) async {
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!snapshot.exists) return {'isPremium': false, 'planType': ''};

    final data = snapshot.data() as Map<String, dynamic>;
    final subscriptionStatus = data['subscriptionStatus'];
    final expiryDate = data['expiryDate']?.toDate();
    final planType = data['planType'];

    if (subscriptionStatus == 'active' &&
        expiryDate != null &&
        expiryDate.isAfter(DateTime.now())) {
      return {'isPremium': true, 'planType': planType};
    }

    return {'isPremium': false, 'planType': ''};
  }
}

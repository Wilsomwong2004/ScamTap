import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/search_record_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Future<void> saveSearchRecord({
    required String type,
    required String value,
    required int riskScore,
    required Map<String, dynamic> detail,
  }) async {
    String riskLevel;
    if (riskScore >= 70) {
      riskLevel = "Dangerous";
    } else if (riskScore >= 40) {
      riskLevel = "Warning";
    } else {
      riskLevel = "Safe";
    }

    final record = SearchRecordModel(
      type: type,
      value: value,
      riskScore: riskScore,
      riskLevel: riskLevel,
      timestamp: DateTime.now(),
      detail: detail,
    );

    if (_uid == null) return;

    await _db
        .collection('usersData')
        .doc(_uid)
        .collection('searchRecord')
        .add(record.toMap());
  }

  Stream<List<SearchRecordModel>> getSearchHistory() {
    if (_uid == null) return Stream.value([]);
    
    return _db
        .collection('usersData')
        .doc(_uid)
        .collection('searchRecord')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => SearchRecordModel.fromMap(doc.data()))
            .toList());
  }
}
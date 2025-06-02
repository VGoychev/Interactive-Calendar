import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEvent({
    required String uid,
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    String color = '#2196F3',
  }) async {

    final docRef = _firestore.collection('events').doc();
    final now = DateTime.now();

    final eventData = {
      'id': docRef.id,
      'title': title.trim(),
      'description': description.trim(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'createdBy': uid,
      'color': color,
      'createdAt': now.toIso8601String(),
    };

    await docRef.set(eventData);
  }

  Future<void> addUser(
      {required String uid,
      required String name,
      required String email,
      required Timestamp createdAt}) async {
    final userDoc = _firestore.collection('users').doc(uid);

    await userDoc.set({
      'name': name.trim(),
      'email': email.trim(),
      'createdAt': createdAt,
    });
  }

   Future<List<CalendarEvent>> getUserEvents(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .where('createdBy', isEqualTo: uid)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CalendarEvent.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createEvent({
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
    return docRef.id;
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

  Future<void> deleteEvent({
    required String eventId,
    required String uid,
  }) async {
    final docRef = _firestore.collection('events').doc(eventId);

    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception('Event not found');
    }

    final data = snapshot.data();
    final createdBy = data?['createdBy'];

    if (createdBy != uid) {
      throw Exception('You are not authorized to delete this event');
    }

    await docRef.delete();
  }
}

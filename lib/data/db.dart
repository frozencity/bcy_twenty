import 'package:cloud_firestore/cloud_firestore.dart';

class Sponsor {
  final String title;
  final String name;
  final String image;
  final String link;

  Sponsor({
    this.title,
    this.name,
    this.image,
    this.link,
  });

  factory Sponsor.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Sponsor(
      title: data['title'] ?? '',
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      link: data['link'] ?? '',
    );
  }
}

class Talks {
  final String title;
  final String day;
  final String speaker;
  final String time;
  final String topic;
  final String room;

  Talks({
    this.title,
    this.day,
    this.speaker,
    this.time,
    this.topic,
    this.room,
  });

  factory Talks.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Talks(
      title: data['title'] ?? '',
      day: data['day'] ?? '',
      speaker: data['speaker'] ?? '',
      time: data['time'] ?? '',
      topic: data['topic'] ?? '',
      room: data['room'] ?? '',
    );
  }
}

class Times {

  final String time;

  Times({
    this.time,
  });

  factory Times.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Times(
      time: data['time'] ?? '',
    );
  }
}

//
class DatabaseService {
  final Firestore _db = Firestore.instance;

  /// This pulls the collection named "Sponsors" from Firebase Cloud Firestore.
  /// And adds to a List of Sponors.
  Stream<List<Sponsor>> streamSponsor() {
    var ref = _db.collection('sponsors').snapshots();

    return ref.map((list) =>
        list.documents.map((doc) => Sponsor.fromFirestore(doc)).toList());
  }

/// Talks
  Stream<List<Talks>> streamTalks() {
    var ref = _db.collection('sampletalks').snapshots();

    return ref.map((list) =>
        list.documents.map((doc) => Talks.fromFirestore(doc)).toList());
  }

  /// Times
  ///
  Stream<List<Times>> streamTimes(){
    var ref = _db.collection('sessiontimes').snapshots();

    return ref.map((list) =>
        list.documents.map((doc) => Times.fromFirestore(doc)).toList());
  }



}

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

//Sample Talks
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

//This uses as Headers for TabBar.
class D1Times {

  final String time;

  D1Times({
    this.time,
  });

  factory D1Times.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return D1Times(
      time: data['time'] ?? '',
    );
  }
}
class D2Times {

  final String time;

  D2Times({
    this.time,
  });

  factory D2Times.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return D2Times(
      time: data['time'] ?? '',
    );
  }
}
//Actual Talks
class D1ConferenceTalks{
  final String title, speaker, time, category;

  D1ConferenceTalks({
    this.title,
    this.speaker,
    this.time,
    this.category,
  });

  factory D1ConferenceTalks.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return D1ConferenceTalks(
      title: data['title'] ?? '',
      speaker: data['speaker'] ?? '',
      time: data['time'] ?? '',
      category: data['topic'] ?? '',
    );
  }
  
  
}
class D2ConferenceTalks{
  final String title, speaker, time, category;

  D2ConferenceTalks({
    this.title,
    this.speaker,
    this.time,
    this.category,
  });

  factory D2ConferenceTalks.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return D2ConferenceTalks(
      title: data['title'] ?? '',
      speaker: data['speaker'] ?? '',
      time: data['time'] ?? '',
      category: data['topic'] ?? '',
    );
  }


}
class D1orTalks {
  final String title;
  final String speaker;
  final String time;
  final String category;
  final String room;

  D1orTalks({
    this.title,
    this.speaker,
    this.time,
    this.category,
    this.room,
  });

  factory D1orTalks.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return D1orTalks(
      title: data['title'] ?? '',
      speaker: data['speaker'] ?? '',
      time: data['time'] ?? '',
      category: data['category'] ?? '',
      room: data['room'] ?? '',
    );
  }
}
class D2orTalks {
  final String title;
  final String speaker;
  final String time;
  final String category;
  final String room;

  D2orTalks({
    this.title,
    this.speaker,
    this.time,
    this.category,
    this.room,
  });

  factory D2orTalks.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return D2orTalks(
      title: data['title'] ?? '',
      speaker: data['speaker'] ?? '',
      time: data['time'] ?? '',
      category: data['category'] ?? '',
      room: data['room'] ?? '',
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
  Stream<List<D1Times>> streamD1Times(){
    var ref = _db.collection('sessiontimes').snapshots();

    return ref.map((list) =>
        list.documents.map((doc) => D1Times.fromFirestore(doc)).toList());
  }

  Stream<List<D2Times>> streamD2Times(){
    var ref = _db.collection('day2times').snapshots();

    return ref.map((list) =>
        list.documents.map((doc) => D2Times.fromFirestore(doc)).toList());
  }
  
  /// Talks for Conference Room. Day 1. Because It sucks.
  Stream<List<D1ConferenceTalks>> streamDay1ConferenceRoomTalks(){
    var ref = _db.collection('talks').document('Day 1').collection('Conference Room').snapshots();

    return ref.map((list) =>
        list.documents.map((doc) => D1ConferenceTalks.fromFirestore(doc)).toList());

  }

  Stream<List<D1orTalks>> streamD1orTalks() {
    var ref = _db.collection('talks').document('Day 1').collection('otherRooms').snapshots();

    return ref.map((list) =>
        list.documents.map((doc) => D1orTalks.fromFirestore(doc)).toList());
  }

  /// Day 2.
  Stream<List<D2ConferenceTalks>> streamDay2ConferenceRoomTalks(){
    var ref = _db.collection('talks').document('Day 2').collection('Conference Room').snapshots();

    return ref.map((list) =>
        list.documents.map((doc) => D2ConferenceTalks.fromFirestore(doc)).toList());

  }

  Stream<List<D2orTalks>> streamD2orTalks() {
    var ref = _db.collection('talks').document('Day 2').collection('otherRooms').snapshots();

    return ref.map((list) =>
        list.documents.map((doc) => D2orTalks.fromFirestore(doc)).toList());
  }

}

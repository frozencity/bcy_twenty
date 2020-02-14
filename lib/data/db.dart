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
//Day 1 Header Times
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
//Day 2 Header Times
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
//Day 1 Conference Room Talks
class D1ConferenceTalks{
  final String title, speaker, time, category, code;

  D1ConferenceTalks({
    this.title,
    this.speaker,
    this.time,
    this.category,
    this.code,
  });

  factory D1ConferenceTalks.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return D1ConferenceTalks(
      title: data['title'] ?? '',
      speaker: data['speaker'] ?? '',
      time: data['time'] ?? '',
      category: data['topic'] ?? '',
      code: data['code'] ?? '',
    );
  }
  
  
}
//Day 2 Conference Room Talks
class D2ConferenceTalks{
  final String title, speaker, time, category, code;

  D2ConferenceTalks({
    this.title,
    this.speaker,
    this.time,
    this.category,
    this.code,
  });

  factory D2ConferenceTalks.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return D2ConferenceTalks(
      title: data['title'] ?? '',
      speaker: data['speaker'] ?? '',
      time: data['time'] ?? '',
      category: data['topic'] ?? '',
      code: data['code'] ?? '',
    );
  }


}
//Day 1 Other Room Talks
class D1orTalks {
  final String title, speaker, time, category, room, code;

  D1orTalks({
    this.title,
    this.speaker,
    this.time,
    this.category,
    this.room,
    this.code,
  });

  factory D1orTalks.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return D1orTalks(
      title: data['title'] ?? '',
      speaker: data['speaker'] ?? '',
      time: data['time'] ?? '',
      category: data['category'] ?? '',
      room: data['room'] ?? '',
      code: data['code'] ?? '',
    );
  }
}
//Day 2 Other Room Talks
class D2orTalks {
  final String title, speaker, time, category, room, code;

  D2orTalks({
    this.title,
    this.speaker,
    this.time,
    this.category,
    this.room,
    this.code,
  });

  factory D2orTalks.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return D2orTalks(
      title: data['title'] ?? '',
      speaker: data['speaker'] ?? '',
      time: data['time'] ?? '',
      category: data['category'] ?? '',
      room: data['room'] ?? '',
      code: data['code'] ?? '',
    );
  }
}

class Register {
  String id;
  String email;
  String name;
  String gender;
  String age;
  String job_title;
  String company;
  String education;
  String tshirt_size;
  int attended_rooms;


  Register({
    this.id,
    this.email,
    this.name,
    this.gender,
    this.age,
    this.job_title,
    this.company,
    this.education,
    this.tshirt_size,
    this.attended_rooms,
  });

  factory Register.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Register(
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      gender: data['gender'] ?? '',
      age: data['age'] ?? '',
      job_title: data['job_title'] ?? '',
      company: data['company'] ?? '',
      education: data['education'] ?? '',
      tshirt_size: data['tshirt_size'] ?? '',
      attended_rooms: data['attended_rooms'] ?? 0,
    );
  }

  toJson() {
    return {
      "id" : id,
      "email": email,
      "name": name,
      "gender": gender,
      "age": age,
      "job_title": job_title,
      "company": company,
      "education": education,
      "tshirt_size": tshirt_size,
      "attended_rooms": attended_rooms,
    };
  }


}

class Categories{
  String id;
  String users;
  String name;
  int votes;

  Categories({
    this.id,
    this.users,
    this.name,
    this.votes,
  });

  factory Categories.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Categories(
      id: doc.documentID,
      users: data['users'] ?? '',
      name: data['name'] ?? '',
      votes: data['votes'] ?? 0,
    );
  }

  toJSON(){
    return {
      "users": users,
      "name": name,
      "votes": votes,
    };
  }

  Categories.fromJson(Map<String, dynamic> jsonMap, String documentId) {
    users = jsonMap['users'];
    name = jsonMap['name'];
    votes = jsonMap['votes'];
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

  Future<void> registerUser(String userID, Register data) {

    _db.collection('registration').document(userID).setData(data.toJson());
  }

  Future<void> updateUser(String userID, data) {


    _db.collection('registration').document(userID).updateData(data);
  }

  Stream<List<Categories>> streamCategories() {
    var ref = _db.collection('categories').snapshots();

    return ref.map((list) =>
        list.documents.map((doc) {
          //print(doc);
          return Categories.fromFirestore(doc);
        }).toList());
  }

  Stream<List<D1ConferenceTalks>> getCodefromD1Conference(String code) {
    var ref = _db.collection('talks').document('Day 1').collection('Conference Room').where('code', isEqualTo: code).snapshots();

    return ref.map((list) =>
        list.documents.map((doc) => D1ConferenceTalks.fromFirestore(doc)).toList());
  }

  Stream<List<Register>> getRegistrationList(){
    var ref = _db.collection('registration').snapshots();

    return ref.map((list) =>
        list.documents.map((doc) => Register.fromFirestore(doc)).toList());
  }


}

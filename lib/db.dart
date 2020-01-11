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

//
class DatabaseService {
  final Firestore _db = Firestore.instance;

  /// Query a subcollection
  Stream<List<Sponsor>> streamSponsor() {
    var ref = _db.collection('sponsors').snapshots();

    return ref.map((list) =>
        list.documents.map((doc) => Sponsor.fromFirestore(doc)).toList());
  }
}

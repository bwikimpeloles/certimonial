import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database3 {
  User? user = FirebaseAuth.instance.currentUser;
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> create(
      String description, String location, String datentime) async {
    try {
      await firestore.collection('pdf').doc(user!.uid).collection(user!.uid).add({
        'description': description,
        'location': location,
        'datentime': datentime,
        'datetime': FieldValue.serverTimestamp(),
        'url': "",
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await firestore.collection('pdf').doc(user!.uid).collection(user!.uid).doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot =
      await firestore.collection('pdf').doc(user!.uid).collection(user!.uid).orderBy('datetime').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "description": doc['description'],
            "location": doc["location"],
            "url": doc["url"],
            "datentime": doc["datentime"],
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return read();
  }

  Future<List> read2(String? url) async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('pdf').doc(user!.uid).collection(user!.uid)
          .where("url", isEqualTo: url)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "description": doc['description'],
            "location": doc["location"],
            "url": doc["url"],
            "datentime": doc["datentime"],
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return read2(url);
  }

  Future<void> update(
      String id, String description, String location, String datentime) async {
    try {
      await firestore.collection('pdf').doc(user!.uid).collection(user!.uid).doc(id).update({
        'description': description,
        'location': location,
        'datentime': datentime
      });
    } catch (e) {
      print(e);
    }
  }
}

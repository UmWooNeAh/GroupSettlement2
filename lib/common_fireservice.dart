import 'package:cloud_firestore/cloud_firestore.dart';

class FireService {

  static final FireService _fireService = FireService.internal();
  factory FireService() => _fireService;
  FireService.internal();

  deleteDoc(String path, String id) async {
    await FirebaseFirestore.instance.collection(path).doc(id).delete();
  }

  updateDoc(String path, String id, Map<String, dynamic> json) async {
    await FirebaseFirestore.instance.collection(path).doc(id).update(json);
  }

}
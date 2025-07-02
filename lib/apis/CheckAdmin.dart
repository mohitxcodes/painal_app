import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkIfAdmin() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;

  final doc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  return doc.exists && doc.data()?['admin'] == true;
}

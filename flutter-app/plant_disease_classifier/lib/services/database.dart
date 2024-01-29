// import 'package:cloud_firestore/cloud_firestore.dart';

// class DatabaseService {
//   final CollectionReference plantsCollection =
//       FirebaseFirestore.instance.collection('plants');
  
//   Future<List<String>> getCollectionValues() async{
//     try{
//       QuerySnapshot querySnapshot = await plantsCollection.get();

//       List<String> values = querySnapshot.docs.map((doc) => doc.data()['your_field'] as String)
//     }
//   }
// }

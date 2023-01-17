import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference<Map<String, dynamic>> bleCollection =
      FirebaseFirestore.instance.collection("ble");

  Future<void> saveBLE(int rssi, String did) async {
    //doc will create a new uid of Database service
    return await bleCollection
        .doc(did)
        .set({'details': FieldValue.arrayUnion([{'rssi':rssi, 'time': Timestamp.now(),   }])});
  }
  Future<void> updateBLE(int rssi, String did) async {
    //doc will create a new uid of Database service
    return await bleCollection.doc(did).update({
      'details': FieldValue.arrayUnion([
        {
          'rssi': rssi,
          'time': Timestamp.now(),
        }
      ])
    });
  }

  Future<void> saveTimeBLE(int rssi, String did) async {
    //doc will create a new uid of Database service

    var time=Timestamp.now().toString(); 

    return await bleCollection.doc(did).set({
      time: FieldValue.arrayUnion([
          rssi])
    }, SetOptions(merge: true));
  }


}

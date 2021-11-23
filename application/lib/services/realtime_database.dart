import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabase {
  FirebaseDatabase databaseInstance = FirebaseDatabase.instance;

  getSchoolTemperature() {
    final userReference = databaseInstance.reference().child("temperature");
    userReference.once().then((DataSnapshot dataSnapshot) {
      print(dataSnapshot.value);

      return dataSnapshot.value.toString();
    });
  }

  getSchoolHumidity() {
    final userReference = databaseInstance.reference().child("humidity");
    userReference.once().then((DataSnapshot dataSnapshot) {
      print(dataSnapshot.value);

      return dataSnapshot.value.toString();
    });
  }
}
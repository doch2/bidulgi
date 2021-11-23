import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabase {
  FirebaseDatabase databaseInstance = FirebaseDatabase.instance;

  getSchoolTemperature() async {
    DatabaseReference reference = databaseInstance.reference().child("temperature");

    return (await reference.get()).value.toString();
  }

  getSchoolHumidity() async {
    DatabaseReference reference = databaseInstance.reference().child("humidity");

    return (await reference.get()).value.toString();
  }
}
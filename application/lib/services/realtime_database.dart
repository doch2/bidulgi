import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabase {
  FirebaseDatabase databaseInstance = FirebaseDatabase.instance;

  getSchoolTemperature() async {
    DatabaseReference reference = databaseInstance.reference().child("temperature");

    return (await reference.get()).value.toString();
  }

  getLedOnOff() async {
    DatabaseReference reference = databaseInstance.reference().child("led");

    return (await reference.get()).value;
  }

  setLedOnOff(bool ledStatus) async {
    DatabaseReference reference = databaseInstance.reference();

    reference.update(
      {
        "led": ledStatus,
      }
    );
  }

  getSoundOnOff() async {
    DatabaseReference reference = databaseInstance.reference().child("sound");

    return (await reference.get()).value;
  }

  setSoundOnOff(bool soundStatus) async {
    DatabaseReference reference = databaseInstance.reference();

    reference.update(
        {
          "sound": soundStatus,
        }
    );
  }

  registerCctvChangeListener() async {
    databaseInstance.reference().child("led").onChildChanged.listen(
            (event) {
              print(event.snapshot.value);
            }
    );
  }

  getCctvLastUpdateDate() async {
    DatabaseReference reference = databaseInstance.reference().child("cctvLastUpdate");

    return (await reference.get()).value.toString();
  }
}
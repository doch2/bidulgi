import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabase {
  FirebaseDatabase databaseInstance = FirebaseDatabase.instance;

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

  getSoundTime() async {
    DatabaseReference reference = databaseInstance.reference().child("soundTime");

    return (await reference.get()).value;
  }

  setSoundTime(int time) async {
    DatabaseReference reference = databaseInstance.reference();

    reference.update(
        {
          "soundTime": time,
        }
    );
  }

  getHasThief() async {
    DatabaseReference reference = databaseInstance.reference().child("hasThief");

    return (await reference.get()).value;
  }

  sendMessage(String content) async {
    DatabaseReference reference = databaseInstance.reference();

    reference.update(
        {
          "lcdMessage": content,
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
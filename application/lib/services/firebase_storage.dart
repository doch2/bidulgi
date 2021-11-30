import 'package:firebase_storage/firebase_storage.dart' as FirebaseStorageAPI;

class FirebaseStorage {
  getImageUrl(String date) async {
    final ref = FirebaseStorageAPI.FirebaseStorage.instance.ref().child('cctv/capture/$date.jpg');
    String result = await ref.getDownloadURL();

    return result;
  }
}
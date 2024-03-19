
import 'package:cloud_firestore/cloud_firestore.dart';

import '../login_page.dart';
import 'check_user.dart';

var nameChk = username;
var nameLogin = name;

class DatabaseMethods {
  static Future<void> addWork(String category, String workName, String workDesc) async {
    try {
      // Determine the collection name
      String collectionName = nameLogin ?? nameChk;

      // Get a reference to the document
      DocumentReference docRef = FirebaseFirestore.instance.collection(collectionName).doc(category);

      // Check if the document already exists
      DocumentSnapshot doc = await docRef.get();

      if (doc.exists) {
        // Document exists, update it by adding a new field
        await docRef.update({workName: workDesc});
      } else {
        // Document doesn't exist, create it with the specified data
        await docRef.set({workName: workDesc});
      }

      print("Work added successfully!");
    } catch (error) {
      // Handle errors
      print("Error adding work: $error");
      throw error; // Rethrow the error to handle it in the calling code
    }
  }
}

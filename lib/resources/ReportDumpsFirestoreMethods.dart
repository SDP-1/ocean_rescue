// services/report_dumps_firestore_methods.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/reportdump.dart';

class ReportDumpsFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Method to upload image and get the download URL
  Future<String> uploadImageToStorage(String id, File imageFile) async {
    Reference ref = _storage.ref().child('report_dumps').child(id);
    UploadTask uploadTask = ref.putFile(imageFile);

    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Method to save a dump report
  Future<void> saveReportDump(ReportDump reportDump) async {
    try {
      // Create a map from the reportDump object
      Map<String, dynamic> data = reportDump.toJson(); // Use toJson instead of toMap

      // Add a timestamp field
      data['timestamp'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('report_dumps')
          .doc(reportDump.id)
          .set(data);
    } catch (e) {
      print('Failed to save dump report: $e');
    }
  }

  // Method to fetch all dump reports
  Future<List<ReportDump>> fetchAllDumpReports() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('report_dumps').get();
      return querySnapshot.docs.map((doc) => ReportDump.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Failed to fetch dump reports: $e');
      return [];
    }
  }
}

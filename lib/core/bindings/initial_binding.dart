import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Firebase services
    Get.put(FirebaseAuth.instance, permanent: true);
    Get.put(FirebaseFirestore.instance, permanent: true);
    
    // Add other global dependencies here
  }
} 
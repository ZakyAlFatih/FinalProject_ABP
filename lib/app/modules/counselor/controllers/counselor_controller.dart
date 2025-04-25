import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CounselorController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables for counselor details
  var counselorData = {}.obs;
  var showRatingPage = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Toggle between profile and rating view
  void toggleView() {
    showRatingPage.value = !showRatingPage.value;
  }

  // Fetch counselor data from Firestore
  Future<void> fetchCounselorData(String id) async {
    try {
      String counselorId = id; // Replace with a dynamic or passed ID
      DocumentSnapshot counselorDoc =
          await _firestore.collection('counselors').doc(counselorId).get();

      if (counselorDoc.exists) {
        counselorData.value = counselorDoc.data() as Map<String, dynamic>;
        print('Counselor data fetched successfully: ${counselorData.value}');
      } else {
        print('No counselor found for the given ID.');
      }
    } catch (e) {
      print('Error fetching counselor data: $e');
    }
  }
}

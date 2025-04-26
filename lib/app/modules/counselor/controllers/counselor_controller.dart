import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CounselorController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var counselorData = {}.obs;
  var schedules = [].obs;
  var selectedScheduleId = ''.obs;
  var showRatingPage = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Toggle antara tampilan profil dan rating
  void toggleView() {
    showRatingPage.value = !showRatingPage.value;
  }

  // Ambil data counselor berdasarkan UID
  Future<void> fetchCounselorData(String counselorUid) async {
    try {
      final querySnapshot = await _firestore
          .collection('counselors')
          .where('uid', isEqualTo: counselorUid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        counselorData.value = querySnapshot.docs.first.data();
      } else {
        print('Counselor dengan UID tersebut tidak ditemukan.');
      }
    } catch (e) {
      print('Error mengambil data counselor: $e');
    }
  }

  // Fetch jadwal dari koleksi schedules berdasarkan counselorId dan sesuaikan dengan counselors
  Future<void> fetchSchedules(String counselorUid) async {
    try {
      final counselorSnapshot = await _firestore
          .collection('counselors')
          .where('uid', isEqualTo: counselorUid)
          .get();

      if (counselorSnapshot.docs.isEmpty) {
        print('Counselor tidak ditemukan.');
        return;
      }

      final counselorData = counselorSnapshot.docs.first.data();

      // Ambil `scheduleIdX` dari counselor dan gunakan untuk fetch data dari `schedules`
      List<String> scheduleIds = [
        counselorData['scheduleId1'] ?? '',
        counselorData['scheduleId2'] ?? '',
        counselorData['scheduleId3'] ?? ''
      ].where((id) => id.isNotEmpty).toList().cast<String>(); // Perbaikan casting

      if (scheduleIds.isEmpty) {
        print('Tidak ada jadwal yang tersedia.');
        schedules.clear();
        return;
      }

      final schedulesSnapshot = await _firestore.collection('schedules')
          .where('scheduleId', whereIn: scheduleIds)
          .get();

      schedules.assignAll(schedulesSnapshot.docs.map((doc) {
        final data = doc.data();
        final scheduleId = data['scheduleId'];
        final counselorId = data['counselorId'];
        final isBooked = data['isBooked'] ?? false;

        // Menampilkan jadwal dari counselor berdasarkan `scheduleIdX`
        String adjustedDay = '';
        String adjustedTime = '';

        if (scheduleId == counselorData['scheduleId1']) {
          adjustedDay = counselorData['availability_day1'] ?? '';
          adjustedTime = counselorData['availability_time1'] ?? '';
        } else if (scheduleId == counselorData['scheduleId2']) {
          adjustedDay = counselorData['availability_day2'] ?? '';
          adjustedTime = counselorData['availability_time2'] ?? '';
        } else if (scheduleId == counselorData['scheduleId3']) {
          adjustedDay = counselorData['availability_day3'] ?? '';
          adjustedTime = counselorData['availability_time3'] ?? '';
        }

        return {
          'id': scheduleId,
          'counselorId': counselorId,
          'day': adjustedDay,
          'time': adjustedTime,
          'isBooked': isBooked,
        };
      }).toList());
    } catch (e) {
      print('Error mengambil jadwal: $e');
    }
  }

  // Booking jadwal oleh user
  Future<void> bookSchedule(String scheduleId, String counselorUid) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final scheduleRef = _firestore.collection('schedules').doc(scheduleId);
    final scheduleSnap = await scheduleRef.get();

    if (!scheduleSnap.exists || scheduleSnap['isBooked'] == true) {
      Get.snackbar('Booking gagal', 'Jadwal tidak tersedia atau sudah dibooking.');
      return;
    }

    final counselorSnap = await _firestore.collection('counselors')
        .where('uid', isEqualTo: counselorUid)
        .get();
    final userSnap = await _firestore.collection('users').doc(user.uid).get();

    if (counselorSnap.docs.isEmpty || !userSnap.exists) return;

    final counselorName = counselorSnap.docs.first.data()['name'];
    final userName = userSnap['name'];

    // Buat dokumen booking
    await _firestore.collection('bookings').add({
      'scheduleId': scheduleId,
      'counselorId': counselorUid, // Simpan UID sebagai referensi counselor
      'counselorName': counselorName,
      'userId': user.uid,
      'userName': userName,
      'status': 'booked',
      'createdAt': Timestamp.now(),
    });

    // Tandai jadwal sebagai sudah dibooking
    await scheduleRef.update({'isBooked': true});

    selectedScheduleId.value = scheduleId;
    fetchSchedules(counselorUid); // Refresh jadwal

    Get.snackbar('Berhasil', 'Jadwal berhasil dibooking');
  }
}
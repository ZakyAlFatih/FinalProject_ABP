import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CounselorController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable variables for counselor details and schedules
  var counselorData = {}.obs;
  var schedules = [].obs;
  var selectedScheduleId = ''.obs;
  var showRatingPage = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // 🔄 **Toggle antara tampilan profil dan rating**
  void toggleView() {
    showRatingPage.value = !showRatingPage.value;
  }

  // 🔍 **Fetch data counselor berdasarkan UID**
  Future<void> fetchCounselorData(String counselorUid) async {
    try {
      final querySnapshot = await _firestore.collection('counselors')
          .where('uid', isEqualTo: counselorUid) // 🔥 Cari berdasarkan UID
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

  // 📅 **Fetch jadwal counselor berdasarkan UID**
  Future<void> fetchSchedules(String counselorUid) async {
    try {
      final result = await _firestore.collection('schedules')
          .where('counselorId', isEqualTo: counselorUid) // 🔥 Cari berdasarkan UID
          .get();

      schedules.assignAll(result.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'day': data['day'],
          'time': data['time'],
          'isBooked': data['isBooked'] ?? false,
        };
      }).toList());
    } catch (e) {
      print('Error mengambil jadwal: $e');
    }
  }

  // 🎯 **Booking jadwal oleh user**
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

    // 🔥 **Buat dokumen booking**
    await _firestore.collection('bookings').add({
      'scheduleId': scheduleId,
      'counselorId': counselorUid, // 🔥 Simpan UID sebagai referensi counselor
      'counselorName': counselorName,
      'userId': user.uid,
      'userName': userName,
      'status': 'booked',
      'createdAt': Timestamp.now(),
    });

    // 🔥 **Tandai jadwal sebagai sudah dibooking**
    await scheduleRef.update({'isBooked': true});

    selectedScheduleId.value = scheduleId;
    fetchSchedules(counselorUid); // Refresh jadwal

    Get.snackbar('Berhasil', 'Jadwal berhasil dibooking');
  }

  // ❌ **Fungsi untuk membatalkan booking jika user ingin mengubah jadwal**
  Future<void> unbookSchedule(String scheduleId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final bookingSnap = await _firestore.collection('bookings')
        .where('scheduleId', isEqualTo: scheduleId)
        .where('userId', isEqualTo: user.uid)
        .get();

    if (bookingSnap.docs.isEmpty) {
      Get.snackbar('Gagal', 'Tidak ada booking ditemukan untuk jadwal ini.');
      return;
    }

    await _firestore.collection('bookings').doc(bookingSnap.docs.first.id).delete();
    await _firestore.collection('schedules').doc(scheduleId).update({'isBooked': false});

    fetchSchedules(bookingSnap.docs.first.data()['counselorId']); // Refresh jadwal

    Get.snackbar('Berhasil', 'Booking dibatalkan');
  }
}
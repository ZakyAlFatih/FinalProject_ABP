import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Model untuk menyimpan data riwayat booking
class HistoryEntry {
  final String userId;
  final String counselorId;
  final String counselorName;
  final String counselorBidang;
  final String scheduleId;
  final String day;
  final String time;
  final String status;

  HistoryEntry({
    required this.userId,
    required this.counselorId,
    required this.counselorName,
    required this.counselorBidang,
    required this.scheduleId,
    required this.day,
    required this.time,
    required this.status,
  });

  factory HistoryEntry.fromFirestore(
      Map<String, dynamic> bookingData,
      Map<String, dynamic>? counselorData) {
    
    // Debug: Cek apakah counselorData berhasil diambil
    print("Counselor data ditemukan: $counselorData");

    String day = 'Tidak tersedia';
    String time = 'Tidak tersedia';

    // Debug: Cek scheduleId dari booking dan counselor
    print("ScheduleId dari booking: ${bookingData['scheduleId']}");
    print("ScheduleId1 dari counselor: ${counselorData?['scheduleId1']}");
    print("ScheduleId2 dari counselor: ${counselorData?['scheduleId2']}");
    print("ScheduleId3 dari counselor: ${counselorData?['scheduleId3']}");

    if (bookingData['scheduleId'] == counselorData?['scheduleId1']) {
      day = counselorData?['availability_day1'] ?? 'Tidak tersedia';
      time = counselorData?['availability_time1'] ?? 'Tidak tersedia';
    } else if (bookingData['scheduleId'] == counselorData?['scheduleId2']) {
      day = counselorData?['availability_day2'] ?? 'Tidak tersedia';
      time = counselorData?['availability_time2'] ?? 'Tidak tersedia';
    } else if (bookingData['scheduleId'] == counselorData?['scheduleId3']) {
      day = counselorData?['availability_day3'] ?? 'Tidak tersedia';
      time = counselorData?['availability_time3'] ?? 'Tidak tersedia';
    }

    return HistoryEntry(
      userId: bookingData['userId'] ?? '',
      counselorId: bookingData['counselorId'] ?? '',
      counselorName: counselorData?['name'] ?? 'Tidak diketahui',
      counselorBidang: counselorData?['bidang'] ?? 'Tidak diketahui',
      scheduleId: bookingData['scheduleId'] ?? '',
      day: day,
      time: time,
      status: bookingData['status'] ?? 'booked',
    );
  }
}

class HistoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable list untuk menyimpan history booking
  var bookingHistory = <HistoryEntry>[].obs;
  var isFetching = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookingHistory();
  }

  // Ambil riwayat booking berdasarkan `userId`, lalu ambil data `counselorId` dari `counselors`
  Future<void> fetchBookingHistory() async {
    try {
      isFetching.value = true; // Tandai bahwa data sedang diambil

      String userId = _auth.currentUser!.uid;
      print("Fetching booking history from collection `history` for userId: $userId");

      final historySnapshot = await _firestore.collection('history')
          .where('userId', isEqualTo: userId)
          .get();

      List<HistoryEntry> historyEntries = [];

      for (var historyDoc in historySnapshot.docs) {
        final historyData = historyDoc.data();
        final counselorId = historyData['counselorId'] ?? '';

        Map<String, dynamic>? counselorData;

        // Ambil bidang counselor berdasarkan `counselorId`
        if (counselorId.isNotEmpty) {
          final counselorSnapshot = await _firestore.collection('counselors')
              .doc(counselorId)
              .get();

          if (counselorSnapshot.exists) {
            counselorData = counselorSnapshot.data();
          }
        }

        // Debug: Cek counselorId dan data yang didapat
        print("CounselorId: $counselorId");
        print("Data counselor: $counselorData");

        // Tambahkan entry ke list riwayat dari koleksi `history`
        var historyEntry = HistoryEntry(
          userId: historyData['userId'] ?? '',
          counselorId: historyData['counselorId'] ?? '',
          counselorName: counselorData?['name'] ?? 'Tidak diketahui',
          counselorBidang: counselorData?['bidang'] ?? 'Tidak diketahui',
          scheduleId: historyData['bookingId'] ?? '',
          day: historyData['day'] ?? 'Tidak tersedia',
          time: historyData['time'] ?? 'Tidak tersedia',
          status: 'completed', // History selalu dari sesi yang selesai
        );

        print("Riwayat booking ditambahkan: ${historyEntry.counselorName}, ${historyEntry.day}, ${historyEntry.time}");
        historyEntries.add(historyEntry);
      }

      bookingHistory.assignAll(historyEntries);
      print("Total history found: ${bookingHistory.length}");

    } catch (e) {
      print('Error mengambil riwayat booking dari `history`: $e');

    } finally {
      isFetching.value = false; // Tandai bahwa proses fetching selesai
    }
  }

  // Hapus semua riwayat booking dari list (tanpa menghapus data dari Firestore)
  void clearHistory() {
    bookingHistory.clear();
  }
}
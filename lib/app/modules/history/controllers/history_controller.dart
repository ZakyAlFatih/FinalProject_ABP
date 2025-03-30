import 'package:get/get.dart';

class HistoryController extends GetxController {
  //TODO: Implement HistoryController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // Observable list for ordered history data
  var orderedHistory = <Map<String, String>>[
    {
      'name': 'Hasna S.Psi',
      'days': 'Kamis', // Thursday
    },
    {
      'name': 'Adi S.Psi',
      'days': 'Senin-Rabu', // Monday to Wednesday
    },
  ].obs;

  //
  var toogleTestHistory = true.obs;

  // // Function to add a new entry to the history
  // void addHistory(String name, String days) {
  //   orderedHistory.add({'name': name, 'days': days});
  // }

  // Function to clear all history
  void clearHistory() {
    orderedHistory.clear();
  }
}

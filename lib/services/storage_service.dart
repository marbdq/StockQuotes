import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class StorageService extends GetxService {
  GetStorage _store = GetStorage('quotes');
  List<String> quotes = [];

  loadData() {
    print('loadData called');
    String jsonString = _store.read('quotes') ?? json.encode(['gaa']);
    quotes = List<String>.from(json.decode(jsonString));
  }

  saveData() {
    print('saveData called');
    String jsonString = json.encode(quotes);
    _store.write('quotes', jsonString);
  }
}

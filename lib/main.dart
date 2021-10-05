import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';

void main() async {
  await initServices();
  runApp(MyApp());
}

initServices() async {
  await GetStorage.init('quotes');
  Get.put(ApiService());
  Get.put(StorageService());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'StockQuotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

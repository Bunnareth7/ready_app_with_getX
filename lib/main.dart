import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/data/providers/api_client.dart';
import 'app/data/providers/api_service.dart';
import 'app/data/providers/mqtt_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  Get.put<ApiClient>(ApiClient(), permanent: true);
  Get.put<ApiService>(ApiService(), permanent: true);

  Get.put<MqttService>(MqttService(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MONAKOM',
      theme: ThemeData(useMaterial3: true),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/providers/api_service.dart';
import '../../../data/providers/mqtt_service.dart';
import '../../../core/results/result.dart';

class CompanySelectionController extends GetxController {
  final GetStorage _storage = GetStorage();
  final ApiService _apiService = Get.find<ApiService>();
  final MqttService _mqttService = Get.find<MqttService>();

  var selectedCompany = ''.obs;
  var selectedTerminal = ''.obs;
  var companies = <String>[].obs;
  var terminals = <String>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isButtonEnabled = false.obs;

  List<dynamic> _terminalItems = [];

  // Extract label for readable display
  String _extractLabel(dynamic item, List<String> preferredKeys) {
    if (item is String) return item;

    if (item is Map) {
      for (final key in preferredKeys) {
        final value = item[key];
        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      }
    }

    return item.toString();
  }

  @override
  void onInit() {
    super.onInit();
    final token = _storage.read('access_token');
    if (token == null || token.isEmpty) {
      Get.offAllNamed('/login');
      return;
    }
    loadCompanies();
  }

  Future<void> loadCompanies() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _apiService.getCompanies();

      switch (result) {
        case Success():
          final dynamic data = result.data;
          print('Companies response: $data');

          List<String> companyList = [];

          if (data is Map<String, dynamic> && data['data'] is List) {
            final list = data['data'] as List;
            companyList = list
                .map(
                  (e) =>
                      _extractLabel(e, ['companyCode', 'name', 'code', 'id']),
                )
                .toList();
          }

          if (companyList.isNotEmpty) {
            companies.value = companyList;
            print('Companies loaded: ${companies.length}');
          } else {
            companies.value = ['KOI_CAMBODIA_NEW,fail'];
          }
          break;

        case Failure():
          companies.value = ['KOI_CAMBODIA_NEW'];
          break;
      }
    } catch (e) {
      companies.value = ['KOI_CAMBODIA_NEW'];
      print('Error loading companies: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTerminals() async {
    if (selectedCompany.value.isEmpty) return;

    isLoading.value = true;
    errorMessage.value = '';
    terminals.clear();
    _terminalItems = [];

    try {
      final result = await _apiService.getTerminals(selectedCompany.value);

      switch (result) {
        case Success():
          final dynamic data = result.data;
          print('Terminals response: $data');

          List<String> terminalList = [];
          List<dynamic> rawItems = [];

          if (data is Map<String, dynamic> && data['data'] is List) {
            final list = data['data'] as List;
            rawItems = list;
            terminalList = list
                .map((e) => _extractLabel(e, ['terminalName']))
                .toList();
          }

          if (terminalList.isNotEmpty) {
            terminals.value = terminalList;
            _terminalItems = rawItems;
            print('Terminals loaded: ${terminals.length}');
          } else {
            terminals.value = ['CXDemoKOI1', 'DEMOCAMBODIA'];
            _terminalItems = [];
          }
          break;

        case Failure():
          terminals.value = ['CXDemoKOI1', 'DEMOCAMBODIA'];
          _terminalItems = [];
          break;
      }
    } catch (e) {
      terminals.value = ['CXDemoKOI1', 'DEMOCAMBODIA'];
      _terminalItems = [];
      print('Error loading terminals: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCompany(String? company) {
    if (company != null) {
      selectedCompany.value = company;
      terminals.clear();
      selectedTerminal.value = '';
      _updateButtonState();
      loadTerminals();
    }
  }

  void selectTerminal(String? terminal) {
    if (terminal != null) {
      selectedTerminal.value = terminal;
      _updateButtonState();
    }
  }

  void _updateButtonState() {
    isButtonEnabled.value =
        selectedCompany.isNotEmpty && selectedTerminal.isNotEmpty;
  }

  dynamic _findSelectedTerminalItem() {
    final index = terminals.indexOf(selectedTerminal.value);
    if (index == -1 || index >= _terminalItems.length) return null;
    return _terminalItems[index];
  }

  Future<void> connect() async {
    if (!isButtonEnabled.value) return;

    final selectedItem = _findSelectedTerminalItem();
    final storeName = selectedItem is Map
        ? _extractLabel(selectedItem, ['storeName'])
        : '';

    _storage.write('company', selectedCompany.value);
    _storage.write('terminalId', selectedTerminal.value);
    _storage.write('storeName', storeName);

    // Wait for MQTT to actually connect before navigating, so Home doesn't
    // try to subscribe while still mid-handshake.
    await _mqttService.connect(terminalId: selectedTerminal.value);

    Get.snackbar(
      'Success',
      'Connected to  ${selectedTerminal.value}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.offAllNamed('/home');
  }
}
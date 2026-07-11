import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_selection_controller.dart';

class CompanySelectionView extends GetView<CompanySelectionController> {
  const CompanySelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    // Register controller if not already registered
    if (!Get.isRegistered<CompanySelectionController>()) {
      Get.put<CompanySelectionController>(CompanySelectionController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              _buildImageContainer(),

              const SizedBox(height: 10),

              _buildCompanyDropdown(),

              const SizedBox(height: 20),

              _buildTerminalDropdown(),

              const SizedBox(height: 24),

              _buildConnectButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(color: Colors.white),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/TERMINAL.png',
              fit: BoxFit.cover,
              width: 150,
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported,
                  size: 80,
                  color: Colors.grey,
                );
              },
            ),
            const Text(
              'Select Your Company',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              'Please Select Your Company',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCompanyDropdown() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedCompany.value.isNotEmpty
                ? controller.selectedCompany.value
                : null,
            hint: const Text(
              'Select your company',
              style: TextStyle(color: Colors.grey),
            ),
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            items: controller.companies.map((company) {
              return DropdownMenuItem<String>(
                value: company,
                child: Text(company),
              );
            }).toList(),
            onChanged: controller.selectCompany,
          ),
        ),
      );
    });
  }

  Widget _buildTerminalDropdown() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedTerminal.value.isNotEmpty
                ? controller.selectedTerminal.value
                : null,
            hint: const Text(
              'Select your terminal',
              style: TextStyle(color: Colors.grey),
            ),
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            items: controller.terminals.map((terminal) {
              return DropdownMenuItem<String>(
                value: terminal,
                child: Text(terminal),
              );
            }).toList(),
            onChanged: controller.selectTerminal,
          ),
        ),
      );
    });
  }

  Widget _buildConnectButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: controller.isButtonEnabled.value
              ? controller.connect
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: Colors.grey[300],
          ),
          child: Text(
            'Connect to your terminal',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

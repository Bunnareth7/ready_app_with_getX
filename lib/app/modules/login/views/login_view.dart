// login_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              child: Center(
                child: Column(
                  children: [
                    // Image
                    SizedBox(
                      height: 150,
                      width: 300,
                      child: Image.network(
                        "https://img.magnific.com/free-vector/people-line-waiting-pay_23-2148199795.jpg?semt=ais_hybrid&w=740&q=80",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error, size: 50),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Welcome to Queue System",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Login your cloud account",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),

                    // Error Message
                    Obx(() {
                      if (controller.errorMessage.value.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(
                              controller.errorMessage.value,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    const SizedBox(height: 10),

                    // Username
                    Padding(
                     padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFecf0f1)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: TextField(
                                  controller: controller.usernameController,
                                  decoration: const InputDecoration(
                                    hintText: "Username",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),

                    // Password Field
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFecf0f1)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: TextField(
                                  controller: controller.passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 360),

                    // Login Button
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Obx(
                        () => InkWell(
                         onTap: controller.isLoading.value ? null : controller.login,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: controller.isLoading.value
                                  ? Colors.grey
                                  : const Color(0xFF055FC8),
                            ),
                            child: Center(
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Powered by Monakom",
                  style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                ),
                SizedBox(
                    width: 100,
                    height: 30,
                    child: Image.network(
                      "https://media.licdn.com/dms/image/v2/D560BAQF9R5z5OVKP2Q/company-logo_200_200/B56ZmUKgYmIAAI-/0/1759127407018?e=2147483647&v=beta&t=WBpVcZ7UUkjsWjcbzX5JxN56lBqCyKGJTP748D9hg0M",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.business, size: 30),
                        );
                      },
                    ),
                  
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

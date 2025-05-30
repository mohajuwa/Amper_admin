// lib/modules/auth/screens/login_screen.dart
import "package:ecom_modwir/modules/auth/controllers/auth_controller.dart";
import "package:ecom_modwir/widgets/custom_button.dart";
import "package:ecom_modwir/widgets/custom_text_field.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ecom_modwir/constants.dart";

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding * 2),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultPadding),
              ),
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding * 2),
                child: Form(
                  key: authController.loginFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo or Title
                      Icon(
                        Icons.admin_panel_settings,
                        size: 60,
                        color: primaryColor,
                      ),
                      const SizedBox(height: defaultPadding),
                      Text(
                        "admin_panel_login".tr, // Add this translation key
                        style: Get.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: defaultPadding * 2),

                      // Email Field
                      CustomTextField(
                        controller: authController.emailController,
                        label: "email".tr,
                        hint: "enter_your_email".tr, // Add this translation key
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(Icons.email_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "email_required".tr;
                          }
                          if (!GetUtils.isEmail(value)) {
                            return "invalid_email_format".tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: defaultPadding),

                      // Password Field
                      CustomTextField(
                        controller: authController.passwordController,
                        label: "password".tr,
                        hint: "enter_your_password"
                            .tr, // Add this translation key
                        prefixIcon: Icon(Icons.lock_outline),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "password_required".tr;
                          }
                          // Add more password validation if needed
                          return null;
                        },
                      ),
                      const SizedBox(height: defaultPadding * 2),

                      // Login Button
                      Obx(() => CustomButton(
                            text: authController.isLoading.value
                                ? "please_wait".tr
                                : "login".tr,
                            onPressed: authController.isLoading.value
                                ? null
                                : () => authController.login(),
                            isLoading: authController.isLoading.value,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Add missing translations to app_translations.dart:
// 'admin_panel_login': 'Admin Panel Login',
// 'enter_your_email': 'Enter your email',
// 'enter_your_password': 'Enter your password',


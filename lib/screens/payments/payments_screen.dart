import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/constants.dart';
import 'package:ecom_modwir/screens/dashboard/components/header.dart';

class PaymentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),
            Center(
              child: Text(
                "payments".tr,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: defaultPadding),
            Container(
              padding: const EdgeInsets.all(defaultPadding * 2),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                "Payments management page - To be implemented",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

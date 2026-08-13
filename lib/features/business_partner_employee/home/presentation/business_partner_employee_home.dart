import 'package:flutter/material.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_home/presentation/business_partner_home_screen.dart';

class BusinessPartnerEmployeeHome extends StatelessWidget {
  final VoidCallback? onProfileTapped;

  const BusinessPartnerEmployeeHome({super.key, this.onProfileTapped});

  @override
  Widget build(BuildContext context) {
    return const BusinessPartnerHomeScreen();
  }
}

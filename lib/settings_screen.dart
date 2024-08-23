// import 'package:admin/responsive.dart';
// import 'package:admin/screens/dashboard/components/my_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/responsive.dart';

// import '../../constants.dart';
// import 'components/header.dart';
//
// import 'components/recent_files.dart';
// import 'components/storage_details.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(title: 'Settings'),
        // const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              flex: 5,
              child: Column(
                children: [
                  // PartyForm(),
                  // MyFiles(),
                  // const SizedBox(height: 16),
                  // RecentFiles(),
                  // if (Responsive.isMobile(context)) const SizedBox(height: 16),
                  // if (Responsive.isMobile(context)) StorageDetails(),
                ],
              ),
            ),
            if (!Responsive.isMobile(context)) const SizedBox(width: 16),
            // On Mobile means if the screen is less than 850 we don't want to show it
            if (!Responsive.isMobile(context))
              const Expanded(
                  flex: 2,
                  // child: StorageDetails(),
                  child: Column(children: [],)),
          ],
        )
      ],
    );
  }
}

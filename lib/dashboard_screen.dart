// import 'package:admin/responsive.dart';
// import 'package:admin/screens/dashboard/components/my_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/menu_app_controller.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/responsive.dart';

// import '../../constants.dart';
// import 'components/header.dart';
//
// import 'components/recent_files.dart';
// import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MenuAppController menuController = Get.find<MenuAppController>();
    return Column(
      children: [
        const Header(title: 'Dashboard'),
        // const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            menuController.selectedIndex.value = 2;
                          },
                          icon: const Icon(
                            Icons.people_alt_sharp,
                            size: 24, // Size of the icon
                            color: Colors.blue,
                          ),
                          label: const Text(
                            'Party',
                            style: TextStyle(
                              fontSize: 16, // Font size of the text
                              color: Colors.blue,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              side: const BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                        ),
                        const SizedBox(width: 15,),
                        OutlinedButton.icon(
                          onPressed: () {
                            menuController.selectedIndex.value = 1;
                            // Add navigation or action here
                          },
                          icon: const Icon(
                            Icons.shopping_bag,
                            size: 24, // Size of the icon
                            color: Colors.blue,
                          ),
                          label: const Text(
                            'Purchase',
                            style: TextStyle(
                              fontSize: 16, // Font size of the text
                              color: Colors.blue,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              side: const BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                        ),
                        const SizedBox(width: 15,),
                        OutlinedButton.icon(
                          onPressed: () {
                            menuController.selectedIndex.value = 3;
                          },
                          icon: const Icon(
                            Icons.sell,
                            size: 24, // Size of the icon
                            color: Colors.blue,
                          ),
                          label: const Text(
                            'Sale',
                            style: TextStyle(
                              fontSize: 16, // Font size of the text
                              color: Colors.blue,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              side: const BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                        ),
                        // OutlinedButton.icon(
                        //   onPressed: () {
                        //     // Add navigation or action here
                        //   },
                        //   icon: const Icon(
                        //     Icons.people_alt_sharp,
                        //     size: 24, // Size of the icon
                        //     color: Colors.blue,
                        //   ),
                        //   label: const Text(
                        //     'Party',
                        //     style: TextStyle(
                        //       fontSize: 16, // Font size of the text
                        //       color: Colors.blue,
                        //     ),
                        //   ),
                        //   style: OutlinedButton.styleFrom(
                        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        //       side: const BorderSide(color: Colors.blue),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8),
                        //       )),
                        // ),
                        // OutlinedButton.icon(
                        //   onPressed: () {
                        //     // Add navigation or action here
                        //   },
                        //   icon: const Icon(
                        //     Icons.people_alt_sharp,
                        //     size: 24, // Size of the icon
                        //     color: Colors.blue,
                        //   ),
                        //   label: const Text(
                        //     'Party',
                        //     style: TextStyle(
                        //       fontSize: 16, // Font size of the text
                        //       color: Colors.blue,
                        //     ),
                        //   ),
                        //   style: OutlinedButton.styleFrom(
                        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        //       side: const BorderSide(color: Colors.blue),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8),
                        //       )),
                        // ),
                      ],
                    ),
                  ),

                  // GridView.builder(
                  //     gridDelegate:
                  //         const SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: 3, // Number of columns
                  //       crossAxisSpacing: 10.0, // Space between columns
                  //       mainAxisSpacing: 10.0, // Space between rows
                  //       childAspectRatio: 1, // Aspect ratio of each item
                  //     ),
                  //     itemCount: 6,
                  //     itemBuilder: (context, index) {
                  //       return IconButton(
                  //         onPressed: () {},
                  //         icon: const Icon(Icons.file_copy_outlined),
                  //       );
                  //     })
                  // GridTileBar(title: Text('Forms'),)
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
                  child: Column(
                    children: [],
                  )),
          ],
        )
      ],
    );
  }
}

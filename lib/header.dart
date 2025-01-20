// import 'package:admin/controllers/menu_app_controller.dart';
// import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';

// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../../../constants.dart';
import 'responsive.dart';

class Header extends StatelessWidget {
  final String title;

  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          const IconButton(
            icon: Icon(Icons.menu),
            onPressed: null,
            // onPressed: menuController.controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        const Expanded(child: SearchField()),
        const ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        // color: Colors.blue,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey),
      ),
      child: GestureDetector(
        onTap: () {
          _showProfileOptionsDialog(context);
        },
        child: Row(
          children: [
            Image.asset(
              "assets/images/profile_pic.png",
              height: 20,
            ),
            if (!Responsive.isMobile(context))
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: defaultController.companyCode.value == 0
                      ? const Text('Real Software')
                      : Text(
                          getCompanyName(defaultController.companyCode.value)),
                ),
              ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileOptionsDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  // color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getCompanyName(defaultController.companyCode.value),
                      style: const TextStyle(
                          // color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      getCompanyDetails(defaultController.companyCode.value)
                          .mobileno!,
                      style: const TextStyle(
                          // color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
                width: 300,
                child: Text(
                  getCompanyDetails(defaultController.companyCode.value)
                      .address!,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 12),
                )),
            const Divider(),
            // const CompanySelectionDialog(
            //   isSwitchCompany: true,
            // ),
            // const Divider(),
            OutlinedButton(
              onPressed: () {
                // User has selected a company and now proceeds to the main screen
                _logout();
                Get.back();
              },
              child: const Text(
                "Logout",
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/'); // Redirect to your login screen
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      // controller: _codeController,
      keyboardType: TextInputType.number,
      // enabled: false,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.search),
        suffixIconConstraints:
            const BoxConstraints(maxHeight: 30, maxWidth: 30),
        suffixIcon:
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        hintText: "Search",
        // fillColor: Colors.blue,
        filled: true,
        errorStyle: const TextStyle(
          height: 0, // Hides the error message
          fontSize: 0, // Ensures no space is taken by the error message
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            // Red border when focused with an error
            width: 1.0, // Thin border width
          ),
          borderRadius: BorderRadius.circular(5), // Squared corners
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            // Red border for errors
            width: 1.0, // Thin border width
          ),
          borderRadius: BorderRadius.circular(5), // Squared corners
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
            // Black border when focused without error
            width: 1.0, // Thin border width
          ),
          borderRadius: BorderRadius.circular(5), // Squared corners
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            // Light grey border when enabled
            width: 1.0, // Thin border width
          ),
          borderRadius: BorderRadius.circular(5), // Squared corners
        ),

        // filled: true,
        // Fill the background
        fillColor: Colors.transparent,
        // White background
        isDense: true,
        // Reduces the overall height of the TextField
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ), // Remove top padding, minimal horizontal padding
      ),
      cursorColor: Colors.black,
      // Black cursor color
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12, // Consistent font size with label
      ),
      onChanged: (value) {},
    );
    // return TextField(
    //   decoration: InputDecoration(
    //     hintText: "Search",
    //     // fillColor: Colors.blue,
    //     filled: true,
    //     border: const OutlineInputBorder(
    //       borderSide: BorderSide.none,
    //       borderRadius: BorderRadius.all(Radius.circular(10)),
    //     ),
    //     suffixIcon: InkWell(
    //       onTap: () {},
    //       child: Container(
    //         padding: const EdgeInsets.all(10),
    //         // margin: const EdgeInsets.symmetric(horizontal: 16 / 3),
    //         decoration: const BoxDecoration(
    //           // color: Colors.orange,
    //           borderRadius: BorderRadius.all(Radius.circular(10)),
    //         ),
    //         child: SvgPicture.asset(
    //           "assets/icons/Search.svg",
    //           // color: Colors.blue,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

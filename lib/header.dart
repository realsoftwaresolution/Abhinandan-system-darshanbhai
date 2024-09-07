// import 'package:admin/controllers/menu_app_controller.dart';
// import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:provider/provider.dart';
import 'package:real_web_rough_entry_system/controllers/menu_app_controller.dart';

// import '../../../constants.dart';
import 'responsive.dart';

class Header extends StatelessWidget {
  final String title;

  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final MenuAppController menuController = Get.find<MenuAppController>();
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: menuController.controlMenu,
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
      child: Row(
        children: [
          Image.asset(
            "assets/images/profile_pic.png",
            height: 20,
          ),
          if (!Responsive.isMobile(context))
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text("Real Software"),
            ),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
          ),
        ],
      ),
    );
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
        suffixIconConstraints: const BoxConstraints( maxHeight: 30, maxWidth: 30),
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

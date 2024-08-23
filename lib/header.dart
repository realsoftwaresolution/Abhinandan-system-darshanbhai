// import 'package:admin/controllers/menu_app_controller.dart';
// import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16 / 2,
      ),
      decoration: BoxDecoration(
        // color: Colors.blue,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.black54),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/profile_pic.png",
            height: 30,
          ),
          if (!Responsive.isMobile(context))
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 / 2),
              child: Text("Angelina Jolie"),
            ),
          const Icon(Icons.keyboard_arrow_down),
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
      decoration: InputDecoration(
        hintText: "Search",
        // fillColor: Colors.blue,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(10),
            // margin: const EdgeInsets.symmetric(horizontal: 16 / 3),
            decoration: const BoxDecoration(
              // color: Colors.orange,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset(
              "assets/icons/Search.svg",
              // color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}

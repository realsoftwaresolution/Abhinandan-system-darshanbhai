import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? isLoggedIn = prefs.getBool('isLoggedIn');
      int? storedCompanyCode = prefs.getInt(
          'companyCode'); // Retrieve the company code from SharedPreferences

      if (storedCompanyCode == null || storedCompanyCode == 0 || !isLoggedIn!) {
        showLoginDialog();
      } else {
        defaultController.companyCode.value = storedCompanyCode;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/logo-white.svg",
              // color: Colors.white,
              height: 150, // Reduced logo size to fit smaller header
            ),
            const SizedBox(height: 20),
            const Text(
              'Real Software Solutions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

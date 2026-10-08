import 'package:flutter/material.dart';
import 'package:real_web_rough_entry_system/party/party_form.dart';

class PartyFormScreen extends StatelessWidget {
  final bool showHeader;
  const PartyFormScreen({super.key, required this.showHeader});

  @override
  Widget build(BuildContext context) {
    return PartyForm(showHeader: showHeader);
  }
}

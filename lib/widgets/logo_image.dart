import 'package:flutter/material.dart';

import '../r.dart';

class LogoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: Image.asset(Images.logo),
    );
  }
}

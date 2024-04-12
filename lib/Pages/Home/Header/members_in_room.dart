import 'package:flutter/material.dart';

class MembersPresent extends StatefulWidget {
  const MembersPresent({super.key});

  @override
  State<MembersPresent> createState() => _MembersPresentState();
}

class _MembersPresentState extends State<MembersPresent> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.05,
      width: width * 0.8,
      color: Colors.white,
    );
  }
}

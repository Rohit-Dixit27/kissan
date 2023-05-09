import 'package:flutter/material.dart';
class HomScreen extends StatefulWidget {
  const HomScreen({Key? key}) : super(key: key);

  @override
  State<HomScreen> createState() => _HomScreenState();
}

class _HomScreenState extends State<HomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("home"),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:keeper/widgets/drawer_menu.dart';
import 'package:keeper/widgets/main_app_bar.dart';

class ShowSecret extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: MainAppBar(),
      body: Text('TODO: show secret'),
    );
  }
}

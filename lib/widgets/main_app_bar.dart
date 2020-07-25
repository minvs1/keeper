import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(context) {
    return AppBar(
      centerTitle: true,
      title: Text('Keeper'),
    );
  }
}

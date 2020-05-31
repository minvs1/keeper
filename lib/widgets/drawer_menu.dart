import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeper/blocs/blocs.dart';

class DrawerMenu extends StatelessWidget {
  final secretController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Create Secret'),
            onTap: () {
              BlocProvider.of<RouterBloc>(context)
                  .router
                  .navigateTo(
                    context,
                    '/',
                    transition: TransitionType.fadeIn,
                  )
                  .then((value) => Navigator.pop(context));
            },
          ),
          ListTile(
            title: Text('Open Secret'),
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Open Secret"),
                    content: TextField(
                      controller: secretController,
                      cursorColor: theme.accentColor,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'Secret Unlock Key',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      FlatButton(
                        child: Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("Open"),
                        onPressed: () {
                          BlocProvider.of<RouterBloc>(context)
                              .router
                              .navigateTo(
                                context,
                                "/secrets/${secretController.value}",
                                transition: TransitionType.fadeIn,
                              )
                              .then((value) => Navigator.pop(context));
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

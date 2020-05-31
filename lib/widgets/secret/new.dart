import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeper/blocs/blocs.dart';
import 'package:keeper/models/models.dart';
import 'package:keeper/widgets/drawer_menu.dart';
import 'package:keeper/widgets/main_app_bar.dart';

class NewSecret extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        TextEditingController().clear();
      },
      child: Scaffold(
        drawer: DrawerMenu(),
        appBar: MainAppBar(),
        body: BlocListener<SecretBloc, SecretState>(
          listener: (context, state) {
            if (state is SecretSuccess) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Secret encrypted & saved!"),
                    content: SelectableText(
                      "Secret Unlock Key: ${state.secret.id}#${state.secret.password}",
                    ),
                    actions: [
                      FlatButton(
                        child: Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: BlocBuilder<SecretBloc, SecretState>(
            builder: (context, state) {
              if (state is SecretInProgress) {
                return Center(child: CircularProgressIndicator());
              }

              return SecretForm();
            },
          ),
        ),
      ),
    );
  }
}

class SecretForm extends StatelessWidget {
  final secretController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        margin: EdgeInsets.only(
          left: 15.0,
          top: 15.0,
          right: 15.0,
          bottom: 15.0, // Fix incorrectness
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: TextField(
                  controller: secretController,
                  keyboardType: TextInputType.multiline,
                  cursorColor: theme.accentColor,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Tell me a secret...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text('SHARE IT!'),
                      onPressed: () async {
                        if (secretController.text == "") {
                          return;
                        }

                        BlocProvider.of<SecretBloc>(context).add(
                          SecretEncrypted(
                            Secret(
                              unencryptedSecret: secretController.text,
                            ),
                          ),
                        );

                        secretController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

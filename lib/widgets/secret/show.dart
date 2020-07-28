import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluro/fluro.dart';
import 'package:keeper/blocs/blocs.dart';
import 'package:keeper/models/models.dart';
import 'package:keeper/widgets/drawer_menu.dart';
import 'package:keeper/widgets/main_app_bar.dart';

class ShowSecret extends StatefulWidget {
  @override
  _ShowSecretState createState() => _ShowSecretState();
}

class _ShowSecretState extends State<ShowSecret> {
  final secretController = TextEditingController();

  bool _isDecrypted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: DrawerMenu(),
      appBar: MainAppBar(),
      body: BlocListener<SecretBloc, SecretState>(
        listener: (context, state) {
          if (state is SecretDecryptSuccess) {
            secretController.text = state.secret.unencryptedSecret;
            setState(() {
              _isDecrypted = true;
            });
          } else {
            // TODO: handle errors
          }
        },
        child: BlocBuilder<SecretBloc, SecretState>(
          builder: (context, state) {
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
                    if (_isDecrypted)
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: FlatButton(
                                textColor: Theme.of(context).primaryColor,
                                child: Text('GO BACK'),
                                onPressed: () async {
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
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Container(
                        child: TextField(
                          readOnly: _isDecrypted,
                          controller: secretController,
                          keyboardType: TextInputType.multiline,
                          cursorColor: theme.accentColor,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: _isDecrypted
                                ? 'Secret decrypted'
                                : 'Enter secret ID...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    if (!_isDecrypted)
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
                                child: Text('UNLOCK IT!'),
                                onPressed: () async {
                                  if (secretController.text == "") {
                                    return;
                                  }

                                  BlocProvider.of<SecretBloc>(context).add(
                                    SecretDecrypted(
                                      Secret(
                                        id: secretController.text,
                                      ),
                                    ),
                                  );
                                  // BlocProvider.of<SecretBloc>(context).add(
                                  //   SecretEncrypted(
                                  //     Secret(
                                  //       unencryptedSecret: secretController.text,
                                  //     ),
                                  //   ),
                                  // );

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
          },
        ),
      ),
    );
  }
}

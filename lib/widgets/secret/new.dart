import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeper/blocs/blocs.dart';
import 'package:keeper/models/models.dart';
import 'package:keeper/widgets/main_layout.dart';

class NewSecret extends StatefulWidget {
  _NewSecret createState() => _NewSecret();
}

class _NewSecret extends State<NewSecret> {
  final secretController = TextEditingController();
  bool _idCopied = false;
  bool _isEncrypted = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        TextEditingController().clear();
      },
      child: MainLayout(
        // child: BlocListener<SecretBloc, SecretState>(
        //   listener: (context, state) {
        //     if (state is SecretEncryptSuccess) {
        //       final secretID = TextEditingController();
        //       secretID.text = "${state.secret.id}#${state.secret.password}";

        //       showDialog(
        //         barrierDismissible: false,
        //         context: context,
        //         builder: (BuildContext context) {
        //           return AlertDialog(
        //             title: Text("Secret encrypted & saved!"),
        //             content: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 TextField(
        //                   readOnly: true,
        //                   controller: secretID,
        //                   // cursorColor: theme.accentColor,
        //                   decoration: InputDecoration(
        //                     labelText: 'Unlock Key',
        //                     border: OutlineInputBorder(),
        //                     suffixIcon: IconButton(
        //                       // icon: Icon(
        //                       //   _idCopied ? Icons.done : Icons.content_copy,
        //                       // ),
        //                       icon: _idCopied
        //                           ? Icon(Icons.done)
        //                           : Icon(Icons.content_copy),
        //                       splashColor: Colors.transparent,
        //                       onPressed: () {
        //                         print(_idCopied);
        //                         if (_idCopied) {
        //                           return;
        //                         }

        //                         setState(() {
        //                           _idCopied = true;
        //                         });

        //                         Clipboard.setData(
        //                           new ClipboardData(text: secretID.text),
        //                         );

        //                         Future.delayed(
        //                           Duration(seconds: 1),
        //                           () => setState(
        //                             () {
        //                               _idCopied = false;
        //                             },
        //                           ),
        //                         );
        //                       },
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             actions: [
        //               FlatButton(
        //                 child: Text("Close"),
        //                 onPressed: () {
        //                   Navigator.of(context).pop();
        //                 },
        //               ),
        //             ],
        //           );
        //         },
        //       );
        //     }
        //   },
        //   child: BlocBuilder<SecretBloc, SecretState>(
        //     builder: (context, state) {
        //       if (state is SecretInProgress) {
        //         return Center(child: CircularProgressIndicator());
        //       }

        //       return SecretForm();
        //     },
        //   ),
        // ),
        child: BlocListener<SecretBloc, SecretState>(
          listener: (context, state) {
            if (state is SecretEncryptSuccess) {
              secretController.text =
                  "${state.secret.id}#${state.secret.password}";

              setState(() {
                _isEncrypted = true;
              });
            } else {
              // TODO: handle errors
            }
          },
          child: BlocBuilder<SecretBloc, SecretState>(
            builder: (context, state) {
              if (state is SecretInProgress) {
                return Center(child: CircularProgressIndicator());
              }

              return SecretForm(
                  secretController: secretController,
                  onSubmit: () {
                    context.bloc<SecretBloc>().add(
                          SecretEncrypted(
                            Secret(
                              unencryptedSecret: secretController.text,
                            ),
                          ),
                        );
                  });
            },
          ),
        ),
      ),
    );
  }
}

class SecretForm extends StatelessWidget {
  final TextEditingController secretController;
  final void Function() onSubmit;

  SecretForm({this.secretController, this.onSubmit});

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
                  readOnly: _isEncrypted,
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

                        onSubmit();

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

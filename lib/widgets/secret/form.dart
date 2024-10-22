import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeper/blocs/blocs.dart';

class SecretForm extends StatelessWidget {
  final TextEditingController secretController;
  final void Function() onSubmit;
  final bool done;
  final String labelText;
  final String submitText;

  SecretForm({
    @required this.secretController,
    @required this.onSubmit,
    @required this.done,
    @required this.labelText,
    @required this.submitText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SecretBloc, SecretState>(
      builder: (context, state) {
        if (state is SecretInProgress) {
          return Center(child: CircularProgressIndicator());
        }

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
                if (done)
                  Button(
                    child: Text('GO BACK'),
                    margin: EdgeInsets.only(bottom: 10.0),
                    onPressed: () async {
                      context
                          .bloc<RouterBloc>()
                          .add(RouterNavigated(context, '/'));
                    },
                  ),
                Expanded(
                  child: Container(
                    child: TextField(
                      readOnly: done,
                      controller: secretController,
                      keyboardType: TextInputType.multiline,
                      cursorColor: theme.accentColor,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        suffixIcon: Container(
                            alignment: Alignment.topRight,
                            width: 50,
                            child: PopupMenuButton(
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (_) => [
                                      PopupMenuItem(
                                          child: Text('Copy'), value: 'copy'),
                                      if (!done)
                                        PopupMenuItem(
                                            child: Text('Paste'),
                                            value: 'paste'),
                                    ],
                                onSelected: (item) async {
                                  switch (item) {
                                    case 'copy':
                                      Clipboard.setData(ClipboardData(
                                          text: secretController.text));
                                      break;
                                    case 'paste':
                                      if (done) {
                                        return;
                                      }

                                      ClipboardData data =
                                          await Clipboard.getData('text/plain');
                                      secretController.text = data.text;
                                      break;
                                  }
                                })),
                        alignLabelWithHint: true,
                        labelText: labelText,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                if (!done)
                  Button(
                    child: Text(submitText),
                    margin: EdgeInsets.only(top: 10.0),
                    onPressed: () async {
                      if (secretController.text == "") {
                        return;
                      }

                      onSubmit();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Button extends StatelessWidget {
  final Widget child;
  final Future Function() onPressed;
  final EdgeInsetsGeometry margin;

  Button({@required this.child, @required this.onPressed, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: child,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}

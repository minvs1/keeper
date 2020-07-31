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
                  context.bloc<RouterBloc>().add(RouterNavigated(context, '/'));
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

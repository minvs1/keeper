import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeper/blocs/blocs.dart';
import 'package:keeper/models/models.dart';
import 'package:keeper/widgets/main_layout.dart';
import 'package:keeper/widgets/secret/form.dart';

class NewSecret extends StatefulWidget {
  _NewSecret createState() => _NewSecret();
}

class _NewSecret extends State<NewSecret> {
  final secretController = TextEditingController();
  bool _isEncrypted = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        TextEditingController().clear();
      },
      child: MainLayout(
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
          child: SecretForm(
            submitText: 'SHARE IT!',
            labelText:
                _isEncrypted ? 'Tell me a secret...' : 'Your secret is safe',
            secretController: secretController,
            done: _isEncrypted,
            onSubmit: () {
              context.bloc<SecretBloc>().add(
                    SecretEncrypted(
                      Secret(
                        unencryptedSecret: secretController.text,
                      ),
                    ),
                  );
            },
          ),
        ),
      ),
    );
  }
}

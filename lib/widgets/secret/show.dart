import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeper/blocs/blocs.dart';
import 'package:keeper/models/models.dart';
import 'package:keeper/widgets/main_layout.dart';
import 'package:keeper/widgets/secret/form.dart';

class ShowSecret extends StatefulWidget {
  @override
  _ShowSecretState createState() => _ShowSecretState();
}

class _ShowSecretState extends State<ShowSecret> {
  final secretController = TextEditingController();

  bool _isDecrypted = false;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: BlocListener<SecretBloc, SecretState>(
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
            return SecretForm(
              submitText: 'UNLOCK IT!',
              labelText: _isDecrypted
                  ? 'Your secret is revealed'
                  : 'Enter secret ID...',
              secretController: secretController,
              done: _isDecrypted,
              onSubmit: () {
                context.bloc<SecretBloc>().add(
                      SecretDecrypted(
                        Secret(
                          id: secretController.text,
                        ),
                      ),
                    );
              },
            );
          },
        ),
      ),
    );
  }
}

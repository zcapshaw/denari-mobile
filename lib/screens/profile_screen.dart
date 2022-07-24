import 'package:denari_mobile/plaid_data/plaid_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:denari_mobile/app/app.dart';
import 'package:denari_mobile/main/main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: ProfileScreen());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Avatar(photo: user.photo),
              const SizedBox(height: 16),
              Text(user.email ?? '', style: textTheme.headline6),
              const SizedBox(height: 32),
              ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey[800],
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () =>
                    context.read<AppBloc>().add(AppLogoutRequested()),
                child: const Text('LOG OUT'),
              ),
              //TODO: Remove this button for testing
              const SizedBox(height: 32),
              ElevatedButton(
                key: const Key('test_button'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey[800],
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () =>
                    context.read<PlaidDataBloc>().add(SwitchToInitialState()),
                child: const Text('LINK ACCOUNTS WITH PLAID'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

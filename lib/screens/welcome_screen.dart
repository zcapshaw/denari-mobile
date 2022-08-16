import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:denari_mobile/app/app.dart';
import 'package:denari_mobile/plaid_data/plaid_data.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: WelcomeScreen());

  @override
  Widget build(BuildContext context) {
    // User ID will be passed to API for Plaid Link token
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return BlocBuilder<PlaidDataBloc, PlaidDataState>(
      builder: (context, state) {
        if (state is PlaidLinkLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to Denari 👋',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Let\'s begin by connecting your accounts.',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () => context
                            .read<PlaidDataBloc>()
                            .add(GetLinkToken(user)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey[800],
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('CONNECT WITH PLAID'),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () => context
                            .read<PlaidDataBloc>()
                            .add(PlaidDataLoaded()),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('BACK TO HOME SCREEN'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

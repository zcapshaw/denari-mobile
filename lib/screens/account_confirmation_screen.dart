import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:denari_mobile/plaid_data/plaid_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountConfirmationScreen extends StatelessWidget {
  const AccountConfirmationScreen({Key? key}) : super(key: key);

  static Page page() =>
      const MaterialPage<void>(child: AccountConfirmationScreen());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaidDataBloc, PlaidDataState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Rock on 🎸',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Successfully added {n} accounts.',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    const ListTile(
                      leading: FaIcon(FontAwesomeIcons.landmark),
                      title: Text('PNC SAVINGS'),
                      subtitle: Text('********1234'),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () => context
                              .read<PlaidDataBloc>()
                              .add(PlaidDataLoaded()),
                          child: const Text('I\'M DONE'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => context
                              .read<PlaidDataBloc>()
                              .add(PlaidDataLoaded()),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueGrey[800],
                            elevation: 0,
                          ),
                          child: const Text('ADD ANOTHER'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

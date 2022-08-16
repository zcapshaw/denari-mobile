import 'package:denari_mobile/app/app.dart';
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
    // User ID will be passed to API for Plaid Link token
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return BlocBuilder<PlaidDataBloc, PlaidDataState>(
      builder: (context, state) {
        if (state is PlaidLinkSuccess) {
          final linkedItems = state.linkedItems;
          final numberOfAccounts = state.linkedItems.length;
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
                        'Successfully added $numberOfAccounts accounts.',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Column(
                        children: List.generate(
                          linkedItems.length,
                          ((index) {
                            return Column(
                              children: [
                                ListTile(
                                  leading:
                                      const FaIcon(FontAwesomeIcons.landmark),
                                  title: Text(linkedItems.isEmpty
                                      ? 'Error Occurred'
                                      : linkedItems[index].institutionName),
                                  subtitle: Text(linkedItems.isEmpty
                                      ? 'Error Occurred'
                                      : '********${linkedItems[index].accountMask}'),
                                ),
                                const Divider()
                              ],
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () => context
                            .read<PlaidDataBloc>()
                            .add(GetLinkToken(user)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey[800],
                          elevation: 0,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('ADD ANOTHER'),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () => context
                            .read<PlaidDataBloc>()
                            .add(PlaidDataLoaded()),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('I\'M DONE ADDING ACCOUNTS'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

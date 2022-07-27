import 'package:authentication_repository/authentication_repository.dart';
import 'package:denari_mobile/plaid_data/plaid_data.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:denari_mobile/app/app.dart';
import 'package:denari_mobile/theme.dart';
import 'package:denari_mobile/plaid_data/plaid_repository/plaid_repository.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required AuthenticationRepository authenticationRepository,
    required PlaidRepository plaidRepository,
  })  : _authenticationRepository = authenticationRepository,
        _plaidRepository = plaidRepository,
        super(key: key);

  final AuthenticationRepository _authenticationRepository;
  final PlaidRepository _plaidRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (context) => PlaidDataBloc(
              plaidRepository: _plaidRepository,
            ),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Denari',
      theme: theme,
      // home: const HomeScreen(title: 'Denari Home Page'),
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:denari_mobile/plaid_data/plaid_repository/plaid_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:denari_mobile/app/app.dart';
import 'firebase_options.dart';

Future<void> main() {
  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final authenticationRepository = AuthenticationRepository();
      final plaidRepository = PlaidRepository();
      await authenticationRepository.user.first;

      runApp(App(
        authenticationRepository: authenticationRepository,
        plaidRepository: plaidRepository,
      ));
    },
    blocObserver: AppBlocObserver(),
  );
}

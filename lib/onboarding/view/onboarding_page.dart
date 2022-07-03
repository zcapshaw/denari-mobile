import 'package:bloc/bloc.dart';
import 'package:denari_mobile/main/main.dart';
import 'package:denari_mobile/screens/screens.dart';
import 'package:equatable/equatable.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:denari_mobile/app/app.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  List<Page> onGenerateOnboardingPages(User state, List<Page<dynamic>> pages) {
    final userId = state.id;
    return [MainPage.page()];

    // switch (state) {
    //   case user.:
    //     return [MainPage.page()];
    //   case AppStatus.unauthenticated:
    //     return [SignUpPage.page()];
    // }
  }

  @override
  Widget build(BuildContext context) {
    return FlowBuilder<User>(
      state: context.select((AppBloc bloc) => bloc.state.user),
      onGeneratePages: onGenerateOnboardingPages,
    );
  }
}

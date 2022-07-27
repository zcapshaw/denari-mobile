import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:denari_mobile/plaid_data/repository/plaid_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';

part 'plaid_data_event.dart';
part 'plaid_data_state.dart';

class PlaidDataBloc extends Bloc<PlaidDataEvent, PlaidDataState> {
  PlaidDataBloc({required PlaidRepository plaidRepository})
      // initialize plaidRepository
      : _plaidRepository = plaidRepository,
        //define initial state to emit
        super(PlaidDataInitial()) {
    _subscribe();

    /// EVENT HANDLERS
    // Used for testing
    on<PlaidDataLoaded>((event, emit) {
      emit(PlaidDataLoadSuccess());
    });

    // TODO: Remove this event
    on<SwitchToInitialState>((event, emit) {
      emit(PlaidDataInitial());
    });

    // Handle user requesting to link an account via Plaid
    on<GetLinkToken>((event, emit) async {
      try {
        // switch the UI to a loading spinner while the Plaid Link SDK fires up
        emit(PlaidLinkLoading());

        // Request to open a Plaid Link
        await _plaidRepository.openPlaidLink(event.user);
      } catch (err) {
        print(err);
        throw Exception('Open Plaid Link failed: $err');
      }
    });
  }

  final PlaidRepository _plaidRepository;
  late final StreamSubscription _subscription;

  void _subscribe() {
    _subscription = _plaidRepository.response.listen((event) {
      print('stream event detected: $event');

      // If user exits the plaid flow without linking an
      if (event.status == PlaidRequestStatus.exited) {
        emit(PlaidDataInitial());
      }
    });
  }
}

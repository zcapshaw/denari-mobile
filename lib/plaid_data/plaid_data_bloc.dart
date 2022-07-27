import 'package:bloc/bloc.dart';
import 'package:denari_mobile/plaid_data/plaid_repository/models/plaid_linked_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:denari_mobile/plaid_data/plaid_repository/plaid_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import './plaid_repository/models/plaid_response.dart';
import './plaid_repository/models/plaid_linked_item.dart';

part 'plaid_data_event.dart';
part 'plaid_data_state.dart';

class PlaidDataBloc extends Bloc<PlaidDataEvent, PlaidDataState> {
  PlaidDataBloc({required PlaidRepository plaidRepository})
      : _plaidRepository = plaidRepository,
        super(PlaidDataInitial()) {
    /// Open a subscription to the Plaid Repo event stream
    /// Emit states in response to Plaid Linking events
    on<PlaidSubscriptionRequested>((event, emit) async {
      await emit.forEach<PlaidResponse>(
        _plaidRepository.response,
        onData: (res) {
          if (res.status == PlaidRequestStatus.succeeded) {
            return PlaidLinkSuccess(res.items);
          } else {
            return PlaidDataInitial();
          }
        },
        onError: (obj, trace) => PlaidLinkFailure(),
      );
    });

    on<PlaidDataLoaded>((event, emit) {
      emit(PlaidDataLoadSuccess());
    });

    on<SwitchToInitialState>((event, emit) {
      emit(PlaidDataInitial());
    });

    // Handle user requesting to link an account via Plaid
    on<GetLinkToken>(
      (event, emit) async {
        // Show a loading spinner while Plaid SDK is open
        emit(PlaidLinkLoading());

        // Open the Plaid Link UI
        await _plaidRepository.openPlaidLink(event.user);
      },
    );
  }

  final PlaidRepository _plaidRepository;
}

import 'package:bloc/bloc.dart';
import 'package:denari_mobile/plaid_data/repository/plaid_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';

part 'plaid_data_event.dart';
part 'plaid_data_state.dart';

class PlaidDataBloc extends Bloc<PlaidDataEvent, PlaidDataState> {
  PlaidDataBloc({required PlaidRepository plaidRepository})
      // initialize plaidRepository
      : _plaidRepository = plaidRepository,
        //define initial state to emit
        super(PlaidDataInitial()) {
    ///
    /// EVENTS
    // Used for testing
    on<PlaidDataLoaded>((event, emit) {
      emit(PlaidDataLoadSuccess());
    });

    // TODO: Remove this event
    on<SwitchToInitialState>((event, emit) {
      emit(PlaidDataInitial());
    });

    // Handle user requesting to link an account via Plaid
    on<GetLinkToken>((event, emit) {
      _plaidRepository.openPlaidLink(event.user);
    });
  }

  final PlaidRepository _plaidRepository;
}

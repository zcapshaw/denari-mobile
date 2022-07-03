import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'plaid_data_event.dart';
part 'plaid_data_state.dart';

class PlaidDataBloc extends Bloc<PlaidDataEvent, PlaidDataState> {
  PlaidDataBloc() : super(PlaidDataInitial()) {
    on<PlaidDataLoaded>((event, emit) {
      // TODO: implement event handler
      emit(PlaidDataLoadSuccess());
    });
  }
}

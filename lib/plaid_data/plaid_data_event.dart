part of 'plaid_data_bloc.dart';

abstract class PlaidDataEvent extends Equatable {
  const PlaidDataEvent();

  @override
  List<Object> get props => [];
}

class UserLoggedIn extends PlaidDataEvent {}

class PlaidDataLoaded extends PlaidDataEvent {}

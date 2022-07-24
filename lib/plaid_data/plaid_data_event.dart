part of 'plaid_data_bloc.dart';

abstract class PlaidDataEvent extends Equatable {
  const PlaidDataEvent();

  @override
  List<Object> get props => [];
}

class UserLoggedIn extends PlaidDataEvent {}

class PlaidDataLoaded extends PlaidDataEvent {}

//TODO: remove this test event
class SwitchToInitialState extends PlaidDataEvent {}

//Event fired when user taps Connect With Plaid button in UI
class GetLinkToken extends PlaidDataEvent {
  const GetLinkToken(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

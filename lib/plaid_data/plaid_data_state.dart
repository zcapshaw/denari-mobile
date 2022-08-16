part of 'plaid_data_bloc.dart';

abstract class PlaidDataState extends Equatable {
  const PlaidDataState();

  @override
  List<Object> get props => [];
}

class PlaidDataInitial extends PlaidDataState {}

class PlaidDataLoadSuccess extends PlaidDataState {}

// emitted whil the Plaid Link is opening until it closes
class PlaidLinkLoading extends PlaidDataState {}

/// emitted when user successfully links a new item
class PlaidLinkSuccess extends PlaidDataState {
  const PlaidLinkSuccess(this.linkedItems);

  final List<PlaidLinkedItem> linkedItems;

  @override
  List<Object> get props => [linkedItems];
}

/// emitted when user successfully links a new item
class PlaidLinkFailure extends PlaidDataState {}

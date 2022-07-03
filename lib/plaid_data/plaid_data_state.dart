part of 'plaid_data_bloc.dart';

abstract class PlaidDataState extends Equatable {
  const PlaidDataState();

  @override
  List<Object> get props => [];
}

class PlaidDataInitial extends PlaidDataState {}

class PlaidDataLoading extends PlaidDataState {}

class PlaidDataLoadSuccess extends PlaidDataState {}

class PlaidDataLoadFailure extends PlaidDataState {}

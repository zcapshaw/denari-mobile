import 'package:equatable/equatable.dart';
import './plaid_linked_item.dart';

enum PlaidRequestStatus { succeeded, exited }

class PlaidResponse extends Equatable {
  const PlaidResponse({required this.status, required this.items});

  final PlaidRequestStatus status;
  final List<PlaidLinkedItem> items;

  @override
  List<Object> get props => [status, items];
}

import 'package:equatable/equatable.dart';

class PlaidLinkedItem extends Equatable {
  const PlaidLinkedItem(
      {required this.institutionName,
      required this.accountName,
      required this.accountMask});

  final String institutionName;
  final String accountName;
  final String accountMask;

  @override
  List<Object> get props => [institutionName, accountName, accountMask];
}

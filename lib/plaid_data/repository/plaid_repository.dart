import 'dart:async';
import 'dart:convert';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:equatable/equatable.dart';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:http/http.dart' as http;

/// Exception thrown when API call fails.
class RequestFailure implements Exception {}

/// MODELS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// TODO: Move models to their own file
enum PlaidRequestStatus { succeeded, exited }

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

class PlaidResponse extends Equatable {
  const PlaidResponse({required this.status, required this.items});

  final PlaidRequestStatus status;
  final List<PlaidLinkedItem> items;

  @override
  List<Object> get props => [status, items];
}

/// ABSTRACT REPOSITORY >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
///
/// Abstract Repository to create the stream methods
/// Following the Reactive Repository pattern here: https://medium.com/flutter-community/blocs-with-reactive-repository-5fd440d3b1dc
abstract class PlaidDataStreamRepository {
  final _controller = StreamController<PlaidResponse>();

  Stream<PlaidResponse> get response => _controller.stream.asBroadcastStream();

  void addToStream(PlaidResponse response) => _controller.sink.add(response);

  // not sure I need this:
  // Future<void> fetchAll({bool force = false});
}

/// REPOSITORY IMPLEMENTATION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class PlaidRepository extends PlaidDataStreamRepository {
  PlaidRepository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'api.denari.app';
  final http.Client _httpClient;
  late LinkTokenConfiguration _linkTokenConfiguration;

  /// Provides a [Stream] of Plaid Responses
  /// TODO: Implement stream of info from PlaidLink so Plaid Data Bloc can react

  // Plaid Link helper functions
  void _sendPublicToken(String token) async {
    var url = Uri.parse('https://api.denari.app/plaid/link/exchange');
    var response = await http.post(url, body: {'public_token': token});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  void _onSuccessCallback(String publicToken, LinkSuccessMetadata metadata) {
    print("onSuccess: $publicToken, metadata: ${metadata.description()}");
    _sendPublicToken(publicToken);
  }

  void _onEventCallback(String event, LinkEventMetadata metadata) {
    print("onEvent: $event, metadata: ${metadata.description()}");
  }

  void _onExitCallback(LinkError? error, LinkExitMetadata metadata) {
    print("onExit metadata: ${metadata.description()}");
    const response =
        PlaidResponse(status: PlaidRequestStatus.exited, items: []);
    addToStream(response);

    if (error != null) {
      print("onExit error: ${error.description()}");
    }
  }

  // Method to open the plaid SDK in the App
  Future openPlaidLink(User user) async {
    try {
      // Get the link token
      final String linkToken = await _getLinkToken(user.id);
      // print(linkToken);

      // This will trigger the Plaid Link view for adding an Item/Login Creds
      _linkTokenConfiguration = LinkTokenConfiguration(
        token: linkToken,
      );

      var response =
          const PlaidResponse(items: [], status: PlaidRequestStatus.exited);

      PlaidLink.open(configuration: _linkTokenConfiguration)
          .catchError((e) => throw RequestFailure());

      PlaidLink.onEvent(_onEventCallback);

      PlaidLink.onExit(_onExitCallback);

      PlaidLink.onSuccess(_onSuccessCallback);
    } catch (e) {
      throw RequestFailure();
    }
  }

  // Returns a link token from Denari API
  Future _getLinkToken(String userId) async {
    final requestUrl = Uri.https(
      _baseUrl,
      '/plaid/link/create',
    );

    final linkResponse =
        await _httpClient.post(requestUrl, body: {'user_id': userId});
    // print('user id is $userId');
    // print('Response status: ${linkResponse.statusCode}');
    // print('Response body: ${linkResponse.body}');

    if (linkResponse.statusCode != 200) {
      throw RequestFailure();
    }

    final linkToken = jsonDecode(linkResponse.body)['link_token'];

    if (linkToken.isEmpty) {
      throw RequestFailure();
    }

    return linkToken;
  }
}

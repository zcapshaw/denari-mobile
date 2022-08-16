import 'dart:async';
import 'dart:convert';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:authentication_repository/authentication_repository.dart';
import '../models/plaid_linked_item.dart';
import '../models/plaid_response.dart';

/// Exception thrown when API call fails.
class RequestFailure implements Exception {}

/// ABSTRACT REPOSITORY >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/// Following the Reactive Repository pattern here: https://medium.com/flutter-community/blocs-with-reactive-repository-5fd440d3b1dc
abstract class PlaidDataStreamRepository {
  final _controller = StreamController<PlaidResponse>();

  /// Provides a [Stream] of Plaid Responses
  Stream<PlaidResponse> get response => _controller.stream;

  void addToStream(PlaidResponse response) => _controller.sink.add(response);
}

/// REPOSITORY IMPLEMENTATION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
class PlaidRepository extends PlaidDataStreamRepository {
  PlaidRepository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'api.denari.app';
  final http.Client _httpClient;
  late LinkTokenConfiguration _linkTokenConfiguration;

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

    List<PlaidLinkedItem> linkedAccounts = [];

    for (var account in metadata.accounts) {
      final item = PlaidLinkedItem(
          institutionName: metadata.institution.name,
          accountName: account.name,
          accountMask: account.mask);

      linkedAccounts.add(item);
    }

    print('linked accounts: $linkedAccounts');

    final response = PlaidResponse(
        status: PlaidRequestStatus.succeeded, items: linkedAccounts);

    // Add a success event to the Stream to notify the Plaid Data Bloc
    addToStream(response);
  }

  void _onEventCallback(String event, LinkEventMetadata metadata) {
    print("onEvent: $event, metadata: ${metadata.description()}");
  }

  void _onExitCallback(LinkError? error, LinkExitMetadata metadata) {
    print("onExit metadata: ${metadata.description()}");

    /// add an Exited event to the [Stream]
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

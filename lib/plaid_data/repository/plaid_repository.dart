import 'dart:async';
import 'dart:convert';
import 'package:plaid_flutter/plaid_flutter.dart';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:http/http.dart' as http;

/// Exception thrown when API call fails.
class RequestFailure implements Exception {}

class PlaidRepository {
  PlaidRepository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'api.denari.app';
  final http.Client _httpClient;
  late LinkTokenConfiguration _linkTokenConfiguration;

  Future openPlaidLink(User user) async {
    try {
      // Get the link token
      final String linkToken = await _getLinkToken(user.id);
      // print(linkToken);
      // This will trigger the Plaid Link view for adding an Item/Login Creds
      _linkTokenConfiguration = LinkTokenConfiguration(
        token: linkToken,
      );
      // PlaidLink.onSuccess((publicToken, metadata) {
      //   _sendPublicToken(publicToken);
      // });
      PlaidLink.open(configuration: _linkTokenConfiguration)
          .catchError((e) => throw RequestFailure());
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

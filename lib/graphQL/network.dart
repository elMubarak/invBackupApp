import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:inventory_app/utils/links.dart';

class Network {
  ValueNotifier<GraphQLClient> client;

  ValueNotifier<GraphQLClient> getClient(String token) {
    print("Token: $token");
    if (client == null && token.isNotEmpty) {
      final HttpLink httpLink = HttpLink(
        uri: url,
      );
      final AuthLink authLink = AuthLink(
        getToken: () => token,
        // OR
        // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
      );
      final Link link = authLink.concat(httpLink);
      client = ValueNotifier(
        GraphQLClient(
          cache: InMemoryCache(),
          link: link,
        ),
      );
    }
    return client;
  }
}

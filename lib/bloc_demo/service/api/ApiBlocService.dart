import 'package:flutter_arch_demo/bloc_demo/service/aws/aws_cognito.dart';
import 'package:flutter_arch_demo/utils/Constants.dart';
import 'package:graphql/client.dart';

class ApiBlocService {
  GraphQLClient client;

  AWSCognito awsCognito;

  ApiBlocService(this.awsCognito) {
    HttpLink link = HttpLink(
      uri: Constants.GRAPHQL_ENDPOINT,
      headers: <String, String>{
//        'Authorization': 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
        Constants.X_API_KEY_HEADER: Constants.X_API_KEY,
        'can-id-token': awsCognito.getCognitoUserSession() != null
            ? awsCognito.getCognitoUserSession().idToken.getJwtToken()
            : ''
      },
    );

    client = GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    );
  }

  refreshClient() {
    HttpLink link = HttpLink(
      uri: Constants.GRAPHQL_ENDPOINT,
      headers: <String, String>{
//        'Authorization': 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
        Constants.X_API_KEY_HEADER: Constants.X_API_KEY,
        'can-id-token': awsCognito.getCognitoUserSession() != null
            ? awsCognito.getCognitoUserSession().idToken.getJwtToken()
            : ''
      },
    );

    client = GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    );
  }

  Future<QueryResult> getUserInfo(String name) {
    refreshClient();

    return client.query(
      QueryOptions(
        document: Constants.QUERY_USER_INFO,
        variables: {'username': name},
      ),
    );
  }

  Future<QueryResult> changeUserName(String name) {
    refreshClient();
    return client.mutate(MutationOptions(
        document: Constants.MUTATION_CHANGE_NAME, variables: {'name': name}));
  }
}

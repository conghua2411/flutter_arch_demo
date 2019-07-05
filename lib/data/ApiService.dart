import 'package:flutter_arch_demo/utils/AWSCognito.dart';
import 'package:flutter_arch_demo/utils/Constants.dart';
import 'package:graphql/client.dart';

class ApiService {
  GraphQLClient client;

  ApiService() {
    HttpLink link = HttpLink(
      uri: Constants.GRAPHQL_ENDPOINT,
      headers: <String, String>{
//        'Authorization': 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
        Constants.X_API_KEY_HEADER: Constants.X_API_KEY,
        'can-id-token': AWSCognito.getCognitoUserSession() != null
            ? AWSCognito.getCognitoUserSession().idToken.getJwtToken()
            : ''
      },
    );

    client = GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    );
  }

  Future<QueryResult> getUserInfo() {
    return client.query(
      QueryOptions(
          document: Constants.QUERY_USER_INFO,
          variables: {'username': 'conghua2411@yopmail.com'}),
    );
  }

  Future<QueryResult> changeUserName(String name) {
    return client.mutate(MutationOptions(
        document: Constants.MUTATION_CHANGE_NAME, variables: {'name': name}));
  }
}

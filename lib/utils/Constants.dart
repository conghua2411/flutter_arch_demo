class Constants {
  static const AWS_USER_POOL_ID = 'ap-southeast-1_GwZ4hQOVY';
  static const AWS_CLIENT_ID = '3uhjka1l7iopcc30amfgrh1ja6';

  // server test
  static const GRAPHQL_ENDPOINT =
      'https://grfo19kcbl.execute-api.ap-southeast-1.amazonaws.com/m1/internal-graphql-dev';
  static const X_API_KEY_HEADER = 'X-Api-Key';
  static const X_API_KEY = 'XsNWM6ee8P3guYquBFB4b6zwYqwvrrV82GP2uIiF';

  static const QUERY_USER_INFO = '''
  query getUserInfo(\$username: String!) {
      user(username: \$username) {
        id
        username
        name
        pName
        picture
        description
        citizenNum
        amountOfMinedCAT
        receivedCertificates
        certifications(first: 10) {
          id
          badge {
            id
            name
            backgroundColor
            textColor
            imageUrl
            description
            creator {
              id
              name
              nickname
            }
            path
            claimable
          }
          winnerName
          description
          num
        }
      }
    }
  ''';

  static const MUTATION_CHANGE_NAME = '''
  mutation changeName(\$name: String) {
      updateUserSetting(userInput: {name: \$name}) {
        name
      }
    }
  ''';
}

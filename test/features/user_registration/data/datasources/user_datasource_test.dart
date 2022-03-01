import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:serotonina/features/user_registration/data/datasources/user_datasource.dart';
import 'package:serotonina/features/user_registration/data/models/user_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'user_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  MockClient? mockClient;
  UserDataSourceImpl? userDataSourceImpl;

  setUp(() {
    mockClient = MockClient();
    userDataSourceImpl = UserDataSourceImpl(httpClient: mockClient!);
  });

  group(
    'submitNewUser',
    () {
      final tUsername = 'admin';
      final tEmail = 'admin@example.com';
      final tPassword = 'very-strong-password';

      final tUserModel = UserModel.fromJson(
          json.decode(fixture('user_registration_porteiro_success.json')));

      test('should perform a POST request on a URL with users endpoint',
          () async {
        when(mockClient!.post(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((realInvocation) async => http.Response(
                fixture('user_registration_porteiro_success.json'), 201));

        userDataSourceImpl!.submitNewUser(
            username: tUsername, email: tEmail, password: tPassword);

        verify(mockClient!.post('http://localhost:8010/users' as Uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(<String, String>{
              'username': tUsername,
              'email': tEmail,
              'password': tPassword
            })));
      });

      test('should return User when the response is 201', () async {
        when(mockClient!.post(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((realInvocation) async => http.Response(
                fixture('user_registration_porteiro_success.json'), 201));

        final result = await userDataSourceImpl!.submitNewUser(
            username: tUsername, email: tEmail, password: tPassword);

        expect(result, tUserModel);
      });
    },
  );
}
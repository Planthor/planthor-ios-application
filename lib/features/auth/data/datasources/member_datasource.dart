import 'package:dio/dio.dart';
import 'package:planthor_ios_application/core/config/app_config.dart';
import 'package:planthor_ios_application/core/utils/jwt_utils.dart';

/// Registers the authenticated user as a member on first login.
/// Returns the member UUID on creation (HTTP 200), null if already exists.
Future<String?> createMemberIfNeeded(String accessToken) async {
  final claims = decodeJwtPayload(accessToken);

  final identifyName =
      claims['preferred_username'] as String? ?? claims['sub'] as String;
  final firstName = claims['given_name'] as String? ?? '';
  final lastName = claims['family_name'] as String? ?? '';
  final middleName = claims['middle_name'] as String?;
  final timezone = DateTime.now().timeZoneName;

  final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBase));

  try {
    final response = await dio.post(
      '/v1/Members',
      data: {
        'identifyName': identifyName,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'description': null,
        'preferredTimezone': timezone,
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return response.data as String?;
  } on DioException catch (e) {
    final status = e.response?.statusCode;
    if (status != 409 && status != 400) rethrow;
    return null;
  }
}

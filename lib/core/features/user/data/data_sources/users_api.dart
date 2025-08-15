import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/models.dart';

part 'users_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @GET('/user')
  Future<UserInfoDto> getUser();

  @PUT('/user')
  Future<void> updateUser(@Body() UpdateUserDto request);
}

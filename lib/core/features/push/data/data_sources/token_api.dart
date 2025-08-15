import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/models.dart';

part 'token_api.g.dart';

@RestApi()
abstract class TokenApi {
  factory TokenApi(Dio dio, {String baseUrl}) = _TokenApi;

  @POST('/actualize-token')
  Future<void> actualize(@Body() DeviceTokenRequest request);

  @POST('/{fcmToken}:archive-token')
  Future<void> archive(@Path("fcmToken") String fcmToken);
}

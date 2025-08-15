import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/models.dart';

part 'user_subscription_api.g.dart';

@RestApi()
abstract class UserSubscriptionApi {
  factory UserSubscriptionApi(Dio dio, {String baseUrl}) = _UserSubscriptionApi;

  @GET('/monetization-info')
  Future<UserSubscriptionInfoDto> getMonetizationInfo();
}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/models.dart';

part 'monetization_api.g.dart';

@RestApi()
abstract class MonetizationApi {
  factory MonetizationApi(Dio dio, {String baseUrl}) = _MonetizationApi;

  @GET('/products')
  Future<List<ProductInfoDto>> getProducts();

  @GET('/subscriptions')
  Future<List<SubscriptionInfoDto>> getSubscriptions();
}

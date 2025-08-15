import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/models.dart';

part 'chats_api.g.dart';

@RestApi()
abstract class ChatsApi {
  factory ChatsApi(Dio dio, {String baseUrl}) = _ChatsApi;

  @GET('/')
  Future<List<ChatDto>> getChats(@Query("limit") int limit, {@Query("lastChatId") String? lastChatId});

  @GET('/advert-chats')
  Future<List<ChatDto>> getAdvertChats(
    @Query("limit") int limit,
    @Query("advertId") String advertId, {
    @Query("lastChatId") String? lastChatId,
  });

  @GET('/{chatId}')
  Future<ShortChatInfoDto> getShortChatInfo(@Path("chatId") String chatId);

  @PUT('/direct/{userId}')
  Future<CreateChatResponseDto> createDirectChat(@Path("userId") String userId);

  @PUT('/advert/{advertId}')
  Future<CreateChatResponseDto> createAdvertChat(@Path("advertId") String advertId);

  @PUT('/support')
  Future<CreateChatResponseDto> createSupportChat();
}

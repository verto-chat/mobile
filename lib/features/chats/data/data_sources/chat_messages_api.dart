import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/models.dart';

part 'chat_messages_api.g.dart';

@RestApi()
abstract class ChatMessagesApi {
  factory ChatMessagesApi(Dio dio, {String baseUrl}) = _ChatMessagesApi;

  @GET('/')
  Future<List<MessageDto>> getMessages(
    @Query("chatId") String chatId,
    @Query("limit") int limit, {
    @Query("lastMessageId") String? lastMessageId,
  });

  @POST('/send-text-message')
  Future<void> sendTextMessage(@Body() SendTextMessageRequestDto request);

  @POST('/send-file-message')
  Future<void> sendFileMessage(@Body() SendFileMessageRequestDto request);

  @POST('/send-image-message')
  Future<void> sendImageMessage(@Body() SendImageMessageRequestDto request);
}

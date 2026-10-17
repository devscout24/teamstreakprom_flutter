//import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import 'package:teamstreakpromo/features/host_features/host_events/data/rx_get_events/rx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:teamstreakpromo/features/host_features/host_events/model/get_events_response_model.dart';

import 'package:teamstreakpromo/features/settings/data/rx_get_my_tickets/rx.dart';
import 'package:teamstreakpromo/features/settings/model/my_support_tickets_model.dart';
import 'package:teamstreakpromo/features/settings/data/rx_create_support_ticket/rx.dart';
import 'package:teamstreakpromo/features/settings/model/create_support_ticket_response_model.dart';
import 'package:teamstreakpromo/features/settings/data/rx_get_ticket_messages/rx.dart';
import 'package:teamstreakpromo/features/settings/data/rx_send_ticket_message/rx.dart';
import 'package:teamstreakpromo/features/settings/model/ticket_messages_model.dart';

final locator = GetIt.instance;
final appData = locator.get<GetStorage>();

void diSetup() {
  locator.registerSingleton<GetStorage>(GetStorage());
  locator.registerLazySingleton<GetEventsRx>(
    () => GetEventsRx(
      empty: GetEventsResponseModel(),
      dataFetcher: BehaviorSubject<GetEventsResponseModel>(),
    ),
  );
  locator.registerLazySingleton<GetMyTicketsRx>(
    () => GetMyTicketsRx(
      empty: MySupportTicketsModel(),
      dataFetcher: BehaviorSubject<MySupportTicketsModel>(),
    ),
  );
  locator.registerLazySingleton<CreateSupportTicketRx>(
    () => CreateSupportTicketRx(
      empty: CreateSupportTicketResponseModel(),
      dataFetcher: BehaviorSubject<CreateSupportTicketResponseModel>(),
    ),
  );
  locator.registerLazySingleton<GetTicketMessagesRx>(
    () => GetTicketMessagesRx(
      empty: TicketMessagesResponseModel(),
      dataFetcher: BehaviorSubject<TicketMessagesResponseModel>(),
    ),
  );
  locator.registerLazySingleton<SendTicketMessageRx>(
    () => SendTicketMessageRx(
      empty: SendTicketMessageResponseModel(),
      dataFetcher: BehaviorSubject<SendTicketMessageResponseModel>(),
    ),
  );
}




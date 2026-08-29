//import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import 'package:teamstreakpromo/features/host_features/host_events/data/rx_get_events/rx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:teamstreakpromo/features/host_features/host_events/model/get_events_response_model.dart';

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
}

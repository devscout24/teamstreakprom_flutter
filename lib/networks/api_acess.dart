import 'package:rxdart/rxdart.dart';
import 'package:teamstreakpromo/features/auth/data/rx_signup/rx.dart';
import 'package:teamstreakpromo/features/auth/model/user_signup_model.dart';
import 'package:teamstreakpromo/features/auth/data/rx_verify_register_otp/rx.dart';
import 'package:teamstreakpromo/features/auth/model/verify_register_otp_model.dart';
import 'package:teamstreakpromo/features/auth/data/rx_resend_register_otp/rx.dart';
import 'package:teamstreakpromo/features/auth/model/resend_register_otp_model.dart';
import 'package:teamstreakpromo/features/auth/data/rx_login/rx.dart';
import 'package:teamstreakpromo/features/auth/model/user_login_model.dart';
import 'package:teamstreakpromo/features/auth/data/rx_refresh_token/rx.dart';
import 'package:teamstreakpromo/features/auth/model/refresh_token_model.dart';
import 'package:teamstreakpromo/features/auth/data/rx_forgot_password/rx.dart';
import 'package:teamstreakpromo/features/auth/model/forgot_password_model.dart';
import 'package:teamstreakpromo/features/auth/data/rx_verify_forgot_password_otp/rx.dart';
import 'package:teamstreakpromo/features/auth/model/verify_forgot_password_otp_model.dart';
import 'package:teamstreakpromo/features/auth/data/rx_reset_password/rx.dart';
import 'package:teamstreakpromo/features/auth/model/reset_password_model.dart';
import 'package:teamstreakpromo/features/auth/data/rx_logout/rx.dart';
import 'package:teamstreakpromo/features/auth/model/logout_model.dart';
import 'package:teamstreakpromo/features/onboarding/data/rx_get_categories/rx.dart';
import 'package:teamstreakpromo/features/onboarding/data/rx_get_subcategories/rx.dart';
import 'package:teamstreakpromo/features/onboarding/model/intrest_category_model.dart';
import 'package:teamstreakpromo/features/host_features/host_events/data/rx_create_event/rx.dart';
import 'package:teamstreakpromo/features/host_features/host_events/data/rx_update_event/rx.dart';
import 'package:teamstreakpromo/features/host_features/host_events/model/create_event_response_model.dart';
import 'package:teamstreakpromo/features/host_features/host_events/data/rx_delete_event/rx.dart';
import 'package:teamstreakpromo/features/host_features/host_events/model/delete_event_response_model.dart';
import 'package:teamstreakpromo/features/event/data/rx_get_event_details/rx.dart';
import 'package:teamstreakpromo/features/event/model/host_event_details_model.dart';
import 'package:teamstreakpromo/features/home/data/rx_get_events/rx.dart';
import 'package:teamstreakpromo/features/home/model/event_fetch_by_category_model.dart';
import 'package:teamstreakpromo/features/auth/data/rx_auth_me/rx.dart';
import 'package:teamstreakpromo/features/auth/model/auth_me_model.dart';

final SignUpRx signUpRxObj = SignUpRx(
  empty: UserSignupModel(),
  dataFetcher: BehaviorSubject<UserSignupModel>(),
);

final ResetPasswordRx resetPasswordRxObj = ResetPasswordRx(
  empty: ResetPasswordModel(),
  dataFetcher: BehaviorSubject<ResetPasswordModel>(),
);

final VerifyForgotPasswordOtpRx verifyForgotPasswordOtpRxObj =
    VerifyForgotPasswordOtpRx(
      empty: VerifyForgotPasswordOtpModel(),
      dataFetcher: BehaviorSubject<VerifyForgotPasswordOtpModel>(),
    );

final ForgotPasswordRx forgotPasswordRxObj = ForgotPasswordRx(
  empty: ForgotPasswordModel(),
  dataFetcher: BehaviorSubject<ForgotPasswordModel>(),
);

final RefreshTokenRx refreshTokenRxObj = RefreshTokenRx(
  empty: RefreshTokenModel(),
  dataFetcher: BehaviorSubject<RefreshTokenModel>(),
);

final LogInRx logInRxObj = LogInRx(
  empty: UserLoginModel(),
  dataFetcher: BehaviorSubject<UserLoginModel>(),
);

final VerifyRegisterOtpRx verifyRegisterOtpRxObj = VerifyRegisterOtpRx(
  empty: VerifyRegisterOtpModel(),
  dataFetcher: BehaviorSubject<VerifyRegisterOtpModel>(),
);

final ResendRegisterOtpRx resendRegisterOtpRxObj = ResendRegisterOtpRx(
  empty: ResendRegisterOtpModel(),
  dataFetcher: BehaviorSubject<ResendRegisterOtpModel>(),
);

final LogOutRx logOutRxObj = LogOutRx(
  empty: LogoutModel(),
  dataFetcher: BehaviorSubject<LogoutModel>(),
);

final GetCategoriesRx getCategoriesRxObj = GetCategoriesRx(
  empty: IntrestCategoryModel(),
  dataFetcher: BehaviorSubject<IntrestCategoryModel>(),
);

final GetSubCategoriesRx getSubCategoriesRxObj = GetSubCategoriesRx(
  empty: IntrestCategoryModel(),
  dataFetcher: BehaviorSubject<IntrestCategoryModel>(),
);

final CreateEventRx createEventRxObj = CreateEventRx(
  empty: CreateEventResponseModel(),
  dataFetcher: BehaviorSubject<CreateEventResponseModel>(),
);

final DeleteEventRx deleteEventRxObj = DeleteEventRx(
  empty: DeleteEventResponseModel(),
  dataFetcher: BehaviorSubject<DeleteEventResponseModel>(),
);

final GetEventDetailsRx getEventDetailsRxObj = GetEventDetailsRx(
  empty: HostEventDetailsModel(),
  dataFetcher: BehaviorSubject<HostEventDetailsModel>(),
);

final GetEventsByCategoryRx getEventsByCategoryRxObj = GetEventsByCategoryRx(
  empty: EventFetchByCategoryModel(),
  dataFetcher: BehaviorSubject<EventFetchByCategoryModel>(),
);

final AuthMeRx authMeRxObj = AuthMeRx(
  empty: AuthMeModel(),
  dataFetcher: BehaviorSubject<AuthMeModel>(),
);

final UpdateEventRx updateEventRxObj = UpdateEventRx(
  empty: CreateEventResponseModel(),
  dataFetcher: BehaviorSubject<CreateEventResponseModel>(),
);

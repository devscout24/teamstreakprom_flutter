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

final SignUpRx signUpRxObj = SignUpRx(
  empty: UserSignupModel(),
  dataFetcher: BehaviorSubject<UserSignupModel>(),
);

final ResetPasswordRx resetPasswordRxObj = ResetPasswordRx(
  empty: ResetPasswordModel(),
  dataFetcher: BehaviorSubject<ResetPasswordModel>(),
);

final VerifyForgotPasswordOtpRx verifyForgotPasswordOtpRxObj = VerifyForgotPasswordOtpRx(
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

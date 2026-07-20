import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';

class SubmitProblemScreen extends StatefulWidget {
  final String topic;

  const SubmitProblemScreen({super.key, required this.topic});

  @override
  State<SubmitProblemScreen> createState() => _SubmitProblemScreenState();
}

class _SubmitProblemScreenState extends State<SubmitProblemScreen> {
  final TextEditingController _problemController = TextEditingController();

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const CustomBackButton(),
            title: Text(
              "Streak Customer Support",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
              child: Column(
                children: [
                  const Spacer(),
                  GradientContainer(
                    padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Topic Container
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Topic: ",
                                style: TextFontStyle
                                    .textStyle14cFFFFFFSFProRounded400
                                    .copyWith(
                                      color: AppColors.cBCBCBB,
                                      fontSize: 13.sp,
                                    ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.topic,
                                  style: TextFontStyle
                                      .textStyle14cFFFFFFSFProRounded400
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "SF Pro",
                                        fontSize: 14.sp,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        UIHelper.verticalSpace(24.h),
                        Text(
                          "Write your problem details",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                fontFamily: "SF Pro",
                              ),
                        ),
                        UIHelper.verticalSpace(12.h),
                        TextField(
                          controller: _problemController,
                          maxLines: 6,
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(color: Colors.white, fontSize: 14.sp),
                          decoration: InputDecoration(
                            hintText: "type your problem...",
                            hintStyle: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: AppColors.c9B9C9A,
                                  fontSize: 13.sp,
                                ),
                            filled: true,
                            fillColor: Colors.transparent,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.primaryColorFirst,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        UIHelper.verticalSpace(24.h),
                        CustomGradientButton(
                          onPressed: () {
                            if (_problemController.text.trim().isNotEmpty) {
                              NavigationService.navigateToWithArgs(
                                Routes.supportChatScreen,
                                {
                                  'topic': widget.topic,
                                  'problem': _problemController.text.trim(),
                                },
                              );
                            }
                          },
                          title: "Submit",
                          height: 52.h,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

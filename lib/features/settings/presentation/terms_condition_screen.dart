import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_app_bar.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/di.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/api_acess.dart';
import '../model/static_content_model.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContents();
  }

  String _getTermsSlug() {
    final rawType =
        appData.read(kAccountType)?.toString().toLowerCase().trim() ?? '';
    final profileRole = userProfileRxObj
            .userProfileData.valueOrNull?.data?.role
            ?.toLowerCase()
            .trim() ??
        '';

    final effectiveType = rawType.isNotEmpty ? rawType : profileRole;

    if (effectiveType == 'host' || effectiveType == 'accounttype.host') {
      return 'terms-of-service-host';
    } else if (effectiveType == 'business' ||
        effectiveType == 'businesspartner' ||
        effectiveType == 'accounttype.businesspartner') {
      return 'terms-of-service-business';
    } else {
      return 'terms-of-service-user';
    }
  }

  Future<void> _fetchContents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final slug = _getTermsSlug();
      await getStaticContentsRxObj.fetchStaticContents(slug: slug);
    } catch (e) {
      debugPrint("Failed to fetch static contents: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _stripHtml(String htmlString) {
    String parsed = htmlString
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<li[^>]*>', caseSensitive: false), '• ')
        .replaceAll(
          RegExp(
            r'</(p|div|li|h1|h2|h3|h4|h5|h6|tr|ul|ol)>',
            caseSensitive: false,
          ),
          '\n\n',
        )
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'")
        .trim();

    parsed = parsed.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return parsed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: const CustomAppBar(title: "Terms & Conditions"),
      body: StreamBuilder<StaticContentModel>(
        stream: getStaticContentsRxObj.getStaticContentsData,
        builder: (context, snapshot) {
          final hasData = snapshot.hasData &&
              snapshot.data?.data != null &&
              snapshot.data!.data!.isNotEmpty;

          if (_isLoading && !hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColorFirst,
              ),
            );
          }

          if (snapshot.hasError && !hasData) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48.sp,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    UIHelper.verticalSpace(12.h),
                    Text(
                      'Failed to load Terms & Conditions',
                      textAlign: TextAlign.center,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            fontFamily: 'SF Pro',
                            fontSize: 16.sp,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                    ),
                    UIHelper.verticalSpace(12.h),
                    TextButton(
                      onPressed: _fetchContents,
                      child: const Text(
                        'Try Again',
                        style: TextStyle(color: AppColors.primaryColorFirst),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final allItems = snapshot.data?.data ?? [];
          final currentSlug = _getTermsSlug();

          // Prefer items matching the specific slug for this account type
          final matchingItems = allItems.where((item) {
            return item.slug?.toLowerCase() == currentSlug.toLowerCase();
          }).toList();

          final displayList =
              matchingItems.isNotEmpty ? matchingItems : allItems;

          if (displayList.isEmpty) {
            return Center(
              child: Text(
                'No Terms & Conditions available',
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  fontFamily: 'SF Pro',
                  fontSize: 16.sp,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primaryColorFirst,
            backgroundColor: AppColors.scaffoldColor,
            onRefresh: _fetchContents,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < displayList.length; i++) ...[
                    _buildContentItem(displayList[i]),
                    if (i < displayList.length - 1)
                      UIHelper.verticalSpace(24.h),
                  ],
                  UIHelper.verticalSpace(32.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentItem(StaticContentItem item) {
    final title = item.title?.trim() ?? '';
    final content = item.content?.trim() ?? '';
    final cleanContent = content.isNotEmpty ? _stripHtml(content) : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
              fontSize: 16.sp,
              color: AppColors.cF3F3F3,
              fontWeight: FontWeight.w600,
            ),
          ),
          UIHelper.verticalSpace(12.h),
        ],
        if (cleanContent.isNotEmpty)
          Text(
            cleanContent,
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: AppColors.cBCBCBB,
              fontFamily: "SF Pro",
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
      ],
    );
  }
}

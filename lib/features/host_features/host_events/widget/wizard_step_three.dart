import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/host_features/host_events/model/event_model.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';
import '../../auth/widget/custom_selector_field.dart';
import '../../auth/widget/document_upload_widget.dart';

class WizardStepThree extends StatelessWidget {
  final List<ArtistFormModel> artistForms;
  final VoidCallback onAddArtist;
  final ValueChanged<int> onRemoveArtist;
  final ValueChanged<int> onAddSocialLink;
  final void Function(int artistIndex, int linkIndex) onRemoveSocialLink;
  final ValueChanged<int> onArtistPhotoTap;
  final ValueChanged<int> onArtistPhotoRemove;
  final void Function(int artistIndex, int linkIndex) onSocialLinkEdit;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  const WizardStepThree({
    super.key,
    required this.artistForms,
    required this.onAddArtist,
    required this.onRemoveArtist,
    required this.onAddSocialLink,
    required this.onRemoveSocialLink,
    required this.onArtistPhotoTap,
    required this.onArtistPhotoRemove,
    required this.onSocialLinkEdit,
    required this.onContinue,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Artist Details",
                    style: TextStyle(
                      fontFamily: "SF Pro Rounded",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  UIHelper.verticalSpace(8),
                  Text(
                    "Add artist details to help attendees learn more about the event.",
                    style: TextStyle(
                      fontFamily: "SF Pro",
                      fontSize: 14.sp,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            UIHelper.horizontalSpace(16),
            GestureDetector(
              onTap: onSkip,
              child: Container(
                height: 32.h,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColorFirst,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  "Skip",
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        UIHelper.verticalSpace(24),

        // Render saved artists as cards
        if (artistForms.length > 1) ...[
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: artistForms.length - 1,
            separatorBuilder: (context, index) => UIHelper.verticalSpace(16),
            itemBuilder: (context, index) {
              return _buildArtistCard(artistForms[index], () => onRemoveArtist(index));
            },
          ),
          UIHelper.verticalSpace(24),
          const Divider(color: Colors.white12, height: 1),
          UIHelper.verticalSpace(24),
        ],

        // Render the active artist form block
        _buildArtistForm(context, artistForms.last, artistForms.length - 1),
        UIHelper.verticalSpace(24),

        // "+ Add Another Artist" outlined button at the very bottom
        GestureDetector(
          onTap: onAddArtist,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.primaryColorFirst,
                width: 1.5.w,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: AppColors.primaryColorFirst, size: 18.w),
                UIHelper.horizontalSpace(4),
                Text(
                  "Add Another Artist",
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColorFirst,
                  ),
                ),
              ],
            ),
          ),
        ),
        UIHelper.verticalSpace(30),

        // Continue Button
        _buildContinueButton(onContinue),
        UIHelper.verticalSpace(30),
      ],
    );
  }

  Widget _buildArtistCard(ArtistFormModel artist, VoidCallback onRemove) {
    return GradientContainer(
      padding: EdgeInsets.all(12.w),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // White rounded image container
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                clipBehavior: Clip.hardEdge,
                child: artist.photoPath != null
                    ? Image.file(
                        File(artist.photoPath!),
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80.w,
                          height: 80.w,
                          color: AppColors.c242A34,
                          child: Icon(
                            Icons.person,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: AppColors.c242A34,
                        size: 40.w,
                      ),
              ),
              UIHelper.horizontalSpace(12),
              // Text Content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artist.nameController.text.isNotEmpty
                          ? artist.nameController.text
                          : "Unnamed Artist",
                      style: TextStyle(
                        fontFamily: "SF Pro",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    UIHelper.verticalSpace(6),
                    Text(
                      artist.designationController.text,
                      style: TextStyle(
                        fontFamily: "SF Pro",
                        fontSize: 12.sp,
                        color: AppColors.cBCBCBB,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Space for close button
              UIHelper.horizontalSpace(32),
            ],
          ),
          // Close button positioned top right
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close_rounded, color: Colors.red, size: 16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtistForm(
      BuildContext context, ArtistFormModel artist, int artistIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Artist Name
        _buildLabel("Artist Name"),
        _buildTextField(
          controller: artist.nameController,
          hint: "e.g. Adam Levine",
        ),
        UIHelper.verticalSpace(16),

        // Designation
        _buildLabel("Designation"),
        _buildTextField(
          controller: artist.designationController,
          hint: "e.g. Singer / Guitarist",
        ),
        UIHelper.verticalSpace(16),

        // Artist Photo
        DocumentUploadWidget(
          label: "Artist Photo",
          fileName: artist.photoPath != null
              ? artist.photoPath!.split('/').last
              : null,
          onTap: () => onArtistPhotoTap(artistIndex),
          onRemove: () => onArtistPhotoRemove(artistIndex),
        ),
        UIHelper.verticalSpace(16),

        // Dynamic Multiple Social Media Links for this Artist
        _buildLabel("Add Social Media Link"),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: artist.socialLinks.length,
          separatorBuilder: (context, index) => UIHelper.verticalSpace(12),
          itemBuilder: (context, linkIndex) {
            final social = artist.socialLinks[linkIndex];
            final hasUrl = social.urlController.text.isNotEmpty;

            IconData platformIcon = Icons.link;
            if (social.platform.toLowerCase() == "facebook") {
              platformIcon = Icons.facebook;
            } else if (social.platform.toLowerCase() == "instagram") {
              platformIcon = Icons.camera_alt_outlined;
            } else if (social.platform.toLowerCase() == "twitter") {
              platformIcon = Icons.alternate_email;
            } else if (social.platform.toLowerCase() == "youtube") {
              platformIcon = Icons.play_circle_outline;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomSelectorField(
                        value: social.platform,
                        hintText: "Platform",
                        onTap: () => onSocialLinkEdit(artistIndex, linkIndex),
                      ),
                    ),
                    if (linkIndex > 0) ...[
                      UIHelper.horizontalSpace(8),
                      GestureDetector(
                        onTap: () => onRemoveSocialLink(artistIndex, linkIndex),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: const BoxDecoration(
                            color: Colors.white10,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                            size: 18.w,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (hasUrl) ...[
                  UIHelper.verticalSpace(8),
                  Row(
                    children: [
                      Icon(
                        platformIcon,
                        color: Colors.white,
                        size: 16.w,
                      ),
                      UIHelper.horizontalSpace(8),
                      Expanded(
                        child: Text(
                          social.urlController.text,
                          style: TextStyle(
                            fontFamily: "SF Pro",
                            fontSize: 12.sp,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blueAccent,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
        UIHelper.verticalSpace(12),

        // Button to add another social link for this artist
        GestureDetector(
          onTap: () => onAddSocialLink(artistIndex),
          child: Row(
            children: [
              Icon(
                Icons.add,
                color: AppColors.primaryColorSecond,
                size: 16.w,
              ),
              UIHelper.horizontalSpace(4),
              Text(
                "Add Social Link",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColorSecond,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: "SF Pro Rounded",
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    Widget? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(
        fontFamily: "SF Pro",
        fontSize: 14.sp,
        color: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "This field is required";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: "SF Pro",
          fontSize: 14.sp,
          color: Colors.white.withValues(alpha: 0.3),
        ),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: const Color(0xFF1E222B),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: maxLines > 1 ? 14.h : 16.h,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColors.primaryColorFirst,
            width: 1.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.redAccent, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.redAccent, width: 1.w),
        ),
      ),
    );
  }

  Widget _buildContinueButton(VoidCallback onPressed) {
    return CustomGradientButton(
      onPressed: onPressed,
      title: "Continue",
      borderRadius: BorderRadius.circular(16.r),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/host_features/host_events/model/event_model.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
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
  final void Function(int artistIndex, int linkIndex) onSocialPlatformTap;
  final VoidCallback onContinue;

  const WizardStepThree({
    super.key,
    required this.artistForms,
    required this.onAddArtist,
    required this.onRemoveArtist,
    required this.onAddSocialLink,
    required this.onRemoveSocialLink,
    required this.onArtistPhotoTap,
    required this.onArtistPhotoRemove,
    required this.onSocialPlatformTap,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        UIHelper.verticalSpace(24),

        // Render each artist form block
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: artistForms.length,
          separatorBuilder: (context, index) => Column(
            children: [
              UIHelper.verticalSpace(24),
              const Divider(color: Colors.white12, height: 1),
              UIHelper.verticalSpace(24),
            ],
          ),
          itemBuilder: (context, artistIndex) {
            final artist = artistForms[artistIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Artist #${artistIndex + 1}",
                      style: TextStyle(
                        fontFamily: "SF Pro Rounded",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColorFirst,
                      ),
                    ),
                    if (artistIndex > 0)
                      GestureDetector(
                        onTap: () => onRemoveArtist(artistIndex),
                        child: Text(
                          "Remove",
                          style: TextStyle(
                            fontFamily: "SF Pro",
                            fontSize: 13.sp,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                UIHelper.verticalSpace(16),

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
                  fileName: artist.photoPath != null ? artist.photoPath!.split('/').last : null,
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
                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomSelectorField(
                            value: social.platform,
                            hintText: "Platform",
                            onTap: () => onSocialPlatformTap(artistIndex, linkIndex),
                          ),
                        ),
                        UIHelper.horizontalSpace(12),
                        Expanded(
                          flex: 3,
                          child: _buildTextField(
                            controller: social.urlController,
                            hint: "Social URL",
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
                    );
                  },
                ),
                UIHelper.verticalSpace(12),

                // Button to add another social link for this artist
                GestureDetector(
                  onTap: () => onAddSocialLink(artistIndex),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: AppColors.primaryColorSecond, size: 16.w),
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
          },
        ),
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: maxLines > 1 ? 14.h : 16.h),
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
          borderSide: BorderSide(
            color: Colors.redAccent,
            width: 1.w,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.redAccent,
            width: 1.w,
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF28F31),
              Color(0xFF72E84F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          "Continue",
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

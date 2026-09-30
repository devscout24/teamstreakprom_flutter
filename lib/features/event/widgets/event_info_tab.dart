import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/features/event/model/host_event_details_model.dart';
import 'package:teamstreakpromo/features/event/widgets/event_details_widgets.dart';

class EventInfoTab extends StatelessWidget {
  final bool isHost;
  final String displayDescription;
  final List<ArtistInfo> artists;
  final String formattedEndDate;
  final String timeLeft;
  final int? ageRestriction;
  final int? stock;
  final HostId? host;
  final double? latitude;
  final double? longitude;
  final String? placeName;
  final String? eventTitle;

  const EventInfoTab({
    super.key,
    required this.isHost,
    required this.displayDescription,
    required this.artists,
    required this.formattedEndDate,
    required this.timeLeft,
    required this.ageRestriction,
    required this.stock,
    this.host,
    this.latitude,
    this.longitude,
    this.placeName,
    this.eventTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        UIHelper.verticalSpace(8.h),
        Text(
          displayDescription,
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13.sp,
            height: 1.5,
          ),
        ),
        UIHelper.verticalSpace(24.h),

        // Divider line
        Divider(color: Colors.white.withValues(alpha: 0.08)),
        UIHelper.verticalSpace(16.h),

        Text(
          "Artist Info",
          style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
            fontSize: 14.sp,
            color: AppColors.c848484,
            fontWeight: FontWeight.bold,
          ),
        ),
        UIHelper.verticalSpace(12.h),

        // Artist profile cards
        if (artists.isNotEmpty)
          ...artists.map((artist) => ArtistCard(artist: artist))
        else
          Row(
            children: [
              UIHelper.horizontalSpace(12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No artists listed",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        UIHelper.verticalSpace(16.h),

        UIHelper.verticalSpace(24.h),

        // Timeline Alert container box
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryColorFirst.withValues(alpha: 0.1),
                AppColors.primaryColorSecond.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "End Date : ",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 13.sp,
                            fontFamily: 'SF Pro',
                          ),
                      children: [
                        TextSpan(
                          text: formattedEndDate,
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    timeLeft,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: AppColors.cF54141,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(12.h),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryColorFirst,
                    size: 16.sp,
                  ),
                  UIHelper.horizontalSpace(8.w),
                  Expanded(
                    child: Text(
                      "This event is only for who are above ${ageRestriction ?? 18} years old.",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: AppColors.primaryColorFirst,
                            fontSize: 11.sp,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        UIHelper.verticalSpace(24.h),

        // Host section
        Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundImage: (host?.profileImage != null &&
                      host!.profileImage!.isNotEmpty)
                  ? NetworkImage(host!.profileImage!) as ImageProvider
                  : AssetImage(Assets.images.placeholderImage.path),
            ),
            UIHelper.horizontalSpace(12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  host?.name ?? "Unknown Host",
                  style:
                      TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "SF Pro",
                  ),
                ),
                UIHelper.verticalSpace(4.h),
                Text(
                  "Host",
                  style:
                      TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        UIHelper.verticalSpace(16.h),

        // Seat info line
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.confirmation_num_outlined,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 16.sp,
                ),
                UIHelper.horizontalSpace(6.w),
                Text(
                  "Buy this ticket & get 1 point",
                  style:
                      TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.event_seat, color: AppColors.cDC822D, size: 16.sp),
                UIHelper.horizontalSpace(6.w),
                Text(
                  "${stock ?? 0} seat remaining",
                  style:
                      TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                    color: AppColors.cDC822D,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        UIHelper.verticalSpace(24.h),

        // Location Section with map
        Text(
          "Location:",
          style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        UIHelper.verticalSpace(12.h),

        // Map container
        Container(
          height: 180.h,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: _buildGoogleMap(context),
          ),
        ),
        UIHelper.verticalSpace(24.h),

        // Refer section
        if (!isHost) ...[
          Container(
            height: 52.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryColorFirst,
                  AppColors.primaryColorSecond,
                ],
              ),
            ),
            padding: EdgeInsets.all(1.w),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF171A20),
                borderRadius: BorderRadius.circular(100.r),
              ),
              alignment: Alignment.center,
              child: Text(
                "Refer your friend",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  fontFamily: "SF Pro",
                ),
              ),
            ),
          ),
          UIHelper.verticalSpace(12.h),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primaryColorFirst,
                size: 16.sp,
              ),
              UIHelper.horizontalSpace(8.w),
              Expanded(
                child: Text(
                  "You'll receive 1 point only after your friend purchases a ticket.",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: AppColors.primaryColorFirst,
                        fontSize: 11.sp,
                      ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    final hasValidCoordinates = latitude != null &&
        longitude != null &&
        latitude != 0.0 &&
        longitude != 0.0;

    // Use event coordinates or default fallback
    final targetLatLng = hasValidCoordinates
        ? LatLng(latitude!, longitude!)
        : const LatLng(37.7749, -122.4194);

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('event_location'),
        position: targetLatLng,
        infoWindow: InfoWindow(
          title: eventTitle ?? "Event Location",
          snippet: placeName ?? "Event Venue",
        ),
      ),
    };

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: targetLatLng,
            zoom: 14.0,
          ),
          markers: markers,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: false,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
        ),
        // Overlay button to open in Google Maps app / browser
        Positioned(
          bottom: 10.h,
          right: 10.w,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openInGoogleMaps(
                targetLatLng.latitude,
                targetLatLng.longitude,
              ),
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldColor.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.directions,
                      color: AppColors.primaryColorSecond,
                      size: 14.sp,
                    ),
                    UIHelper.horizontalSpace(4.w),
                    Text(
                      "Open in Maps",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openInGoogleMaps(double lat, double lng) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }
}


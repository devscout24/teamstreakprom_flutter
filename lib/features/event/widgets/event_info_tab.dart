import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/features/event/model/host_event_details_model.dart';
import 'package:teamstreakpromo/features/event/widgets/event_details_widgets.dart';

class EventInfoTab extends StatefulWidget {
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
  State<EventInfoTab> createState() => _EventInfoTabState();
}

class _EventInfoTabState extends State<EventInfoTab> {
  BitmapDescriptor? _customMarkerIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    try {
      final ByteData byteData =
          await rootBundle.load(Assets.icons.splashLogo.path);
      final ui.Codec codec = await ui.instantiateImageCodec(
        byteData.buffer.asUint8List(),
        targetWidth: 28,
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image rawImage = frameInfo.image;
      final int width = rawImage.width;
      final int height = rawImage.height;

      // Tint logo with app default gradient
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final Rect rect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());

      canvas.drawImage(rawImage, Offset.zero, Paint());

      final Paint gradientPaint = Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(width.toDouble(), height.toDouble()),
          [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
        )
        ..blendMode = BlendMode.srcIn;

      canvas.drawRect(rect, gradientPaint);

      final ui.Picture picture = recorder.endRecording();
      final ui.Image tintedImage = await picture.toImage(width, height);
      final ByteData? byteDataResult = await tintedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteDataResult != null && mounted) {
        setState(() {
          _customMarkerIcon = BitmapDescriptor.bytes(
            byteDataResult.buffer.asUint8List(),
          );
        });
      }
    } catch (_) {
      try {
        final icon = await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(16, 16)),
          Assets.icons.splashLogo.path,
        );
        if (mounted) {
          setState(() {
            _customMarkerIcon = icon;
          });
        }
      } catch (_) {}
    }
  }

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
          widget.displayDescription,
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
        if (widget.artists.isNotEmpty)
          ...widget.artists.map((artist) => ArtistCard(artist: artist))
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
                          text: widget.formattedEndDate,
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
                    widget.timeLeft,
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
                      "This event is only for who are above ${widget.ageRestriction ?? 18} years old.",
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
              backgroundImage: (widget.host?.profileImage != null &&
                      widget.host!.profileImage!.isNotEmpty)
                  ? NetworkImage(widget.host!.profileImage!) as ImageProvider
                  : AssetImage(Assets.images.placeholderImage.path),
            ),
            UIHelper.horizontalSpace(12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.host?.name ?? "Unknown Host",
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
                  "${widget.stock ?? 0} seat remaining",
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
        if (!widget.isHost) ...[
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
    final hasValidCoordinates = widget.latitude != null &&
        widget.longitude != null &&
        widget.latitude != 0.0 &&
        widget.longitude != 0.0;

    // Use event coordinates or default fallback
    final targetLatLng = hasValidCoordinates
        ? LatLng(widget.latitude!, widget.longitude!)
        : const LatLng(37.7749, -122.4194);

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('event_location'),
        position: targetLatLng,
        icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: widget.eventTitle ?? "Event Location",
          snippet: widget.placeName ?? "Event Venue",
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


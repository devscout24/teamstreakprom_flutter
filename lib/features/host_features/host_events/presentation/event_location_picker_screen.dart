import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/google_places_service.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

class LocationResult {
  final String address;
  final double latitude;
  final double longitude;

  const LocationResult({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class EventLocationPickerScreen extends StatefulWidget {
  final String? initialAddress;
  final double? initialLatitude;
  final double? initialLongitude;

  const EventLocationPickerScreen({
    super.key,
    this.initialAddress,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<EventLocationPickerScreen> createState() =>
      _EventLocationPickerScreenState();
}

class _EventLocationPickerScreenState extends State<EventLocationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  GoogleMapController? _mapController;
  late LatLng _currentPosition;
  String _currentAddress = "";
  bool _isGeocoding = false;
  bool _isLoadingPredictions = false;
  bool _isFetchingCurrentLocation = false;
  List<PlacePrediction> _predictions = [];
  Timer? _searchDebounce;
  Timer? _geocodeDebounce;

  static const LatLng _defaultLocation = LatLng(40.7128, -74.0060); // Default fallback NYC

  @override
  void initState() {
    super.initState();

    final hasValidInitialCoords = widget.initialLatitude != null &&
        widget.initialLongitude != null &&
        widget.initialLatitude != 0.0 &&
        widget.initialLongitude != 0.0;

    if (hasValidInitialCoords) {
      _currentPosition =
          LatLng(widget.initialLatitude!, widget.initialLongitude!);
      _currentAddress = widget.initialAddress?.trim().isNotEmpty == true
          ? widget.initialAddress!
          : "Selected Location";
    } else {
      _currentPosition = _defaultLocation;
      _currentAddress = "Locating current location...";
      // Fetch user's current GPS location immediately
      _fetchUserCurrentLocation(animateMap: true);
    }

    if (widget.initialAddress?.trim().isNotEmpty == true &&
        !widget.initialAddress!.toLowerCase().contains("locating") &&
        !widget.initialAddress!.toLowerCase().contains("selected location")) {
      _searchController.text = widget.initialAddress!;
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _geocodeDebounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  /// Request permission and fetch user's live current GPS location
  Future<void> _fetchUserCurrentLocation({bool animateMap = true}) async {
    setState(() => _isFetchingCurrentLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("Location services are disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );

        final userLatLng = LatLng(position.latitude, position.longitude);

        if (mounted) {
          setState(() {
            _currentPosition = userLatLng;
            _isFetchingCurrentLocation = false;
          });

          if (animateMap) {
            _mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: userLatLng, zoom: 16.0),
              ),
            );
          }

          _reverseGeocodePosition(userLatLng);
        }
        return;
      }
    } catch (e) {
      debugPrint("Error obtaining current location: $e");
    }

    if (mounted) {
      setState(() => _isFetchingCurrentLocation = false);
      if (_currentAddress == "Locating current location...") {
        _reverseGeocodePosition(_currentPosition);
      }
    }
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _predictions = [];
        _isLoadingPredictions = false;
      });
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 350), () async {
      setState(() => _isLoadingPredictions = true);
      final results =
          await GooglePlacesService.instance.getPlacePredictions(query);
      if (mounted) {
        setState(() {
          _predictions = results;
          _isLoadingPredictions = false;
        });
      }
    });
  }

  Future<void> _onSearchSubmitted(String query) async {
    if (query.trim().isEmpty) return;
    _searchFocusNode.unfocus();
    setState(() => _isLoadingPredictions = true);

    final results =
        await GooglePlacesService.instance.getPlacePredictions(query);
    if (!mounted) return;

    if (results.isNotEmpty) {
      await _selectPlace(results.first);
    } else {
      setState(() => _isLoadingPredictions = false);
    }
  }

  Future<void> _selectPlace(PlacePrediction prediction) async {
    _searchFocusNode.unfocus();
    setState(() {
      _isLoadingPredictions = true;
      _predictions = [];
      _searchController.text = prediction.mainText.isNotEmpty
          ? prediction.mainText
          : prediction.description;
    });

    final detail = await GooglePlacesService.instance.getPlaceDetails(
      prediction.placeId,
      prediction: prediction,
    );
    if (!mounted) return;

    if (detail != null) {
      final newLatLng = LatLng(detail.latitude, detail.longitude);
      setState(() {
        _currentPosition = newLatLng;
        _currentAddress = detail.formattedAddress;
        _isLoadingPredictions = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newLatLng, zoom: 16.0),
        ),
      );
    } else if (prediction.latitude != null && prediction.longitude != null) {
      final newLatLng = LatLng(prediction.latitude!, prediction.longitude!);
      setState(() {
        _currentPosition = newLatLng;
        _currentAddress = prediction.description;
        _isLoadingPredictions = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newLatLng, zoom: 16.0),
        ),
      );
    } else {
      setState(() {
        _currentAddress = prediction.description;
        _isLoadingPredictions = false;
      });
    }
  }

  void _onCameraMove(CameraPosition position) {
    _currentPosition = position.target;
  }

  void _onCameraIdle() {
    _geocodeDebounce?.cancel();
    _geocodeDebounce = Timer(const Duration(milliseconds: 400), () {
      _reverseGeocodePosition(_currentPosition);
    });
  }

  Future<void> _reverseGeocodePosition(LatLng latLng) async {
    if (!mounted) return;
    setState(() => _isGeocoding = true);

    final address = await GooglePlacesService.instance
        .reverseGeocode(latLng.latitude, latLng.longitude);

    if (mounted) {
      setState(() {
        _isGeocoding = false;
        if (address != null && address.isNotEmpty) {
          _currentAddress = address;
        }
      });
    }
  }

  void _confirmLocation() {
    final result = LocationResult(
      address: _currentAddress.isNotEmpty
          ? _currentAddress
          : "${_currentPosition.latitude.toStringAsFixed(5)}, ${_currentPosition.longitude.toStringAsFixed(5)}",
      latitude: _currentPosition.latitude,
      longitude: _currentPosition.longitude,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131722),
      body: SafeArea(
        child: Stack(
          children: [
            // ── Map View ─────────────────────────────────────────────
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 15.0,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                  // If we already obtained user current position, center on it
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(_currentPosition, 16.0),
                  );
                },
                onCameraMove: _onCameraMove,
                onCameraIdle: _onCameraIdle,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                compassEnabled: true,
                mapToolbarEnabled: false,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
              ),
            ),

            // ── Fixed Center Pin (Adjust Pin Manually) ─────────────────
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 36.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E222B),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColors.primaryColorFirst
                              .withValues(alpha: 0.6),
                          width: 1.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            color: AppColors.primaryColorFirst,
                            size: 14.sp,
                          ),
                          UIHelper.horizontalSpace(4),
                          Text(
                            "Move map to adjust pin",
                            style: TextStyle(
                              fontFamily: "SF Pro",
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpace(6),
                    Icon(
                      Icons.location_pin,
                      color: AppColors.primaryColorFirst,
                      size: 42.sp,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.7),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    Container(
                      width: 8.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Top Header & Places Autocomplete Search Bar ───────────
            Positioned(
              top: 12.h,
              left: 16.w,
              right: 16.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Bar Row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E222B),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 20.w,
                          ),
                        ),
                      ),
                      UIHelper.horizontalSpace(12),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E222B),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Text(
                            "Select Event Location",
                            style: TextStyle(
                              fontFamily: "SF Pro Rounded",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(10),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E222B),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppColors.primaryColorFirst
                            .withValues(alpha: 0.3),
                        width: 1.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      onChanged: _onSearchChanged,
                      onSubmitted: _onSearchSubmitted,
                      textInputAction: TextInputAction.search,
                      style: TextStyle(
                        fontFamily: "SF Pro",
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search location or address...",
                        hintStyle: TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        prefixIcon: GestureDetector(
                          onTap: () => _onSearchSubmitted(_searchController.text),
                          child: Icon(
                            Icons.search_rounded,
                            color: AppColors.primaryColorFirst,
                            size: 22.sp,
                          ),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  size: 18.sp,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged("");
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 14.h,
                        ),
                      ),
                    ),
                  ),

                  // Autocomplete Predictions List
                  if (_isLoadingPredictions || _predictions.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 6.h),
                      constraints: BoxConstraints(maxHeight: 240.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: const Color(0xFF1E222B),
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: _isLoadingPredictions
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primaryColorFirst,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                itemCount: _predictions.length,
                                separatorBuilder: (context, index) => Divider(
                                  color: Colors.white.withValues(alpha: 0.06),
                                  height: 1.h,
                                ),
                                itemBuilder: (context, index) {
                                  final item = _predictions[index];
                                  return InkWell(
                                    onTap: () => _selectPlace(item),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14.w,
                                        vertical: 10.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(6.w),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColorFirst
                                                  .withValues(alpha: 0.15),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              color: AppColors.primaryColorFirst,
                                              size: 16.sp,
                                            ),
                                          ),
                                          UIHelper.horizontalSpace(10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  item.mainText,
                                                  style: TextStyle(
                                                    fontFamily: "SF Pro",
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                if (item
                                                    .secondaryText.isNotEmpty) ...[
                                                  UIHelper.verticalSpace(2),
                                                  Text(
                                                    item.secondaryText,
                                                    style: TextStyle(
                                                      fontFamily: "SF Pro",
                                                      fontSize: 11.sp,
                                                      color: Colors.white
                                                          .withValues(
                                                              alpha: 0.5),
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Floating Action: GPS / My Location Button ─────────────
            Positioned(
              right: 16.w,
              bottom: 175.h,
              child: GestureDetector(
                onTap: () => _fetchUserCurrentLocation(animateMap: true),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E222B),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _isFetchingCurrentLocation
                      ? SizedBox(
                          width: 22.sp,
                          height: 22.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryColorFirst,
                          ),
                        )
                      : Icon(
                          Icons.my_location_rounded,
                          color: AppColors.primaryColorFirst,
                          size: 22.sp,
                        ),
                ),
              ),
            ),

            // ── Bottom Confirmation Card ──────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 18.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E222B),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    UIHelper.verticalSpace(12),

                    // Address Info Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColorFirst
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: AppColors.primaryColorFirst,
                            size: 20.sp,
                          ),
                        ),
                        UIHelper.horizontalSpace(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Event Location",
                                style: TextStyle(
                                  fontFamily: "SF Pro Rounded",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                              UIHelper.verticalSpace(4),
                              _isGeocoding
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          width: 14.w,
                                          height: 14.w,
                                          child:
                                              const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primaryColorFirst,
                                          ),
                                        ),
                                        UIHelper.horizontalSpace(8),
                                        Text(
                                          "Fetching address...",
                                          style: TextStyle(
                                            fontFamily: "SF Pro",
                                            fontSize: 13.sp,
                                            color: Colors.white
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      _currentAddress.isNotEmpty
                                          ? _currentAddress
                                          : "Selected Coordinates",
                                      style: TextStyle(
                                        fontFamily: "SF Pro",
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              UIHelper.verticalSpace(4),
                              Text(
                                "Lat: ${_currentPosition.latitude.toStringAsFixed(5)}, Lng: ${_currentPosition.longitude.toStringAsFixed(5)}",
                                style: TextStyle(
                                  fontFamily: "SF Pro",
                                  fontSize: 11.sp,
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(16),

                    // Confirm Location Button
                    CustomGradientButton(
                      onPressed: _confirmLocation,
                      title: "Confirm Location",
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

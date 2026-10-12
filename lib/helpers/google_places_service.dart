import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:teamstreakpromo/networks/endpoints.dart';

class PlacePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;
  final double? latitude;
  final double? longitude;

  PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
    this.latitude,
    this.longitude,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    final structured = json['structured_formatting'] as Map<String, dynamic>?;
    return PlacePrediction(
      placeId: json['place_id'] as String? ?? '',
      description: json['description'] as String? ?? '',
      mainText: structured?['main_text'] as String? ??
          (json['description'] as String? ?? ''),
      secondaryText: structured?['secondary_text'] as String? ?? '',
    );
  }
}

class PlaceDetail {
  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String name;

  PlaceDetail({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    required this.name,
  });
}

class GooglePlacesService {
  static final GooglePlacesService _singleton = GooglePlacesService._internal();
  GooglePlacesService._internal();
  static GooglePlacesService get instance => _singleton;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'User-Agent': 'TeamStreakPromoApp/1.0 (contact@teamstreakpromo.com)',
      },
    ),
  );

  String get _apiKey => Endpoints.googleMapsApiKey;

  /// Fetches autocomplete predictions for a given search query.
  /// Falls back to OpenStreetMap / Geocoding if Google Places returns REQUEST_DENIED or empty.
  Future<List<PlacePrediction>> getPlacePredictions(String input) async {
    final query = input.trim();
    if (query.isEmpty) return [];

    // 1. Try Google Places Autocomplete API
    try {
      final autocompleteUrl =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=${Uri.encodeComponent(query)}'
          '&key=$_apiKey';

      final response = await _dio.get(autocompleteUrl);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['status'] == 'OK' && data['predictions'] != null) {
          final list = (data['predictions'] as List)
              .map((e) => PlacePrediction.fromJson(e as Map<String, dynamic>))
              .toList();
          if (list.isNotEmpty) {
            return list;
          }
        }
      }
    } catch (e) {
      debugPrint("Google Places API error: $e");
    }

    // 2. Try OpenStreetMap Nominatim Search
    try {
      final nominatimUrl =
          'https://nominatim.openstreetmap.org/search'
          '?q=${Uri.encodeComponent(query)}'
          '&format=json'
          '&addressdetails=1'
          '&limit=7';

      final response = await _dio.get(
        nominatimUrl,
        options: Options(headers: {
          'User-Agent': 'TeamStreakPromoApp/1.0 (contact@teamstreakpromo.com)',
        }),
      );

      if (response.statusCode == 200 && response.data is List) {
        final list = (response.data as List).map((e) {
          final map = e as Map<String, dynamic>;
          final displayName = map['display_name'] as String? ?? '';
          final name = map['name'] as String? ?? displayName;
          final lat = double.tryParse(map['lat']?.toString() ?? '') ?? 0.0;
          final lon = double.tryParse(map['lon']?.toString() ?? '') ?? 0.0;
          final placeId = map['place_id']?.toString() ?? '';

          final parts = displayName.split(',');
          final mainText = name.isNotEmpty ? name : (parts.isNotEmpty ? parts.first.trim() : displayName);
          final secondaryText = parts.length > 1 ? parts.sublist(1).take(3).join(',').trim() : '';

          return PlacePrediction(
            placeId: placeId,
            description: displayName,
            mainText: mainText,
            secondaryText: secondaryText,
            latitude: lat,
            longitude: lon,
          );
        }).where((p) => p.latitude != 0.0 && p.longitude != 0.0).toList();

        if (list.isNotEmpty) {
          return list;
        }
      }
    } catch (e) {
      debugPrint("Nominatim search error: $e");
    }

    // 3. Fallback to Google Geocoding API
    try {
      final geocodeUrl =
          'https://maps.googleapis.com/maps/api/geocode/json'
          '?address=${Uri.encodeComponent(query)}'
          '&key=$_apiKey';

      final response = await _dio.get(geocodeUrl);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['status'] == 'OK' && data['results'] != null) {
          final results = data['results'] as List;
          return results.map((e) {
            final formatted = e['formatted_address'] as String? ?? '';
            final placeId = e['place_id'] as String? ?? '';
            final geometry = e['geometry'] as Map<String, dynamic>?;
            final loc = geometry?['location'] as Map<String, dynamic>?;
            final lat = (loc?['lat'] as num?)?.toDouble();
            final lng = (loc?['lng'] as num?)?.toDouble();

            final parts = formatted.split(',');
            final main = parts.isNotEmpty ? parts.first.trim() : formatted;
            final secondary = parts.length > 1 ? parts.sublist(1).join(',').trim() : '';

            return PlacePrediction(
              placeId: placeId,
              description: formatted,
              mainText: main,
              secondaryText: secondary,
              latitude: lat,
              longitude: lng,
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint("Google Geocode search error: $e");
    }

    return [];
  }

  /// Fetches place details (lat, lng, formatted address) for a place_id
  Future<PlaceDetail?> getPlaceDetails(String placeId, {PlacePrediction? prediction}) async {
    // If prediction already has coordinates (from OpenStreetMap or Geocoding)
    if (prediction?.latitude != null &&
        prediction?.longitude != null &&
        prediction!.latitude != 0.0 &&
        prediction.longitude != 0.0) {
      return PlaceDetail(
        latitude: prediction.latitude!,
        longitude: prediction.longitude!,
        formattedAddress: prediction.description,
        name: prediction.mainText,
      );
    }

    if (placeId.isEmpty) return null;

    // Try Google Place Details API
    try {
      final url = 'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&fields=geometry,formatted_address,name'
          '&key=$_apiKey';

      final response = await _dio.get(url);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['status'] == 'OK' && data['result'] != null) {
          final result = data['result'] as Map<String, dynamic>;
          final geometry = result['geometry'] as Map<String, dynamic>?;
          final location = geometry?['location'] as Map<String, dynamic>?;

          if (location != null) {
            final lat = (location['lat'] as num?)?.toDouble() ?? 0.0;
            final lng = (location['lng'] as num?)?.toDouble() ?? 0.0;
            final formattedAddress = result['formatted_address'] as String? ??
                result['name'] as String? ??
                '';
            final name = result['name'] as String? ?? formattedAddress;

            return PlaceDetail(
              latitude: lat,
              longitude: lng,
              formattedAddress:
                  formattedAddress.isNotEmpty ? formattedAddress : name,
              name: name,
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Google Place Details error: $e");
    }

    return null;
  }

  /// Reverse geocodes coordinates to a human-readable address
  Future<String?> reverseGeocode(double lat, double lng) async {
    // 1. Try Google Geocoding API
    try {
      final url = 'https://maps.googleapis.com/maps/api/geocode/json'
          '?latlng=$lat,$lng'
          '&key=$_apiKey';

      final response = await _dio.get(url);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['status'] == 'OK' && data['results'] != null) {
          final results = data['results'] as List;
          if (results.isNotEmpty) {
            final first = results[0] as Map<String, dynamic>;
            final formattedAddress = first['formatted_address'] as String?;
            if (formattedAddress != null && formattedAddress.isNotEmpty) {
              return formattedAddress;
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Google reverse geocode error: $e");
    }

    // 2. Try OpenStreetMap Nominatim Reverse Geocoding
    try {
      final nominatimUrl =
          'https://nominatim.openstreetmap.org/reverse'
          '?lat=$lat'
          '&lon=$lng'
          '&format=json'
          '&addressdetails=1';

      final response = await _dio.get(
        nominatimUrl,
        options: Options(headers: {
          'User-Agent': 'TeamStreakPromoApp/1.0 (contact@teamstreakpromo.com)',
        }),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final displayName = data['display_name'] as String?;
        if (displayName != null && displayName.isNotEmpty) {
          return displayName;
        }
      }
    } catch (e) {
      debugPrint("Nominatim reverse geocode error: $e");
    }

    return null;
  }
}

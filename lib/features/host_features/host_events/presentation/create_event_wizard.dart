import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:teamstreakpromo/features/host_features/auth/widget/custom_selector_field.dart';
import 'package:teamstreakpromo/features/host_features/host_events/model/event_model.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import '../widget/wizard_progress_indicator.dart';
import '../widget/wizard_step_one.dart';
import '../widget/wizard_step_two.dart';
import '../widget/wizard_step_three.dart';
import '../widget/wizard_step_four.dart';
import '../widget/wizard_step_six.dart';
import 'package:teamstreakpromo/networks/api_acess.dart';
import 'package:teamstreakpromo/features/onboarding/model/intrest_category_model.dart';
import 'package:teamstreakpromo/helpers/di.dart';
import 'package:teamstreakpromo/features/host_features/host_events/data/rx_get_events/rx.dart';
import 'package:teamstreakpromo/features/event/model/host_event_details_model.dart'
    as hedm;
import 'package:intl/intl.dart';
import 'dart:convert';

class CreateEventWizard extends StatefulWidget {
  final hedm.Data? eventData;

  const CreateEventWizard({super.key, this.eventData});

  @override
  State<CreateEventWizard> createState() => _CreateEventWizardState();
}

class _CreateEventWizardState extends State<CreateEventWizard> {
  int _currentStep =
      1; // 1 to 4 represent wizard steps, 5 represents Overview page
  final _formKey = GlobalKey<FormState>();

  // Image Picker
  final ImagePicker _picker = ImagePicker();

  // Step 1 Controllers
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescController = TextEditingController();
  String? _selectedCategory;
  String? _selectedSubcategory;
  String? _selectedSubcategoryId;
  final TextEditingController _locationController = TextEditingController();

  // Step 2 Controllers
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final List<String> _eventPhotoPaths = [];
  String? _selectedAgeRestriction = "18+";

  // Step 3 Controllers (Artist Dynamic Forms list)
  final List<ArtistFormModel> _artistForms = [];

  // Step 4 & 5 Controllers (Rewards)
  final TextEditingController _rewardTitleController = TextEditingController();
  final TextEditingController _rewardDescController = TextEditingController();
  final List<String> _rewardPhotoPaths = [];
  final TextEditingController _rewardQuantityController =
      TextEditingController();
  final TextEditingController _rewardPointController = TextEditingController();
  final List<Map<String, dynamic>> _rewards = [];
  bool _isPostingEvent = false;

  @override
  void initState() {
    super.initState();
    getCategoriesRxObj.fetchCategories();

    if (widget.eventData != null) {
      final data = widget.eventData!;
      _eventNameController.text = data.title ?? "";
      _locationController.text = data.placeName ?? "";
      _priceController.text = data.ticketPrice?.toString() ?? "";
      _capacityController.text = data.stock?.toString() ?? "";
      _eventDescController.text = data.description ?? "";

      if (data.startDate != null) {
        _startDateController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(data.startDate!);
        _startTimeController.text = DateFormat('HH:mm').format(data.startDate!);
      }
      if (data.endDate != null) {
        _endDateController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(data.endDate!);
        _endTimeController.text = DateFormat('HH:mm').format(data.endDate!);
      }

      if (data.ageRestriction != null) {
        _selectedAgeRestriction = "${data.ageRestriction}+";
      }

      if (data.images != null && data.images!.isNotEmpty) {
        _eventPhotoPaths.addAll(data.images!);
      }

      if (data.artistInfo != null && data.artistInfo!.isNotEmpty) {
        for (var artist in data.artistInfo!) {
          _artistForms.add(
            ArtistFormModel(
              defaultName: artist.name ?? "",
              defaultRole: artist.role ?? "",
              photoPath: artist.image,
              defaultSocialLinks: [],
            ),
          );
        }
      } else {
        _artistForms.add(
          ArtistFormModel(
            defaultName: "",
            defaultRole: "",
            defaultSocialLinks: [
              SocialLinkModel(platform: "Facebook", defaultUrl: ""),
            ],
          ),
        );
      }

      if (data.rewards != null && data.rewards!.isNotEmpty) {
        for (var reward in data.rewards!) {
          _rewards.add({
            'title': reward.title ?? "",
            'desc': reward.description ?? "",
            'points': reward.pointsRequired?.toString() ?? "0",
            'qty': reward.stock?.toString() ?? "0",
            'image': reward.images ?? [],
          });
        }
      }
    } else {
      // Pre-populate mock values for demonstration matching mockup
      _eventNameController.text = "";
      _locationController.text = "";
      _priceController.text = "";
      _capacityController.text = "";

      _rewardTitleController.text = "";
      _rewardQuantityController.text = "";
      _rewardPointController.text = "";

      // Pre-populate dynamic artist list with 1 complete artist & social links
      _artistForms.add(
        ArtistFormModel(
          defaultName: "",
          defaultRole: "",
          defaultSocialLinks: [
            SocialLinkModel(platform: "Facebook", defaultUrl: ""),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _startTimeController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    for (var artist in _artistForms) {
      artist.dispose();
    }
    _rewardTitleController.dispose();
    _rewardDescController.dispose();
    _rewardQuantityController.dispose();
    _rewardPointController.dispose();
    super.dispose();
  }

  // Show a dialog to let the user add a custom age restriction
  void _showCustomAgeDialog() {
    final TextEditingController customAgeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E222B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            "Enter Custom Age Restriction",
            style: TextStyle(
              fontFamily: "SF Pro Rounded",
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          content: TextField(
            controller: customAgeController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "e.g. 21+ or Under 10",
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColorFirst),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              ),
            ),
            GestureDetector(
              onTap: () {
                final text = customAgeController.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _selectedAgeRestriction = text;
                  });
                }
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColorFirst,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper bottom sheets for CustomSelectorField selection
  void _showSelectorBottomSheet({
    required String title,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E222B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      title: Text(
                        option,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        onSelected(option);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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

  void _showSocialLinkDialog({
    required String initialPlatform,
    required String initialUrl,
    required void Function(String platform, String url) onSave,
  }) {
    final platformNotifier = ValueNotifier<String>(
      initialPlatform.isNotEmpty ? initialPlatform : "Facebook",
    );
    final urlController = TextEditingController(text: "");

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1E222B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Social Media Link",
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                UIHelper.verticalSpace(16),
                ValueListenableBuilder<String>(
                  valueListenable: platformNotifier,
                  builder: (context, platform, child) {
                    return CustomSelectorField(
                      value: platform,
                      hintText: "Platform",
                      onTap: () {
                        _showSelectorBottomSheet(
                          title: "Platform",
                          options: const [
                            "Facebook",
                            "Instagram",
                            "Twitter",
                            "Youtube",
                          ],
                          onSelected: (val) => platformNotifier.value = val,
                        );
                      },
                    );
                  },
                ),
                UIHelper.verticalSpace(16),
                _buildTextField(controller: urlController, hint: "Link"),
                UIHelper.verticalSpace(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    UIHelper.horizontalSpace(8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColorFirst,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () {
                        onSave(platformNotifier.value, urlController.text);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Handle file picker actions for multiple image support (Browse Files removed)
  void _showFileSourceOptions(
    BuildContext context,
    ValueChanged<List<String>> onPicked,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E222B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  "Take Photo",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) onPicked([image.path]);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  "Choose from Gallery (Multiple)",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final List<XFile> images = await _picker.pickMultiImage();
                  if (images.isNotEmpty) {
                    onPicked(images.map((img) => img.path).toList());
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Single file picker source for Artist (Browse Files removed)
  void _showSingleFileSourceOptions(
    BuildContext context,
    ValueChanged<String?> onPicked,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E222B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  "Take Photo",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) onPicked(image.path);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  "Choose from Gallery",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) onPicked(image.path);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handlePostEvent() async {
    setState(() => _isPostingEvent = true);

    List<dynamic> eventImages = [];
    for (String path in _eventPhotoPaths) {
      if (path.isNotEmpty) {
        if (path.startsWith('http')) {
          eventImages.add(path);
        } else {
          eventImages.add(await dio.MultipartFile.fromFile(path));
        }
      }
    }

    final Map<String, dynamic> body = {
      "subCategoryId": _selectedSubcategoryId ?? "65c8f1e29a8f3b0012345678",
      "title": _eventNameController.text,
      "latitude": 40.7128,
      "longitude": -74.006,
      "ageRestriction":
          int.tryParse(
            _selectedAgeRestriction?.replaceAll(RegExp(r'[^0-9]'), '') ?? '18',
          ) ??
          18,
      "placeName": _locationController.text,
      "description": _eventDescController.text,
      "startDate": _startDateController.text.isNotEmpty
          ? "${_startDateController.text}T${_startTimeController.text.isNotEmpty ? _startTimeController.text : "00:00"}:00.000Z"
          : "2026-09-01T18:00:00.000Z",
      "endDate": _endDateController.text.isNotEmpty
          ? "${_endDateController.text}T${_endTimeController.text.isNotEmpty ? _endTimeController.text : "00:00"}:00.000Z"
          : "2026-09-01T23:00:00.000Z",
      "ticketPrice": double.tryParse(_priceController.text) ?? 0.0,
      "stock": int.tryParse(_capacityController.text) ?? 0,
      "images": eventImages,
      // Pass the complex objects as they were; if the backend expects JSON strings, you may need to jsonEncode them.
      // Assuming Dio will handle or the backend parses form-data correctly.
    };

    List<Map<String, dynamic>> artistInfoList = [];
    List<dio.MultipartFile> artistImagesList = [];

    // Add artists
    for (int i = 0; i < _artistForms.length; i++) {
      final artist = _artistForms[i];
      if (artist.nameController.text.trim().isNotEmpty) {
        Map<String, dynamic> artistData = {
          "name": artist.nameController.text,
          "role": artist.designationController.text,
        };

        if (artist.photoPath != null && artist.photoPath!.isNotEmpty) {
          if (artist.photoPath!.startsWith('http')) {
            artistData["image"] = artist.photoPath;
          } else {
            artistImagesList.add(
              await dio.MultipartFile.fromFile(artist.photoPath!),
            );
          }
        }

        Map<String, String> socialLinksMap = {};
        for (var link in artist.socialLinks.where(
          (l) => l.urlController.text.trim().isNotEmpty,
        )) {
          socialLinksMap[link.platform.toLowerCase()] = link.urlController.text
              .trim();
        }
        if (socialLinksMap.isNotEmpty) {
          artistData["socialMediaLinks"] = socialLinksMap;
        }

        artistInfoList.add(artistData);
      }
    }

    if (artistInfoList.isNotEmpty) {
      body['artistInfo'] = jsonEncode(artistInfoList);
    }

    if (artistImagesList.isNotEmpty) {
      body['artistImages'] = artistImagesList;
    }

    final validRewards = _rewards
        .where(
          (reward) =>
              reward['title'] != null &&
              reward['title'].toString().trim().isNotEmpty,
        )
        .toList();

    List<Map<String, dynamic>> rewardsList = [];

    for (int i = 0; i < validRewards.length; i++) {
      final reward = validRewards[i];

      List<String> paths = (reward['image'] is List)
          ? List<String>.from(reward['image'])
          : [reward['image']?.toString() ?? ""];

      List<String> existingUrls = [];
      List<dio.MultipartFile> rewardMultiFiles = [];

      for (String path in paths) {
        if (path.isNotEmpty) {
          if (path.startsWith('http')) {
            existingUrls.add(path);
          } else {
            rewardMultiFiles.add(await dio.MultipartFile.fromFile(path));
          }
        }
      }

      rewardsList.add({
        "title": reward['title'],
        "description": reward['desc'],
        "pointsRequired": reward['points'],
        "stock": reward['qty'],
        if (existingUrls.isNotEmpty) "images": existingUrls,
      });

      if (rewardMultiFiles.isNotEmpty) {
        body['rewardImages_$i'] = rewardMultiFiles;
      }
    }

    if (rewardsList.isNotEmpty) {
      body['rewards'] = jsonEncode(rewardsList);
    }

    dio.FormData formData = dio.FormData.fromMap(body);

    print("Event Body Data: $body");
    print("Sending FormData...");

    try {
      bool success;
      if (widget.eventData != null && widget.eventData!.id != null) {
        success = await updateEventRxObj.updateEvent(
          widget.eventData!.id!,
          formData,
        );
      } else {
        success = await createEventRxObj.createEvent(formData);
      }

      if (mounted) {
        setState(() => _isPostingEvent = false);
      }

      if (success) {
        final String? hostId = appData.read('id');
        locator<GetEventsRx>().fetchEvents(hostId: hostId);
        _showSuccessDialog();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.eventData != null
                    ? "Failed to update event"
                    : "Failed to create event",
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPostingEvent = false);
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: const Color(0xFF1E222B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColorSecond.withValues(
                        alpha: 0.15,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.primaryColorSecond,
                      size: 50.w,
                    ),
                  ),
                  UIHelper.verticalSpace(20),
                  Text(
                    "Success!",
                    style: TextStyle(
                      fontFamily: "SF Pro Rounded",
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  UIHelper.verticalSpace(10),
                  Text(
                    widget.eventData != null
                        ? "Your event has been updated successfully."
                        : "Your event has been created and is now live on the platform.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "SF Pro",
                      fontSize: 14.sp,
                      color: Colors.white.withValues(alpha: 0.6),
                      height: 1.4,
                    ),
                  ),
                  UIHelper.verticalSpace(24),
                  GestureDetector(
                    onTap: () {
                      // Pop dialog
                      Navigator.pop(context);
                      // Pop wizard to return back to Events list screen!
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF28F31), Color(0xFF72E84F)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Done",
                        style: TextStyle(
                          fontFamily: "SF Pro Rounded",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final showIndicator = _currentStep <= 4;
    final isOverview = _currentStep == 5;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            UIHelper.verticalSpace(20),
            // Header Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildHeader(),
            ),
            UIHelper.verticalSpace(16),

            // Step Indicator (only on steps 1-5)
            if (showIndicator) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 21.w),
                child: WizardProgressIndicator(
                  currentStep: _currentStep,
                  totalSteps: 4,
                ),
              ),
              UIHelper.verticalSpace(24),
            ],

            // Content body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: isOverview
                      ? _buildOverviewContent()
                      : _buildStepContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Chevron Button
        GestureDetector(
          onTap: () {
            if (_currentStep > 1) {
              setState(() {
                _currentStep--;
              });
            } else {
              Navigator.pop(context);
            }
          },
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222B),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 20.w,
            ),
          ),
        ),

        // Title
        Text(
          "Create Event",
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        SizedBox(width: 40.w), // Spacer to balance layout
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return StreamBuilder<IntrestCategoryModel>(
          stream: getCategoriesRxObj.getCategoriesData,
          builder: (context, catSnapshot) {
            final isCatLoading =
                catSnapshot.connectionState == ConnectionState.waiting &&
                !catSnapshot.hasData;
            final catDataList = catSnapshot.data?.data ?? [];
            final categoryNames = catDataList
                .map((e) => e.name ?? '')
                .where((e) => e.isNotEmpty)
                .toList();

            return StreamBuilder<IntrestCategoryModel>(
              stream: getSubCategoriesRxObj.getSubCategoriesData,
              builder: (context, subSnapshot) {
                final isSubLoading =
                    subSnapshot.connectionState == ConnectionState.waiting &&
                    !subSnapshot.hasData;
                final subDataList = subSnapshot.data?.data ?? [];
                final subcategoryNames = subDataList
                    .map((e) => e.name ?? '')
                    .where((e) => e.isNotEmpty)
                    .toList();

                return WizardStepOne(
                  eventNameController: _eventNameController,
                  eventDescController: _eventDescController,
                  selectedCategory: _selectedCategory,
                  selectedSubcategory: _selectedSubcategory,
                  locationController: _locationController,
                  isLoadingCategories: isCatLoading,
                  isLoadingSubcategories: isSubLoading,
                  hasSubcategories:
                      subcategoryNames.isNotEmpty && !isSubLoading,
                  onCategoryTap: () {
                    if (categoryNames.isEmpty) return;
                    _showSelectorBottomSheet(
                      title: "Choose Categories",
                      options: categoryNames,
                      onSelected: (val) {
                        setState(() {
                          _selectedCategory = val;
                          _selectedSubcategory = null;
                          _selectedSubcategoryId = null;
                        });
                        // Fetch subcategories
                        final cat = catDataList.firstWhere(
                          (e) => e.name == val,
                        );
                        if (cat.id != null) {
                          getSubCategoriesRxObj.fetchSubCategories(cat.id!);
                        }
                      },
                    );
                  },
                  onSubcategoryTap: () {
                    if (subcategoryNames.isEmpty) return;
                    _showSelectorBottomSheet(
                      title: "Choose Subcategories",
                      options: subcategoryNames,
                      onSelected: (val) {
                        setState(() {
                          _selectedSubcategory = val;
                          final sub = subDataList.firstWhere(
                            (e) => e.name == val,
                          );
                          _selectedSubcategoryId = sub.id;
                        });
                      },
                    );
                  },
                  onContinue: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _currentStep = 2);
                    }
                  },
                );
              },
            );
          },
        );
      case 2:
        return WizardStepTwo(
          startDateController: _startDateController,
          startTimeController: _startTimeController,
          endDateController: _endDateController,
          endTimeController: _endTimeController,
          priceController: _priceController,
          capacityController: _capacityController,
          eventPhotoPaths: _eventPhotoPaths,
          onAddPhotos: () => _showFileSourceOptions(
            context,
            (paths) => setState(() => _eventPhotoPaths.addAll(paths)),
          ),
          onRemovePhoto: (index) {
            setState(() {
              if (index == -1) {
                _eventPhotoPaths.clear();
              } else {
                _eventPhotoPaths.removeAt(index);
              }
            });
          },
          selectedAgeRestriction: _selectedAgeRestriction,
          onAgeRestrictionTap: () {
            _showSelectorBottomSheet(
              title: "Select restriction",
              options: const ["All ages", "12+", "16+", "18+", "+ Custom Age"],
              onSelected: (val) {
                if (val == "+ Custom Age") {
                  _showCustomAgeDialog();
                } else {
                  setState(() => _selectedAgeRestriction = val);
                }
              },
            );
          },
          onContinue: () {
            if (_formKey.currentState!.validate()) {
              setState(() => _currentStep = 3);
            }
          },
        );
      case 3:
        return WizardStepThree(
          artistForms: _artistForms,
          onAddArtist: () =>
              setState(() => _artistForms.add(ArtistFormModel())),
          onRemoveArtist: (index) => setState(() {
            _artistForms[index].dispose();
            _artistForms.removeAt(index);
          }),
          onAddSocialLink: (index) => setState(
            () => _artistForms[index].socialLinks.add(SocialLinkModel()),
          ),
          onRemoveSocialLink: (artistIdx, linkIdx) => setState(() {
            _artistForms[artistIdx].socialLinks[linkIdx].dispose();
            _artistForms[artistIdx].socialLinks.removeAt(linkIdx);
          }),
          onArtistPhotoTap: (index) => _showSingleFileSourceOptions(
            context,
            (path) => setState(() => _artistForms[index].photoPath = path),
          ),
          onArtistPhotoRemove: (index) =>
              setState(() => _artistForms[index].photoPath = null),
          onSocialLinkEdit: (artistIdx, linkIdx) {
            final social = _artistForms[artistIdx].socialLinks[linkIdx];
            _showSocialLinkDialog(
              initialPlatform: social.platform,
              initialUrl: social.urlController.text,
              onSave: (platform, url) {
                setState(() {
                  social.platform = platform;
                  social.urlController.text = url;
                });
              },
            );
          },
          onContinue: () => setState(() => _currentStep = 4),
          onSkip: () => setState(() => _currentStep++),
        );
      case 4:
        return WizardStepFour(
          rewards: _rewards,
          onRemoveReward: (index) => setState(() => _rewards.removeAt(index)),
          rewardTitleController: _rewardTitleController,
          rewardDescController: _rewardDescController,
          rewardPhotoPaths: _rewardPhotoPaths,
          onAddPhotos: () => _showFileSourceOptions(
            context,
            (paths) => setState(() => _rewardPhotoPaths.addAll(paths)),
          ),
          onRemovePhoto: (index) {
            setState(() {
              if (index == -1) {
                _rewardPhotoPaths.clear();
              } else {
                _rewardPhotoPaths.removeAt(index);
              }
            });
          },
          rewardQuantityController: _rewardQuantityController,
          rewardPointController: _rewardPointController,
          onAddReward: () {
            if (_rewardTitleController.text.isNotEmpty) {
              setState(() {
                _rewards.add({
                  "title": _rewardTitleController.text,
                  "desc": _rewardDescController.text,
                  "image": _rewardPhotoPaths.isNotEmpty
                      ? List<String>.from(_rewardPhotoPaths)
                      : "",
                  "qty": int.tryParse(_rewardQuantityController.text) ?? 200,
                  "points": int.tryParse(_rewardPointController.text) ?? 0,
                });
                _rewardTitleController.clear();
                _rewardDescController.clear();
                _rewardPhotoPaths.clear();
                _rewardQuantityController.clear();
                _rewardPointController.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Reward added successfully!")),
              );
            }
          },
          onContinue: () {
            if (_rewardTitleController.text.isNotEmpty) {
              _rewards.add({
                "title": _rewardTitleController.text,
                "desc": _rewardDescController.text,
                "image": _rewardPhotoPaths.isNotEmpty
                    ? List<String>.from(_rewardPhotoPaths)
                    : "",
                "qty": int.tryParse(_rewardQuantityController.text) ?? 200,
                "points": int.tryParse(_rewardPointController.text) ?? 0,
              });
              _rewardTitleController.clear();
              _rewardDescController.clear();
              _rewardPhotoPaths.clear();
              _rewardQuantityController.clear();
              _rewardPointController.clear();
            }
            setState(() => _currentStep = 5);
          },
          onSkip: () => setState(() => _currentStep++),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildOverviewContent() {
    final startFull = _startDateController.text.isNotEmpty
        ? "${_startDateController.text} ${_startTimeController.text.isNotEmpty ? _startTimeController.text : "00:00"}"
        : "";
    final endFull = _endDateController.text.isNotEmpty
        ? "${_endDateController.text} ${_endTimeController.text.isNotEmpty ? _endTimeController.text : "00:00"}"
        : "";

    return WizardStepSix(
      eventName: _eventNameController.text,
      location: _locationController.text,
      eventDesc: _eventDescController.text,
      startDate: startFull,
      endDate: endFull,
      price: _priceController.text,
      capacity: _capacityController.text,
      artistForms: _artistForms,
      selectedAgeRestriction: _selectedAgeRestriction,
      rewards: _rewards,
      isPostingEvent: _isPostingEvent,
      onPostEvent: _handlePostEvent,
      onEditInfo: () => setState(() => _currentStep = 1),
    );
  }
}

// Model to manage dynamic social links per artist
import 'package:flutter/material.dart';

class SocialLinkModel {
  String platform;
  final TextEditingController urlController;

  SocialLinkModel({
    this.platform = "Facebook",
    String defaultUrl = "",
  }) : urlController = TextEditingController(text: defaultUrl);

  void dispose() {
    urlController.dispose();
  }
}

// Model to manage dynamic artist forms
class ArtistFormModel {
  final TextEditingController nameController;
  final TextEditingController designationController;
  String? photoPath;
  final List<SocialLinkModel> socialLinks;

  ArtistFormModel({
    String defaultName = "",
    String defaultRole = "",
    this.photoPath,
    List<SocialLinkModel>? defaultSocialLinks,
  })  : nameController = TextEditingController(text: defaultName),
        designationController = TextEditingController(text: defaultRole),
        socialLinks = defaultSocialLinks ?? [SocialLinkModel()];

  void dispose() {
    nameController.dispose();
    designationController.dispose();
    for (var link in socialLinks) {
      link.dispose();
    }
  }
}

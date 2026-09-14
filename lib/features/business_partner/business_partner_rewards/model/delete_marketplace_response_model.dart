class DeleteMarketplaceResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;

  DeleteMarketplaceResponseModel({
    this.success,
    this.statusCode,
    this.message,
  });

  factory DeleteMarketplaceResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteMarketplaceResponseModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
    };
  }
}

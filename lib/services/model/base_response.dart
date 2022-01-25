class BaseResponse {
  BaseResponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}

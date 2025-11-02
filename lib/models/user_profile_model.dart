class userProfileData {
  bool? success;
  int? status;
  String? message;
  String? action;
  Data? data;

  userProfileData(
      {this.success, this.status, this.message, this.action, this.data});

  userProfileData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    action = json['action'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    data['action'] = this.action;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? createdAt;
  int? id;
  String? username;
  String? accountStatus;
  int? isPhoneVerify;
  String? phone;
  String? siteName;
  String? avatar;
  int? wallet;
  String? email;
  String? city;
  String? address;
  String? zipCode;
  String? password;
  String? updatedAt;

  Data(
      {this.createdAt,
        this.id,
        this.username,
        this.accountStatus,
        this.isPhoneVerify,
        this.phone,
        this.siteName,
        this.avatar,
        this.wallet,
        this.email,
        this.city,
        this.address,
        this.zipCode,
        this.password,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    id = json['id'];
    username = json['username'];
    accountStatus = json['account_status'];
    isPhoneVerify = json['is_phone_verify'];
    phone = json['phone'];
    siteName = json['site_name'];
    avatar = json['avatar'];
    wallet = json['wallet'];
    email = json['email'];
    city = json['city'];
    address = json['address'];
    zipCode = json['zip_code'];
    password = json['password'];
    updatedAt = json['updated_at'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['username'] = this.username;
    data['account_status'] = this.accountStatus;
    data['is_phone_verify'] = this.isPhoneVerify;
    data['phone'] = this.phone;
    data['site_name'] = this.siteName;
    data['avatar'] = this.avatar;
    data['wallet'] = this.wallet;
    data['email'] = this.email;
    data['city'] = this.city;
    data['address'] = this.address;
    data['zip_code'] = this.zipCode;
    data['password'] = this.password;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
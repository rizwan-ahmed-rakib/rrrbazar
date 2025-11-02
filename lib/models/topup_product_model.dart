class Topup_Product_Model {
  bool? success;
  int? status;
  String? message;
  String? action;
  List<Data>? data;

  Topup_Product_Model(
      {this.success, this.status, this.message, this.action, this.data});

  Topup_Product_Model.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    action = json['action'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    data['action'] = this.action;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? logo;
  String? helperImage;
  String? rules;
  String? topupType;
  int? isActive;
  int? sortOrder;
  String? createdAt;
  String? updatedAt;
  String? siteName;

  Data(
      {this.id,
        this.name,
        this.logo,
        this.helperImage,
        this.rules,
        this.topupType,
        this.isActive,
        this.sortOrder,
        this.createdAt,
        this.updatedAt,
        this.siteName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    helperImage = json['helper_image'];
    rules = json['rules'];
    topupType = json['topup_type'];
    isActive = json['is_active'];
    sortOrder = json['sort_order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    siteName = json['site_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['helper_image'] = this.helperImage;
    data['rules'] = this.rules;
    data['topup_type'] = this.topupType;
    data['is_active'] = this.isActive;
    data['sort_order'] = this.sortOrder;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['site_name'] = this.siteName;
    return data;
  }
}

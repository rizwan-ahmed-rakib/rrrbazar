// class topup_banner_model {
//   bool? success;
//   int? status;
//   String? message;
//   String? action;
//   List<Data>? data;
//
//   topup_banner_model(
//       {this.success, this.status, this.message, this.action, this.data});
//
//   topup_banner_model.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     status = json['status'];
//     message = json['message'];
//     action = json['action'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['status'] = this.status;
//     data['message'] = this.message;
//     data['action'] = this.action;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   int? id;
//   String? note;
//   String? banner;
//   String? link;
//   int? isactive;
//   String? createdAt;
//   String? updatedAt;
//   Null? siteName;
//
//   Data(
//       {this.id,
//         this.note,
//         this.banner,
//         this.link,
//         this.isactive,
//         this.createdAt,
//         this.updatedAt,
//         this.siteName});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     note = json['note'];
//     banner = json['banner'];
//     link = json['link'];
//     isactive = json['isactive'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     siteName = json['site_name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['note'] = this.note;
//     data['banner'] = this.banner;
//     data['link'] = this.link;
//     data['isactive'] = this.isactive;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['site_name'] = this.siteName;
//     return data;
//   }
// }





class topup_banner_model {
  bool? success;
  int? status;
  String? message;
  String? action;
  List<Data>? data;

  topup_banner_model(
      {this.success, this.status, this.message, this.action, this.data});

  topup_banner_model.fromJson(Map<String, dynamic> json) {
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
  String? note;
  String? banner;
  String? link;
  int? isactive;
  String? createdAt;
  String? updatedAt;
  String? siteName; // 🔥 Null থেকে String? এ পরিবর্তন করুন

  Data(
      {this.id,
        this.note,
        this.banner,
        this.link,
        this.isactive,
        this.createdAt,
        this.updatedAt,
        this.siteName}); // 🔥 siteName এর type String? করুন

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    banner = json['banner'];
    link = json['link'];
    isactive = json['isactive'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    siteName = json['site_name']; // 🔥 এটি এখন error throw করবে না
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['note'] = this.note;
    data['banner'] = this.banner;
    data['link'] = this.link;
    data['isactive'] = this.isactive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['site_name'] = this.siteName;
    return data;
  }
}
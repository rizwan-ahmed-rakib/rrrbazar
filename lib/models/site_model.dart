// class SiteModel {
//   final int id;
//   final String name;
//   final String siteName;
//   final String logo;
//   final String whatsapp;
//   final String facebook;
//   final String youtube;
//   final String instagram;
//   final String phone;
//   final String email;
//   final String color;
//   final String secondaryColor;
//   final bool active;
//   final String createdAt;
//   final String updatedAt;
//
//   SiteModel({
//     required this.id,
//     required this.name,
//     required this.siteName,
//     required this.logo,
//     required this.whatsapp,
//     required this.facebook,
//     required this.youtube,
//     required this.instagram,
//     required this.phone,
//     required this.email,
//     required this.color,
//     required this.secondaryColor,
//     required this.active,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   /// ✅ Factory constructor for creating SiteModel from JSON
//   factory SiteModel.fromJson(Map<String, dynamic> json) {
//     return SiteModel(
//       id: json["id"] ?? 0,
//       name: json["name"] ?? "",
//       siteName: json["site_name"] ?? "",
//       logo: json["logo"] ?? "",
//       whatsapp: json["whatsapp"] ?? "",
//       facebook: json["facebook"] ?? "",
//       youtube: json["youtube"] ?? "",
//       instagram: json["instagram"] ?? "",
//       phone: json["phone"] ?? "",
//       email: json["email"] ?? "",
//       color: json["color"] ?? "000000",
//       secondaryColor: json["secondary_color"] ?? "FFFFFF",
//       active: json["active"] ?? false,
//       createdAt: json["created_at"] ?? "",
//       updatedAt: json["updated_at"] ?? "",
//     );
//   }
//
//   /// ✅ Convert SiteModel to JSON (useful if you need to send data to server)
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "name": name,
//       "site_name": siteName,
//       "logo": logo,
//       "whatsapp": whatsapp,
//       "facebook": facebook,
//       "youtube": youtube,
//       "instagram": instagram,
//       "phone": phone,
//       "email": email,
//       "color": color,
//       "secondary_color": secondaryColor,
//       "active": active,
//       "created_at": createdAt,
//       "updated_at": updatedAt,
//     };
//   }
//
//   /// ✅ ToString override — console e full readable output dekhabe
//   @override
//   String toString() {
//     return '''
// 📦 SiteModel(
//   id: $id,
//   name: $name,
//   siteName: $siteName,
//   logo: $logo,
//   whatsapp: $whatsapp,
//   facebook: $facebook,
//   youtube: $youtube,
//   instagram: $instagram,
//   phone: $phone,
//   email: $email,
//   color: $color,
//   secondaryColor: $secondaryColor,
//   active: $active,
//   createdAt: $createdAt,
//   updatedAt: $updatedAt
// )
// ''';
//   }
// }




class SiteModel {
  final int id;
  final String name;
  final String siteName;
  final String logo;
  final String whatsapp;
  final String facebook;
  final String youtube;
  final String instagram;
  final String phone;
  final String email;
  final String color;
  final String secondaryColor;
  final bool active;

  SiteModel({
    required this.id,
    required this.name,
    required this.siteName,
    required this.logo,
    required this.whatsapp,
    required this.facebook,
    required this.youtube,
    required this.instagram,
    required this.phone,
    required this.email,
    required this.color,
    required this.secondaryColor,
    required this.active,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) {
    return SiteModel(
      id: json["id"],
      name: json["name"] ?? "",
      siteName: json["site_name"] ?? "",
      logo: json["logo"] ?? "",
      whatsapp: json["whatsapp"] ?? "",
      facebook: json["facebook"] ?? "",
      youtube: json["youtube"] ?? "",
      instagram: json["instagram"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      color: json["color"] ?? "",
      secondaryColor: json["secondary_color"] ?? "",
      active: json["active"] ?? false,
    );
  }
}

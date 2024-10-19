import 'dart:io';

class NotificationModel {
  dynamic id;
  dynamic data_id;
  final NotificationData notification;
  final dynamic file;
  final dynamic Dfile;
  final dynamic createdAt;
  final bool isRead;
  late dynamic electronic_instrument;
  String? price;
  String? city_name;
  dynamic agreed_terms; // Update to nullable
  String? type;
  dynamic identity;
  String? district_name;
  String? location;
  late String number;

  NotificationModel({
    required this.id,
    required this.data_id,
    this.agreed_terms, // Mark it as optional
    required this.Dfile,
    required this.notification,
    required this.file,
    required this.createdAt,
    required this.isRead,
    required this.city_name,
    required this.electronic_instrument,
    required this.type,
    required this.location,
    required this.identity,
  });

  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    return NotificationModel(
      id: json['id'], data_id: json['data_id'],
      Dfile: json['Dfile'],
      agreed_terms: json['agreed_terms'] ?? false, // Ensure it's not null
      notification: NotificationData.fromJson(json['notification']),
      file: json['file'],
      createdAt: json['created_at'],
      isRead: json['is_read'],
      city_name: json['city_name'],
      electronic_instrument: json['electronic_instrument'],
      type: json['type'],
      location: json['location'],
      identity: json['identity'],
    );
  }
}

class NotificationData {
  final dynamic title;
  final dynamic message;
  final dynamic type;
  final NotificationDetails data;
  final dynamic created_at;

  NotificationData({
    required this.title,
    this.created_at,
    required this.message,
    required this.type,
    required this.data,
  });

  factory NotificationData.fromJson(Map<dynamic, dynamic> json) {
    return NotificationData(
      title: json['title'],
      created_at: json['created_at'],
      message: json['message'],
      type: json['type'],
      data: NotificationDetails.fromJson(json['data']),
    );
  }
}

class NotificationDetails {
  final dynamic district_name;
  final dynamic id;
  final dynamic data_id;
  final dynamic userId;
  final dynamic type;
  final dynamic identity;
  final dynamic electronic_instrument;
  final dynamic city_name;

  final dynamic price;
  final dynamic location;
  final dynamic status;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic file;
  final dynamic Dfile;
  final User user;
  final dynamic agreed_terms;
  NotificationDetails({
    required this.id,
    required this.agreed_terms,
    required this.data_id,
    required this.district_name,
    required this.userId,
    required this.type,
    required this.identity,
    required this.electronic_instrument,
    required this.city_name,
    required this.price,
    required this.location,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.file,
    required this.Dfile,
    required this.user,
  });

  factory NotificationDetails.fromJson(Map<dynamic, dynamic> json) {
    return NotificationDetails(
      id: json['id'],
      agreed_terms: json['agreed_terms'],
      data_id: json['data_id'],
      Dfile: json['Dfile'],
      district_name: json['district_name'],
      userId: json['user_id'],
      type: json['type'],
      identity: json['identity'],
      electronic_instrument: json['electronic_instrument'],
      city_name: json['city_name'],
      price: json['price'],
      location: json['location'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      file: json['file'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final dynamic id;
  final dynamic name;
  final dynamic image;
  final dynamic email;
  final dynamic emailVerifiedAt;
  final dynamic deviceKey;
  final dynamic delay;
  final dynamic role;
  final dynamic apiToken;
  final dynamic fcmToken;
  final dynamic createdAt;
  final dynamic updatedAt;

  User({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
    this.emailVerifiedAt,
    this.deviceKey,
    this.delay,
    required this.role,
    this.apiToken,
    this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      deviceKey: json['device_key'],
      delay: json['delay'],
      role: json['role'],
      apiToken: json['api_token'],
      fcmToken: json['fcm_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

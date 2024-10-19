import 'package:flutter/foundation.dart';

class Modelget extends ChangeNotifier {
  final String? house_type;
  final String? type;
  final String? house_space;
  String? description;
  String? name;
  final String? district_name;
  final dynamic price;
  final String? image1;
  String? number;
  final String? city_name;
  final String? image2;
  dynamic image;
  final String? image3;
  final String? image4;
  final String? identity;
  final String? id;
  final String? status;
  final String? created_at;
  dynamic orderNumber;

  Modelget({
    this.house_type,
    this.name,
    this.orderNumber,
    this.type,
    this.house_space,
    this.description,
    this.district_name,
    this.price,
    this.image1,
    this.image,
    this.number,
    this.city_name,
    this.image2,
    this.image3,
    this.image4,
    this.identity,
    this.id,
    this.status,
    this.created_at,
  });

  factory Modelget.fromJson(Map<String, dynamic> json) {
    return Modelget(
      house_type: json['house_type']?.toString(),
      name: json['name']?.toString(),
      type: json['type']?.toString(),
      status: json['status']?.toString(),
      city_name: json['city_name']?.toString(),
      house_space: json['house_space']?.toString(),
      description: json['description']?.toString(),
      created_at: json['created_at']?.toString(),
      district_name: json['district_name']?.toString(),
      price: json['price'],
      id: json['id']?.toString(),
      orderNumber: json['orderNumber']?.toString(),
      number: json['number']?.toString(),
      image1: json['image1']?.toString(),
      identity: json['identity']?.toString(),
      image2: json['image2']?.toString(),
      image3: json['image3']?.toString(),
      image4: json['image4']?.toString(),
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'house_type': house_type,
      'image': image,
      'type': type,
      'house_space': house_space,
      'description': description,
      'district_name': district_name,
      'price': price,
      'image1': image1,
      'order_number': number,
      'city_name': city_name,
      'image2': image2,
      'image3': image3,
      'image4': image4,
      'identity': identity,
      'id': id,
      'status': status,
      'created_at': created_at,
    };
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOrderResponse _$ListOrderResponseFromJson(Map<String, dynamic> json) =>
    ListOrderResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListOrderResponseToJson(ListOrderResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

ListOrderWaitingResponse _$ListOrderWaitingResponseFromJson(
        Map<String, dynamic> json) =>
    ListOrderWaitingResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListOrderWaitingResponseToJson(
        ListOrderWaitingResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : OrderModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      id: json['id'] as int?,
      userId: json['user_id'] as String?,
      address: json['address'] as String?,
      status: json['status'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      stats: (json['stats'] as num?)?.toDouble(),
      rescueUnit: json['rescue_unit'] == null
          ? null
          : RescueUnit.fromJson(json['rescue_unit'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'address': instance.address,
      'status': instance.status,
      'lat': instance.lat,
      'lng': instance.lng,
      'stats': instance.stats,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'user': instance.user,
      'rescue_unit': instance.rescueUnit,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      username: json['username'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      fullName: json['full_name'] as String?,
      age: json['age'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      role: json['role'] == null
          ? null
          : Role.fromJson(json['role'] as Map<String, dynamic>),
    )
      ..status = json['status'] as int?
      ..lat = (json['lat'] as num?)?.toDouble()
      ..lng = (json['lng'] as num?)?.toDouble();

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'full_name': instance.fullName,
      'age': instance.age,
      'status': instance.status,
      'lat': instance.lat,
      'lng': instance.lng,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'role': instance.role,
    };

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      id: json['id'] as int?,
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'id': instance.id,
    };

RescueUnit _$RescueUnitFromJson(Map<String, dynamic> json) => RescueUnit(
      updatedAt: json['updated_at'] as String?,
      createdAt: json['created_at'] as String?,
    )
      ..username = json['username'] as String?
      ..email = json['email'] as String?
      ..phone = json['phone'] as String?
      ..password = json['password'] as String?
      ..fullName = json['full_name'] as String?
      ..age = json['age'] as int?
      ..status = json['status'] as int?
      ..lat = (json['lat'] as num?)?.toDouble()
      ..lng = (json['lng'] as num?)?.toDouble();

Map<String, dynamic> _$RescueUnitToJson(RescueUnit instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'full_name': instance.fullName,
      'age': instance.age,
      'status': instance.status,
      'lat': instance.lat,
      'lng': instance.lng,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
    };

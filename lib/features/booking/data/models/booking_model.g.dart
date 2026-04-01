// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      userId: json['userId'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      durationHours: (json['durationHours'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'providerId': instance.providerId,
      'providerName': instance.providerName,
      'userId': instance.userId,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'durationHours': instance.durationHours,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
    };

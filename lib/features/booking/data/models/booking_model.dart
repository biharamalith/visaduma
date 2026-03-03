// ============================================================
// FILE: lib/features/booking/data/models/booking_model.dart
// ============================================================
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/booking_entity.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.serviceId,
    required super.serviceName,
    required super.providerId,
    required super.providerName,
    required super.userId,
    required super.scheduledAt,
    required super.durationHours,
    required super.totalPrice,
    required super.status,
    super.notes,
    required super.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}

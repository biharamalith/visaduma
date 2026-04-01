import 'package:flutter_test/flutter_test.dart';
import 'package:visaduma/features/services/data/models/service_category_model.dart';
import 'package:visaduma/features/services/domain/entities/service_category_entity.dart';

void main() {
  group('ServiceCategoryModel', () {
    const tId = '123';
    const tName = 'Carpenter';
    const tNameSi = 'වඩු කාර්මිකයා';
    const tNameTa = 'தச்சர்';
    const tDescription = 'Professional carpentry services';
    const tIconName = 'carpenter';
    const tColorHex = '#2563EB';
    const tProviderCount = 24;

    const tModel = ServiceCategoryModel(
      id: tId,
      name: tName,
      nameSi: tNameSi,
      nameTa: tNameTa,
      description: tDescription,
      iconName: tIconName,
      colorHex: tColorHex,
      providerCount: tProviderCount,
    );

    const tEntity = ServiceCategoryEntity(
      id: tId,
      name: tName,
      nameSi: tNameSi,
      nameTa: tNameTa,
      description: tDescription,
      iconName: tIconName,
      colorHex: tColorHex,
      providerCount: tProviderCount,
    );

    final tJson = {
      'id': tId,
      'name': tName,
      'name_si': tNameSi,
      'name_ta': tNameTa,
      'description': tDescription,
      'icon_name': tIconName,
      'color_hex': tColorHex,
      'provider_count': tProviderCount,
    };

    test('should deserialize from JSON correctly', () {
      // Act
      final result = ServiceCategoryModel.fromJson(tJson);

      // Assert
      expect(result.id, tId);
      expect(result.name, tName);
      expect(result.nameSi, tNameSi);
      expect(result.nameTa, tNameTa);
      expect(result.description, tDescription);
      expect(result.iconName, tIconName);
      expect(result.colorHex, tColorHex);
      expect(result.providerCount, tProviderCount);
    });

    test('should serialize to JSON correctly', () {
      // Act
      final result = tModel.toJson();

      // Assert
      expect(result, tJson);
    });

    test('should convert to entity correctly', () {
      // Act
      final result = tModel.toEntity();

      // Assert
      expect(result.id, tEntity.id);
      expect(result.name, tEntity.name);
      expect(result.nameSi, tEntity.nameSi);
      expect(result.nameTa, tEntity.nameTa);
      expect(result.description, tEntity.description);
      expect(result.iconName, tEntity.iconName);
      expect(result.colorHex, tEntity.colorHex);
      expect(result.providerCount, tEntity.providerCount);
    });

    test('should create from entity correctly', () {
      // Act
      final result = ServiceCategoryModel.fromEntity(tEntity);

      // Assert
      expect(result.id, tModel.id);
      expect(result.name, tModel.name);
      expect(result.nameSi, tModel.nameSi);
      expect(result.nameTa, tModel.nameTa);
      expect(result.description, tModel.description);
      expect(result.iconName, tModel.iconName);
      expect(result.colorHex, tModel.colorHex);
      expect(result.providerCount, tModel.providerCount);
    });

    test('should handle null optional fields in JSON', () {
      // Arrange
      final jsonWithNulls = {
        'id': tId,
        'name': tName,
        'icon_name': tIconName,
        'color_hex': tColorHex,
      };

      // Act
      final result = ServiceCategoryModel.fromJson(jsonWithNulls);

      // Assert
      expect(result.id, tId);
      expect(result.name, tName);
      expect(result.nameSi, isNull);
      expect(result.nameTa, isNull);
      expect(result.description, isNull);
      expect(result.iconName, tIconName);
      expect(result.colorHex, tColorHex);
      expect(result.providerCount, isNull);
    });
  });
}

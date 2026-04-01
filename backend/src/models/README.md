# Models

This directory contains data models for the VisaDuma backend.

## ServiceCategory

The `ServiceCategory` model represents service categories in the service provider booking system.

### Properties

- `id` (UUID) - Unique identifier
- `name` (string) - Category name in English
- `name_si` (string, optional) - Category name in Sinhala
- `name_ta` (string, optional) - Category name in Tamil
- `description` (string, optional) - Category description
- `icon_name` (string) - Material icon name
- `color_hex` (string) - Hex color code (e.g., "#2563EB")
- `display_order` (number) - Display order for sorting
- `is_active` (boolean) - Whether the category is active
- `created_at` (Date) - Creation timestamp

### Methods

#### `toJSON()`
Converts the model to a plain object for API responses.

#### `getLocalizedName(lang)`
Returns the localized name based on language code ('en', 'si', 'ta').

#### `static validate(data)`
Validates category data before creation/update. Returns an object with `isValid` and `errors` properties.

### Example Usage

```javascript
const ServiceCategory = require('./models/ServiceCategory');

// Create a new category instance
const category = new ServiceCategory({
  id: '123e4567-e89b-12d3-a456-426614174000',
  name: 'Carpenter',
  name_si: 'වඩු කාර්මිකයා',
  icon_name: 'carpenter',
  color_hex: '#8B4513',
  display_order: 1,
  is_active: true,
  created_at: new Date(),
});

// Get localized name
const sinhalaName = category.getLocalizedName('si');

// Convert to JSON
const json = category.toJSON();

// Validate data
const validation = ServiceCategory.validate({
  name: 'Electrician',
  icon_name: 'electrical_services',
  color_hex: '#FFA500',
});

if (validation.isValid) {
  // Data is valid
} else {
  console.error('Validation errors:', validation.errors);
}
```

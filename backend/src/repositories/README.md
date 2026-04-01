# Repositories

This directory contains repository classes that handle database operations.

## serviceCategoryRepository

Handles CRUD operations for service categories.

### Methods

#### `getAllCategories(options)`
Get all service categories with optional filtering and sorting.

**Parameters:**
- `options.activeOnly` (boolean) - Filter for active categories only (default: false)
- `options.orderBy` (string) - Order by field: 'display_order', 'name', or 'created_at' (default: 'display_order')

**Returns:** Promise<ServiceCategory[]>

**Example:**
```javascript
const categories = await serviceCategoryRepository.getAllCategories({ 
  activeOnly: true,
  orderBy: 'display_order'
});
```

#### `getCategoryById(id)`
Get a service category by its UUID.

**Parameters:**
- `id` (string) - Category UUID

**Returns:** Promise<ServiceCategory|null>

**Example:**
```javascript
const category = await serviceCategoryRepository.getCategoryById('123e4567-e89b-12d3-a456-426614174000');
```

#### `createCategory(data)`
Create a new service category.

**Parameters:**
- `data.name` (string, required) - Category name
- `data.name_si` (string, optional) - Sinhala name
- `data.name_ta` (string, optional) - Tamil name
- `data.description` (string, optional) - Category description
- `data.icon_name` (string, required) - Material icon name
- `data.color_hex` (string, required) - Hex color code
- `data.display_order` (number, optional) - Display order (default: 0)
- `data.is_active` (boolean, optional) - Active status (default: true)

**Returns:** Promise<ServiceCategory>

**Throws:**
- Validation error if data is invalid
- Error if category name already exists

**Example:**
```javascript
const newCategory = await serviceCategoryRepository.createCategory({
  name: 'Carpenter',
  name_si: 'වඩු කාර්මිකයා',
  icon_name: 'carpenter',
  color_hex: '#8B4513',
  display_order: 1,
});
```

#### `updateCategory(id, data)`
Update an existing service category.

**Parameters:**
- `id` (string) - Category UUID
- `data` (object) - Fields to update (same as createCategory)

**Returns:** Promise<ServiceCategory|null>

**Throws:**
- Validation error if data is invalid
- Error if no fields provided
- Error if category name already exists

**Example:**
```javascript
const updated = await serviceCategoryRepository.updateCategory(
  '123e4567-e89b-12d3-a456-426614174000',
  { description: 'Updated description', display_order: 2 }
);
```

#### `deleteCategory(id)`
Delete a service category.

**Parameters:**
- `id` (string) - Category UUID

**Returns:** Promise<boolean> - true if deleted, false if not found

**Throws:**
- Error if category is referenced by service providers (foreign key constraint)

**Example:**
```javascript
const deleted = await serviceCategoryRepository.deleteCategory('123e4567-e89b-12d3-a456-426614174000');
```

### Error Handling

The repository handles common database errors:

- **Validation errors**: Thrown with `validationErrors` property containing an array of error messages
- **Unique constraint violations** (code 23505): Thrown with message "A category with this name already exists"
- **Foreign key violations** (code 23503): Thrown with message "Cannot delete category: it is referenced by service providers"
- **Connection errors**: Thrown with generic error message

### Example Usage

```javascript
const serviceCategoryRepository = require('./repositories/serviceCategoryRepository');

async function example() {
  try {
    // Get all active categories
    const categories = await serviceCategoryRepository.getAllCategories({ 
      activeOnly: true 
    });
    
    // Create a new category
    const newCategory = await serviceCategoryRepository.createCategory({
      name: 'Test Category',
      icon_name: 'build',
      color_hex: '#FF5733',
    });
    
    // Update the category
    const updated = await serviceCategoryRepository.updateCategory(
      newCategory.id,
      { description: 'Updated description' }
    );
    
    // Delete the category
    await serviceCategoryRepository.deleteCategory(newCategory.id);
    
  } catch (error) {
    if (error.validationErrors) {
      console.error('Validation errors:', error.validationErrors);
    } else {
      console.error('Error:', error.message);
    }
  }
}
```

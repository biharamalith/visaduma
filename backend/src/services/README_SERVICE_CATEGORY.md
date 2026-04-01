# Service Category Service Layer

## Overview

The `serviceCategoryService` provides business logic for managing service categories with Redis caching. It acts as an intermediary between controllers and the repository layer.

## Features

- **Redis Caching**: All queries are cached with 1-hour TTL
- **Automatic Cache Invalidation**: Cache is invalidated on create, update, and delete operations
- **Business Logic Layer**: Separates concerns between controllers and data access

## Usage

### Import the Service

```javascript
const serviceCategoryService = require('./services/serviceCategoryService');
```

### Get All Categories

```javascript
// Get all categories (cached)
const categories = await serviceCategoryService.getAllCategories();

// Get only active categories
const activeCategories = await serviceCategoryService.getAllCategories({ 
  activeOnly: true 
});

// Get categories ordered by name
const categoriesByName = await serviceCategoryService.getAllCategories({ 
  orderBy: 'name' 
});
```

### Get Category by ID

```javascript
const category = await serviceCategoryService.getCategoryById('category-uuid');

if (category) {
  console.log('Found:', category.name);
} else {
  console.log('Category not found');
}
```

### Create Category

```javascript
const newCategory = await serviceCategoryService.createCategory({
  name: 'Carpenter',
  name_si: 'වඩු කාර්මිකයා',
  name_ta: 'தச்சர்',
  description: 'Professional carpentry services',
  icon_name: 'carpenter',
  color_hex: '#2563EB',
  display_order: 1,
  is_active: true
});

// Cache is automatically invalidated
```

### Update Category

```javascript
const updated = await serviceCategoryService.updateCategory('category-uuid', {
  description: 'Updated description',
  display_order: 2
});

// Cache is automatically invalidated
```

### Delete Category

```javascript
const deleted = await serviceCategoryService.deleteCategory('category-uuid');

if (deleted) {
  console.log('Category deleted successfully');
}

// Cache is automatically invalidated
```

## Caching Strategy

### Cache Keys

- All categories: `service_category:all:active_{bool}:order_{field}`
- Single category: `service_category:{id}`

### TTL

- All cache entries: 3600 seconds (1 hour)

### Cache Invalidation

- **Create**: Invalidates all categories cache
- **Update**: Invalidates specific category + all categories cache
- **Delete**: Invalidates specific category + all categories cache

## Error Handling

All methods throw errors that should be caught by the controller:

```javascript
try {
  const categories = await serviceCategoryService.getAllCategories();
  res.json(categories);
} catch (error) {
  console.error('Error:', error);
  res.status(500).json({ error: 'Failed to fetch categories' });
}
```

## Testing

Run the test suite:

```bash
node backend/test-service-category-service.js
```

The test verifies:
- Cache miss on first call
- Cache hit on subsequent calls
- Cache invalidation on updates
- Different query options
- Error handling

## Performance

With Redis caching:
- First call: ~50-100ms (database query)
- Cached calls: ~1-5ms (Redis lookup)
- Speedup: 10-50x faster

## Dependencies

- `serviceCategoryRepository`: Database operations
- `cacheService`: Redis caching operations
- Redis server must be running for caching to work

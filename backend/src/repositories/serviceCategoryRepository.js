/**
 * Service Category Repository
 * 
 * Handles database operations for service categories.
 */

const { pool } = require('../config/database');
const ServiceCategory = require('../models/ServiceCategory');

/**
 * Get all service categories
 * @param {Object} options - Query options
 * @param {boolean} options.activeOnly - Filter for active categories only
 * @param {string} options.orderBy - Order by field (default: display_order)
 * @returns {Promise<ServiceCategory[]>} Array of service categories
 */
async function getAllCategories(options = {}) {
  const { activeOnly = false, orderBy = 'display_order' } = options;

  let query = 'SELECT * FROM service_categories';
  const params = [];

  if (activeOnly) {
    query += ' WHERE is_active = $1';
    params.push(true);
  }

  // Validate orderBy to prevent SQL injection
  const validOrderFields = ['display_order', 'name', 'created_at'];
  const orderField = validOrderFields.includes(orderBy) ? orderBy : 'display_order';
  query += ` ORDER BY ${orderField} ASC`;

  try {
    const result = await pool.query(query, params);
    return result.rows.map(row => new ServiceCategory(row));
  } catch (error) {
    console.error('Error fetching all categories:', error);
    throw new Error('Failed to fetch service categories');
  }
}

/**
 * Get a service category by ID
 * @param {string} id - Category UUID
 * @returns {Promise<ServiceCategory|null>} Service category or null if not found
 */
async function getCategoryById(id) {
  const query = 'SELECT * FROM service_categories WHERE id = $1';

  try {
    const result = await pool.query(query, [id]);
    
    if (result.rows.length === 0) {
      return null;
    }

    return new ServiceCategory(result.rows[0]);
  } catch (error) {
    console.error('Error fetching category by ID:', error);
    throw new Error('Failed to fetch service category');
  }
}

/**
 * Create a new service category
 * @param {Object} data - Category data
 * @param {string} data.name - Category name (required)
 * @param {string} data.name_si - Sinhala name (optional)
 * @param {string} data.name_ta - Tamil name (optional)
 * @param {string} data.description - Category description (optional)
 * @param {string} data.icon_name - Material icon name (required)
 * @param {string} data.color_hex - Hex color code (required)
 * @param {number} data.display_order - Display order (optional, default: 0)
 * @param {boolean} data.is_active - Active status (optional, default: true)
 * @returns {Promise<ServiceCategory>} Created service category
 */
async function createCategory(data) {
  // Validate data
  const validation = ServiceCategory.validate(data);
  if (!validation.isValid) {
    const error = new Error('Validation failed');
    error.validationErrors = validation.errors;
    throw error;
  }

  const query = `
    INSERT INTO service_categories (
      name, name_si, name_ta, description, icon_name, 
      color_hex, display_order, is_active
    )
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
    RETURNING *
  `;

  const params = [
    data.name,
    data.name_si || null,
    data.name_ta || null,
    data.description || null,
    data.icon_name,
    data.color_hex,
    data.display_order || 0,
    data.is_active !== undefined ? data.is_active : true,
  ];

  try {
    const result = await pool.query(query, params);
    return new ServiceCategory(result.rows[0]);
  } catch (error) {
    console.error('Error creating category:', error);
    
    // Handle unique constraint violations
    if (error.code === '23505') {
      throw new Error('A category with this name already exists');
    }
    
    throw new Error('Failed to create service category');
  }
}

/**
 * Update a service category
 * @param {string} id - Category UUID
 * @param {Object} data - Updated category data
 * @returns {Promise<ServiceCategory|null>} Updated category or null if not found
 */
async function updateCategory(id, data) {
  // Validate data if provided
  if (Object.keys(data).length > 0) {
    const validation = ServiceCategory.validate({ ...data, name: data.name || 'temp', icon_name: data.icon_name || 'temp', color_hex: data.color_hex || '#000000' });
    if (!validation.isValid && data.name && data.icon_name && data.color_hex) {
      const error = new Error('Validation failed');
      error.validationErrors = validation.errors;
      throw error;
    }
  }

  // Build dynamic update query
  const fields = [];
  const params = [];
  let paramIndex = 1;

  if (data.name !== undefined) {
    fields.push(`name = $${paramIndex++}`);
    params.push(data.name);
  }
  if (data.name_si !== undefined) {
    fields.push(`name_si = $${paramIndex++}`);
    params.push(data.name_si);
  }
  if (data.name_ta !== undefined) {
    fields.push(`name_ta = $${paramIndex++}`);
    params.push(data.name_ta);
  }
  if (data.description !== undefined) {
    fields.push(`description = $${paramIndex++}`);
    params.push(data.description);
  }
  if (data.icon_name !== undefined) {
    fields.push(`icon_name = $${paramIndex++}`);
    params.push(data.icon_name);
  }
  if (data.color_hex !== undefined) {
    fields.push(`color_hex = $${paramIndex++}`);
    params.push(data.color_hex);
  }
  if (data.display_order !== undefined) {
    fields.push(`display_order = $${paramIndex++}`);
    params.push(data.display_order);
  }
  if (data.is_active !== undefined) {
    fields.push(`is_active = $${paramIndex++}`);
    params.push(data.is_active);
  }

  if (fields.length === 0) {
    throw new Error('No fields to update');
  }

  params.push(id);
  const query = `
    UPDATE service_categories
    SET ${fields.join(', ')}
    WHERE id = $${paramIndex}
    RETURNING *
  `;

  try {
    const result = await pool.query(query, params);
    
    if (result.rows.length === 0) {
      return null;
    }

    return new ServiceCategory(result.rows[0]);
  } catch (error) {
    console.error('Error updating category:', error);
    
    // Handle unique constraint violations
    if (error.code === '23505') {
      throw new Error('A category with this name already exists');
    }
    
    throw new Error('Failed to update service category');
  }
}

/**
 * Delete a service category
 * @param {string} id - Category UUID
 * @returns {Promise<boolean>} True if deleted, false if not found
 */
async function deleteCategory(id) {
  const query = 'DELETE FROM service_categories WHERE id = $1 RETURNING id';

  try {
    const result = await pool.query(query, [id]);
    return result.rows.length > 0;
  } catch (error) {
    console.error('Error deleting category:', error);
    
    // Handle foreign key constraint violations
    if (error.code === '23503') {
      throw new Error('Cannot delete category: it is referenced by service providers');
    }
    
    throw new Error('Failed to delete service category');
  }
}

module.exports = {
  getAllCategories,
  getCategoryById,
  createCategory,
  updateCategory,
  deleteCategory,
};

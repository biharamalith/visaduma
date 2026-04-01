/**
 * Service Category Service Layer
 * 
 * Provides business logic for service categories with Redis caching.
 * Acts as an intermediary between controllers and the repository layer.
 * 
 * Caching Strategy:
 * - All categories cached with 1 hour TTL
 * - Individual categories cached with 1 hour TTL
 * - Cache invalidation on updates
 */

const serviceCategoryRepository = require('../repositories/serviceCategoryRepository');
const cacheService = require('./cacheService');

// Cache configuration
const CACHE_TTL = 3600; // 1 hour in seconds
const CACHE_PREFIX = 'service_category';

/**
 * Generate cache key for all categories
 * @param {Object} options - Query options
 * @returns {string} Cache key
 */
function getAllCategoriesCacheKey(options = {}) {
  const { activeOnly = false, orderBy = 'display_order' } = options;
  return `${CACHE_PREFIX}:all:active_${activeOnly}:order_${orderBy}`;
}

/**
 * Generate cache key for a single category
 * @param {string} id - Category ID
 * @returns {string} Cache key
 */
function getCategoryCacheKey(id) {
  return `${CACHE_PREFIX}:${id}`;
}

/**
 * Get all service categories with caching
 * @param {Object} options - Query options
 * @param {boolean} options.activeOnly - Filter for active categories only
 * @param {string} options.orderBy - Order by field (default: display_order)
 * @returns {Promise<ServiceCategory[]>} Array of service categories
 */
async function getAllCategories(options = {}) {
  const cacheKey = getAllCategoriesCacheKey(options);

  try {
    // Try to get from cache first
    const cachedData = await cacheService.get(cacheKey);
    
    if (cachedData) {
      console.log(`✅ Cache hit: ${cacheKey}`);
      return cachedData;
    }

    console.log(`❌ Cache miss: ${cacheKey}`);

    // Fetch from database
    const categories = await serviceCategoryRepository.getAllCategories(options);

    // Store in cache
    await cacheService.set(cacheKey, categories, CACHE_TTL);

    return categories;
  } catch (error) {
    console.error('Error in getAllCategories service:', error);
    throw error;
  }
}

/**
 * Get a service category by ID with caching
 * @param {string} id - Category UUID
 * @returns {Promise<ServiceCategory|null>} Service category or null if not found
 */
async function getCategoryById(id) {
  const cacheKey = getCategoryCacheKey(id);

  try {
    // Try to get from cache first
    const cachedData = await cacheService.get(cacheKey);
    
    if (cachedData) {
      console.log(`✅ Cache hit: ${cacheKey}`);
      return cachedData;
    }

    console.log(`❌ Cache miss: ${cacheKey}`);

    // Fetch from database
    const category = await serviceCategoryRepository.getCategoryById(id);

    // Store in cache if found
    if (category) {
      await cacheService.set(cacheKey, category, CACHE_TTL);
    }

    return category;
  } catch (error) {
    console.error('Error in getCategoryById service:', error);
    throw error;
  }
}

/**
 * Create a new service category and invalidate cache
 * @param {Object} data - Category data
 * @returns {Promise<ServiceCategory>} Created service category
 */
async function createCategory(data) {
  try {
    // Create category in database
    const category = await serviceCategoryRepository.createCategory(data);

    // Invalidate all categories cache
    await invalidateAllCategoriesCache();

    return category;
  } catch (error) {
    console.error('Error in createCategory service:', error);
    throw error;
  }
}

/**
 * Update a service category and invalidate cache
 * @param {string} id - Category UUID
 * @param {Object} data - Updated category data
 * @returns {Promise<ServiceCategory|null>} Updated category or null if not found
 */
async function updateCategory(id, data) {
  try {
    // Update category in database
    const category = await serviceCategoryRepository.updateCategory(id, data);

    if (category) {
      // Invalidate specific category cache
      await cacheService.del(getCategoryCacheKey(id));

      // Invalidate all categories cache
      await invalidateAllCategoriesCache();
    }

    return category;
  } catch (error) {
    console.error('Error in updateCategory service:', error);
    throw error;
  }
}

/**
 * Delete a service category and invalidate cache
 * @param {string} id - Category UUID
 * @returns {Promise<boolean>} True if deleted, false if not found
 */
async function deleteCategory(id) {
  try {
    // Delete category from database
    const deleted = await serviceCategoryRepository.deleteCategory(id);

    if (deleted) {
      // Invalidate specific category cache
      await cacheService.del(getCategoryCacheKey(id));

      // Invalidate all categories cache
      await invalidateAllCategoriesCache();
    }

    return deleted;
  } catch (error) {
    console.error('Error in deleteCategory service:', error);
    throw error;
  }
}

/**
 * Invalidate all categories cache entries
 * @returns {Promise<void>}
 */
async function invalidateAllCategoriesCache() {
  try {
    // Delete all cache entries matching the pattern
    const pattern = `${CACHE_PREFIX}:all:*`;
    const deletedCount = await cacheService.delPattern(pattern);
    
    if (deletedCount > 0) {
      console.log(`🗑️  Invalidated ${deletedCount} category cache entries`);
    }
  } catch (error) {
    console.error('Error invalidating categories cache:', error);
    // Don't throw - cache invalidation failure shouldn't break the operation
  }
}

/**
 * Invalidate cache for a specific category
 * @param {string} id - Category UUID
 * @returns {Promise<void>}
 */
async function invalidateCategoryCache(id) {
  try {
    await cacheService.del(getCategoryCacheKey(id));
    console.log(`🗑️  Invalidated cache for category: ${id}`);
  } catch (error) {
    console.error('Error invalidating category cache:', error);
    // Don't throw - cache invalidation failure shouldn't break the operation
  }
}

module.exports = {
  getAllCategories,
  getCategoryById,
  createCategory,
  updateCategory,
  deleteCategory,
  invalidateAllCategoriesCache,
  invalidateCategoryCache,
};

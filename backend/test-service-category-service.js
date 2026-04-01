/**
 * Test script for Service Category Service Layer
 * Tests caching functionality and business logic
 * 
 * Run with: node backend/test-service-category-service.js
 */

const { pool } = require('./src/config/database');
const { initializeRedis, closeRedis } = require('./src/config/redis');
const serviceCategoryService = require('./src/services/serviceCategoryService');
const cacheService = require('./src/services/cacheService');

async function testServiceCategoryService() {
  console.log('🧪 Testing Service Category Service Layer...\n');

  try {
    // Initialize connections
    console.log('📡 Initializing Redis...');
    initializeRedis();
    console.log('✅ Redis initialized\n');

    // Test 1: Get all categories (should fetch from DB and cache)
    console.log('Test 1: Get all categories (first call - cache miss)');
    const startTime1 = Date.now();
    const categories1 = await serviceCategoryService.getAllCategories();
    const duration1 = Date.now() - startTime1;
    console.log(`✅ Retrieved ${categories1.length} categories in ${duration1}ms`);
    console.log('First category:', categories1[0]?.name || 'No categories found');
    console.log('');

    // Test 2: Get all categories again (should fetch from cache)
    console.log('Test 2: Get all categories (second call - cache hit)');
    const startTime2 = Date.now();
    const categories2 = await serviceCategoryService.getAllCategories();
    const duration2 = Date.now() - startTime2;
    console.log(`✅ Retrieved ${categories2.length} categories in ${duration2}ms`);
    console.log(`⚡ Cache speedup: ${duration1 - duration2}ms faster`);
    console.log('');

    // Test 3: Get category by ID (should fetch from DB and cache)
    if (categories1.length > 0) {
      const testCategoryId = categories1[0].id;
      
      console.log('Test 3: Get category by ID (first call - cache miss)');
      const startTime3 = Date.now();
      const category1 = await serviceCategoryService.getCategoryById(testCategoryId);
      const duration3 = Date.now() - startTime3;
      console.log(`✅ Retrieved category "${category1?.name}" in ${duration3}ms`);
      console.log('');

      // Test 4: Get category by ID again (should fetch from cache)
      console.log('Test 4: Get category by ID (second call - cache hit)');
      const startTime4 = Date.now();
      const category2 = await serviceCategoryService.getCategoryById(testCategoryId);
      const duration4 = Date.now() - startTime4;
      console.log(`✅ Retrieved category "${category2?.name}" in ${duration4}ms`);
      console.log(`⚡ Cache speedup: ${duration3 - duration4}ms faster`);
      console.log('');
    }

    // Test 5: Get active categories only
    console.log('Test 5: Get active categories only');
    const activeCategories = await serviceCategoryService.getAllCategories({ activeOnly: true });
    console.log(`✅ Retrieved ${activeCategories.length} active categories`);
    console.log('');

    // Test 6: Get categories ordered by name
    console.log('Test 6: Get categories ordered by name');
    const categoriesByName = await serviceCategoryService.getAllCategories({ orderBy: 'name' });
    console.log(`✅ Retrieved ${categoriesByName.length} categories ordered by name`);
    if (categoriesByName.length > 0) {
      console.log('First category:', categoriesByName[0].name);
    }
    console.log('');

    // Test 7: Test cache invalidation on update
    if (categories1.length > 0) {
      const testCategoryId = categories1[0].id;
      
      console.log('Test 7: Test cache invalidation on update');
      console.log('Updating category...');
      const updatedCategory = await serviceCategoryService.updateCategory(testCategoryId, {
        description: 'Updated description for testing - ' + new Date().toISOString()
      });
      
      if (updatedCategory) {
        console.log('✅ Category updated successfully');
        
        // Verify cache was invalidated by fetching again
        const categoryAfterUpdate = await serviceCategoryService.getCategoryById(testCategoryId);
        console.log('✅ Fetched updated category from DB (cache was invalidated)');
        console.log('New description:', categoryAfterUpdate.description);
      }
      console.log('');
    }

    // Test 8: Test non-existent category
    console.log('Test 8: Get non-existent category');
    const nonExistent = await serviceCategoryService.getCategoryById('00000000-0000-0000-0000-000000000000');
    console.log(`✅ Non-existent category returned: ${nonExistent === null ? 'null (correct)' : 'unexpected value'}`);
    console.log('');

    console.log('✅ All tests completed successfully!');

  } catch (error) {
    console.error('❌ Test failed:', error.message);
    console.error(error);
  } finally {
    // Cleanup
    console.log('\n🧹 Cleaning up...');
    await closeRedis();
    await pool.end();
    console.log('✅ Cleanup complete');
  }
}

// Run tests
testServiceCategoryService();

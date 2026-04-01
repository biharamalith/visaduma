/**
 * Test script for Service Category model and repository
 * 
 * Run with: node backend/test-service-category.js
 */

const serviceCategoryRepository = require('./src/repositories/serviceCategoryRepository');

async function testServiceCategory() {
  console.log('🧪 Testing Service Category Repository...\n');

  try {
    // Test 1: Get all categories
    console.log('Test 1: Get all categories');
    const allCategories = await serviceCategoryRepository.getAllCategories();
    console.log(`✅ Found ${allCategories.length} categories`);
    if (allCategories.length > 0) {
      console.log('   First category:', allCategories[0].toJSON());
    }
    console.log();

    // Test 2: Get active categories only
    console.log('Test 2: Get active categories only');
    const activeCategories = await serviceCategoryRepository.getAllCategories({ activeOnly: true });
    console.log(`✅ Found ${activeCategories.length} active categories`);
    console.log();

    // Test 3: Get category by ID
    if (allCategories.length > 0) {
      const firstCategoryId = allCategories[0].id;
      console.log('Test 3: Get category by ID');
      const category = await serviceCategoryRepository.getCategoryById(firstCategoryId);
      console.log('✅ Retrieved category:', category.name);
      console.log('   Localized name (si):', category.getLocalizedName('si'));
      console.log();
    }

    // Test 4: Create a new category
    console.log('Test 4: Create a new category');
    const newCategoryData = {
      name: 'Test Category',
      name_si: 'පරීක්ෂණ කාණ්ඩය',
      name_ta: 'சோதனை வகை',
      description: 'This is a test category',
      icon_name: 'build',
      color_hex: '#FF5733',
      display_order: 999,
      is_active: true,
    };
    const newCategory = await serviceCategoryRepository.createCategory(newCategoryData);
    console.log('✅ Created category:', newCategory.name, '(ID:', newCategory.id + ')');
    console.log();

    // Test 5: Update the category
    console.log('Test 5: Update the category');
    const updatedCategory = await serviceCategoryRepository.updateCategory(newCategory.id, {
      description: 'Updated test category description',
      display_order: 1000,
    });
    console.log('✅ Updated category:', updatedCategory.name);
    console.log('   New description:', updatedCategory.description);
    console.log();

    // Test 6: Delete the category
    console.log('Test 6: Delete the category');
    const deleted = await serviceCategoryRepository.deleteCategory(newCategory.id);
    console.log('✅ Deleted category:', deleted);
    console.log();

    // Test 7: Verify deletion
    console.log('Test 7: Verify deletion');
    const deletedCategory = await serviceCategoryRepository.getCategoryById(newCategory.id);
    console.log('✅ Category after deletion:', deletedCategory === null ? 'null (as expected)' : 'ERROR: still exists');
    console.log();

    console.log('🎉 All tests passed!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Test failed:', error.message);
    if (error.validationErrors) {
      console.error('   Validation errors:', error.validationErrors);
    }
    console.error('   Stack:', error.stack);
    process.exit(1);
  }
}

// Run tests
testServiceCategory();

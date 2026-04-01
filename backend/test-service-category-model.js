/**
 * Unit test for Service Category model (no database required)
 * 
 * Run with: node backend/test-service-category-model.js
 */

const ServiceCategory = require('./src/models/ServiceCategory');

function testServiceCategoryModel() {
  console.log('🧪 Testing Service Category Model...\n');

  let testsPassed = 0;
  let testsFailed = 0;

  // Test 1: Create a valid category
  console.log('Test 1: Create a valid category');
  try {
    const categoryData = {
      id: '123e4567-e89b-12d3-a456-426614174000',
      name: 'Carpenter',
      name_si: 'වඩු කාර්මිකයා',
      name_ta: 'தச்சர்',
      description: 'Professional carpentry services',
      icon_name: 'carpenter',
      color_hex: '#8B4513',
      display_order: 1,
      is_active: true,
      created_at: new Date(),
    };
    const category = new ServiceCategory(categoryData);
    console.log('✅ Category created:', category.name);
    console.log('   JSON:', JSON.stringify(category.toJSON(), null, 2));
    testsPassed++;
  } catch (error) {
    console.error('❌ Failed:', error.message);
    testsFailed++;
  }
  console.log();

  // Test 2: Test localized names
  console.log('Test 2: Test localized names');
  try {
    const category = new ServiceCategory({
      id: '123e4567-e89b-12d3-a456-426614174000',
      name: 'Electrician',
      name_si: 'විදුලි කාර්මිකයා',
      name_ta: 'மின்சாரம்',
      icon_name: 'electrical_services',
      color_hex: '#FFA500',
      display_order: 2,
      created_at: new Date(),
    });
    
    const nameEn = category.getLocalizedName('en');
    const nameSi = category.getLocalizedName('si');
    const nameTa = category.getLocalizedName('ta');
    
    console.log('✅ English name:', nameEn);
    console.log('   Sinhala name:', nameSi);
    console.log('   Tamil name:', nameTa);
    
    if (nameEn === 'Electrician' && nameSi === 'විදුලි කාර්මිකයා' && nameTa === 'மின்சாரம்') {
      testsPassed++;
    } else {
      throw new Error('Localized names do not match expected values');
    }
  } catch (error) {
    console.error('❌ Failed:', error.message);
    testsFailed++;
  }
  console.log();

  // Test 3: Validate valid data
  console.log('Test 3: Validate valid data');
  try {
    const validData = {
      name: 'Plumber',
      icon_name: 'plumbing',
      color_hex: '#1E90FF',
      display_order: 3,
    };
    const validation = ServiceCategory.validate(validData);
    
    if (validation.isValid) {
      console.log('✅ Valid data passed validation');
      testsPassed++;
    } else {
      throw new Error('Valid data failed validation: ' + validation.errors.join(', '));
    }
  } catch (error) {
    console.error('❌ Failed:', error.message);
    testsFailed++;
  }
  console.log();

  // Test 4: Validate missing required fields
  console.log('Test 4: Validate missing required fields');
  try {
    const invalidData = {
      description: 'Missing required fields',
    };
    const validation = ServiceCategory.validate(invalidData);
    
    if (!validation.isValid && validation.errors.length > 0) {
      console.log('✅ Invalid data correctly rejected');
      console.log('   Errors:', validation.errors);
      testsPassed++;
    } else {
      throw new Error('Invalid data was not rejected');
    }
  } catch (error) {
    console.error('❌ Failed:', error.message);
    testsFailed++;
  }
  console.log();

  // Test 5: Validate invalid color hex
  console.log('Test 5: Validate invalid color hex');
  try {
    const invalidData = {
      name: 'Painter',
      icon_name: 'format_paint',
      color_hex: 'invalid',
      display_order: 4,
    };
    const validation = ServiceCategory.validate(invalidData);
    
    if (!validation.isValid && validation.errors.some(e => e.includes('Color hex'))) {
      console.log('✅ Invalid color hex correctly rejected');
      console.log('   Errors:', validation.errors);
      testsPassed++;
    } else {
      throw new Error('Invalid color hex was not rejected');
    }
  } catch (error) {
    console.error('❌ Failed:', error.message);
    testsFailed++;
  }
  console.log();

  // Test 6: Validate field length limits
  console.log('Test 6: Validate field length limits');
  try {
    const invalidData = {
      name: 'A'.repeat(101), // Exceeds 100 character limit
      icon_name: 'icon',
      color_hex: '#FF0000',
    };
    const validation = ServiceCategory.validate(invalidData);
    
    if (!validation.isValid && validation.errors.some(e => e.includes('100 characters'))) {
      console.log('✅ Field length limit correctly enforced');
      console.log('   Errors:', validation.errors);
      testsPassed++;
    } else {
      throw new Error('Field length limit was not enforced');
    }
  } catch (error) {
    console.error('❌ Failed:', error.message);
    testsFailed++;
  }
  console.log();

  // Test 7: Test default values
  console.log('Test 7: Test default values');
  try {
    const minimalData = {
      id: '123e4567-e89b-12d3-a456-426614174000',
      name: 'AC Repair',
      icon_name: 'ac_unit',
      color_hex: '#00CED1',
      created_at: new Date(),
    };
    const category = new ServiceCategory(minimalData);
    
    if (category.display_order === 0 && category.is_active === true && category.description === null) {
      console.log('✅ Default values correctly applied');
      console.log('   display_order:', category.display_order);
      console.log('   is_active:', category.is_active);
      console.log('   description:', category.description);
      testsPassed++;
    } else {
      throw new Error('Default values were not correctly applied');
    }
  } catch (error) {
    console.error('❌ Failed:', error.message);
    testsFailed++;
  }
  console.log();

  // Summary
  console.log('═'.repeat(50));
  console.log(`Tests passed: ${testsPassed}`);
  console.log(`Tests failed: ${testsFailed}`);
  console.log('═'.repeat(50));

  if (testsFailed === 0) {
    console.log('🎉 All tests passed!');
    process.exit(0);
  } else {
    console.log('❌ Some tests failed');
    process.exit(1);
  }
}

// Run tests
testServiceCategoryModel();

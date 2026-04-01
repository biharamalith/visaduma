const { s3, BUCKET_NAME, validateS3Config } = require('./src/config/s3');

/**
 * Test script to verify S3 connection and configuration
 */

async function testS3Connection() {
  console.log('\n🧪 Testing AWS S3 Connection...\n');

  // Validate configuration
  console.log('1. Validating AWS credentials...');
  const isConfigValid = validateS3Config();
  
  if (!isConfigValid) {
    console.error('❌ AWS credentials not configured properly');
    console.log('\nPlease ensure the following environment variables are set in .env:');
    console.log('  - AWS_REGION');
    console.log('  - AWS_ACCESS_KEY_ID');
    console.log('  - AWS_SECRET_ACCESS_KEY');
    console.log('  - AWS_S3_BUCKET\n');
    process.exit(1);
  }
  console.log('✅ AWS credentials configured\n');

  // Test bucket access
  console.log(`2. Testing access to bucket: ${BUCKET_NAME}...`);
  try {
    await s3.headBucket({ Bucket: BUCKET_NAME }).promise();
    console.log('✅ Bucket exists and is accessible\n');
  } catch (error) {
    if (error.statusCode === 404) {
      console.log('⚠️  Bucket does not exist');
      console.log(`\nTo create the bucket, run: node src/utils/s3Setup.js setup\n`);
      process.exit(1);
    } else if (error.statusCode === 403) {
      console.error('❌ Access denied to bucket');
      console.log('\nPlease check:');
      console.log('  1. AWS credentials are correct');
      console.log('  2. IAM user has necessary S3 permissions');
      console.log('  3. Bucket name is correct\n');
      process.exit(1);
    } else {
      console.error('❌ Error accessing bucket:', error.message);
      process.exit(1);
    }
  }

  // Test bucket location
  console.log('3. Checking bucket location...');
  try {
    const location = await s3.getBucketLocation({ Bucket: BUCKET_NAME }).promise();
    const region = location.LocationConstraint || 'us-east-1';
    console.log(`✅ Bucket region: ${region}\n`);
  } catch (error) {
    console.error('❌ Failed to get bucket location:', error.message);
  }

  // Test CORS configuration
  console.log('4. Checking CORS configuration...');
  try {
    const cors = await s3.getBucketCors({ Bucket: BUCKET_NAME }).promise();
    console.log('✅ CORS is configured');
    console.log(`   Rules: ${cors.CORSRules.length}\n`);
  } catch (error) {
    if (error.code === 'NoSuchCORSConfiguration') {
      console.log('⚠️  CORS not configured');
      console.log('   Run: node src/utils/s3Setup.js cors\n');
    } else {
      console.error('❌ Error checking CORS:', error.message);
    }
  }

  // Test bucket policy
  console.log('5. Checking bucket policy...');
  try {
    await s3.getBucketPolicy({ Bucket: BUCKET_NAME }).promise();
    console.log('✅ Bucket policy is configured\n');
  } catch (error) {
    if (error.code === 'NoSuchBucketPolicy') {
      console.log('⚠️  Bucket policy not configured');
      console.log('   Run: node src/utils/s3Setup.js policy\n');
    } else {
      console.error('❌ Error checking bucket policy:', error.message);
    }
  }

  // Test encryption
  console.log('6. Checking encryption...');
  try {
    const encryption = await s3.getBucketEncryption({ Bucket: BUCKET_NAME }).promise();
    console.log('✅ Server-side encryption is enabled');
    console.log(`   Algorithm: ${encryption.ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm}\n`);
  } catch (error) {
    if (error.code === 'ServerSideEncryptionConfigurationNotFoundError') {
      console.log('⚠️  Encryption not enabled');
      console.log('   Run: node src/utils/s3Setup.js setup\n');
    } else {
      console.error('❌ Error checking encryption:', error.message);
    }
  }

  // Test upload capability (small test file)
  console.log('7. Testing upload capability...');
  try {
    const testKey = 'test/connection-test.txt';
    const testContent = `S3 connection test - ${new Date().toISOString()}`;
    
    await s3.putObject({
      Bucket: BUCKET_NAME,
      Key: testKey,
      Body: testContent,
      ContentType: 'text/plain'
    }).promise();
    
    console.log('✅ Upload test successful\n');

    // Clean up test file
    console.log('8. Cleaning up test file...');
    await s3.deleteObject({
      Bucket: BUCKET_NAME,
      Key: testKey
    }).promise();
    console.log('✅ Cleanup successful\n');
  } catch (error) {
    console.error('❌ Upload test failed:', error.message);
    console.log('\nPlease check IAM permissions for PutObject and DeleteObject\n');
    process.exit(1);
  }

  // Summary
  console.log('═══════════════════════════════════════════════════════');
  console.log('✅ All S3 connection tests passed!');
  console.log('═══════════════════════════════════════════════════════');
  console.log(`\nBucket: ${BUCKET_NAME}`);
  console.log(`Region: ${process.env.AWS_REGION || 'ap-south-1'}`);
  console.log('\nYou can now use S3 for file uploads in the VisaDuma app.\n');
}

// Run tests
testS3Connection()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('\n❌ S3 connection test failed:', error.message);
    process.exit(1);
  });

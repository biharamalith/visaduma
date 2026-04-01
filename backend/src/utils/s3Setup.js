const { s3, BUCKET_NAME } = require('../config/s3');

/**
 * S3 Bucket Setup Utility
 * Configures bucket policies and CORS for the VisaDuma S3 bucket
 */

/**
 * CORS configuration for S3 bucket
 * Allows uploads from web and mobile clients
 */
const corsConfiguration = {
  CORSRules: [
    {
      AllowedOrigins: ['*'], // In production, replace with specific domains
      AllowedMethods: ['GET', 'POST', 'PUT', 'DELETE', 'HEAD'],
      AllowedHeaders: ['*'],
      ExposeHeaders: ['ETag', 'x-amz-server-side-encryption', 'x-amz-request-id'],
      MaxAgeSeconds: 3600
    }
  ]
};

/**
 * Bucket policy for public read access
 * Allows public read access to uploaded files
 */
const bucketPolicy = {
  Version: '2012-10-17',
  Statement: [
    {
      Sid: 'PublicReadGetObject',
      Effect: 'Allow',
      Principal: '*',
      Action: 's3:GetObject',
      Resource: `arn:aws:s3:::${BUCKET_NAME}/*`
    }
  ]
};

/**
 * Configure CORS for the S3 bucket
 */
async function configureCORS() {
  try {
    const params = {
      Bucket: BUCKET_NAME,
      CORSConfiguration: corsConfiguration
    };

    await s3.putBucketCors(params).promise();
    console.log('✅ CORS configuration applied successfully');
    return { success: true, message: 'CORS configured' };
  } catch (error) {
    console.error('❌ Failed to configure CORS:', error.message);
    throw error;
  }
}

/**
 * Configure bucket policy for public read access
 */
async function configureBucketPolicy() {
  try {
    const params = {
      Bucket: BUCKET_NAME,
      Policy: JSON.stringify(bucketPolicy)
    };

    await s3.putBucketPolicy(params).promise();
    console.log('✅ Bucket policy applied successfully');
    return { success: true, message: 'Bucket policy configured' };
  } catch (error) {
    console.error('❌ Failed to configure bucket policy:', error.message);
    throw error;
  }
}

/**
 * Enable server-side encryption for the bucket
 */
async function enableEncryption() {
  try {
    const params = {
      Bucket: BUCKET_NAME,
      ServerSideEncryptionConfiguration: {
        Rules: [
          {
            ApplyServerSideEncryptionByDefault: {
              SSEAlgorithm: 'AES256'
            },
            BucketKeyEnabled: true
          }
        ]
      }
    };

    await s3.putBucketEncryption(params).promise();
    console.log('✅ Server-side encryption enabled');
    return { success: true, message: 'Encryption enabled' };
  } catch (error) {
    console.error('❌ Failed to enable encryption:', error.message);
    throw error;
  }
}

/**
 * Configure lifecycle rules for automatic cleanup
 * Deletes incomplete multipart uploads after 7 days
 */
async function configureLifecycle() {
  try {
    const params = {
      Bucket: BUCKET_NAME,
      LifecycleConfiguration: {
        Rules: [
          {
            Id: 'DeleteIncompleteMultipartUploads',
            Status: 'Enabled',
            Prefix: '',
            AbortIncompleteMultipartUpload: {
              DaysAfterInitiation: 7
            }
          }
        ]
      }
    };

    await s3.putBucketLifecycleConfiguration(params).promise();
    console.log('✅ Lifecycle rules configured');
    return { success: true, message: 'Lifecycle rules configured' };
  } catch (error) {
    console.error('❌ Failed to configure lifecycle:', error.message);
    throw error;
  }
}

/**
 * Check if bucket exists
 */
async function checkBucketExists() {
  try {
    await s3.headBucket({ Bucket: BUCKET_NAME }).promise();
    console.log(`✅ Bucket '${BUCKET_NAME}' exists`);
    return true;
  } catch (error) {
    if (error.statusCode === 404) {
      console.log(`❌ Bucket '${BUCKET_NAME}' does not exist`);
      return false;
    }
    throw error;
  }
}

/**
 * Create S3 bucket if it doesn't exist
 */
async function createBucket() {
  try {
    const exists = await checkBucketExists();
    if (exists) {
      console.log('Bucket already exists, skipping creation');
      return { success: true, message: 'Bucket already exists' };
    }

    const params = {
      Bucket: BUCKET_NAME,
      CreateBucketConfiguration: {
        LocationConstraint: process.env.AWS_REGION || 'ap-south-1'
      }
    };

    await s3.createBucket(params).promise();
    console.log(`✅ Bucket '${BUCKET_NAME}' created successfully`);
    return { success: true, message: 'Bucket created' };
  } catch (error) {
    console.error('❌ Failed to create bucket:', error.message);
    throw error;
  }
}

/**
 * Run complete S3 setup
 */
async function setupS3() {
  console.log('\n🚀 Starting S3 bucket setup...\n');

  try {
    // Check/create bucket
    await createBucket();

    // Configure CORS
    await configureCORS();

    // Configure bucket policy
    await configureBucketPolicy();

    // Enable encryption
    await enableEncryption();

    // Configure lifecycle rules
    await configureLifecycle();

    console.log('\n✅ S3 bucket setup completed successfully!\n');
    return { success: true, message: 'S3 setup completed' };
  } catch (error) {
    console.error('\n❌ S3 setup failed:', error.message);
    console.error('\nPlease ensure:');
    console.error('1. AWS credentials are correctly configured in .env');
    console.error('2. IAM user has necessary S3 permissions');
    console.error('3. Bucket name is unique and available\n');
    throw error;
  }
}

/**
 * Get current bucket configuration
 */
async function getBucketInfo() {
  try {
    console.log(`\n📊 Bucket Information: ${BUCKET_NAME}\n`);

    // Get bucket location
    const location = await s3.getBucketLocation({ Bucket: BUCKET_NAME }).promise();
    console.log(`Region: ${location.LocationConstraint || 'us-east-1'}`);

    // Get CORS configuration
    try {
      const cors = await s3.getBucketCors({ Bucket: BUCKET_NAME }).promise();
      console.log('CORS: Configured');
    } catch (error) {
      console.log('CORS: Not configured');
    }

    // Get bucket policy
    try {
      await s3.getBucketPolicy({ Bucket: BUCKET_NAME }).promise();
      console.log('Bucket Policy: Configured');
    } catch (error) {
      console.log('Bucket Policy: Not configured');
    }

    // Get encryption
    try {
      await s3.getBucketEncryption({ Bucket: BUCKET_NAME }).promise();
      console.log('Encryption: Enabled');
    } catch (error) {
      console.log('Encryption: Not enabled');
    }

    console.log('');
  } catch (error) {
    console.error('Failed to get bucket info:', error.message);
    throw error;
  }
}

// CLI execution
if (require.main === module) {
  const command = process.argv[2];

  switch (command) {
    case 'setup':
      setupS3()
        .then(() => process.exit(0))
        .catch(() => process.exit(1));
      break;
    case 'info':
      getBucketInfo()
        .then(() => process.exit(0))
        .catch(() => process.exit(1));
      break;
    case 'cors':
      configureCORS()
        .then(() => process.exit(0))
        .catch(() => process.exit(1));
      break;
    case 'policy':
      configureBucketPolicy()
        .then(() => process.exit(0))
        .catch(() => process.exit(1));
      break;
    default:
      console.log('\nUsage: node src/utils/s3Setup.js [command]\n');
      console.log('Commands:');
      console.log('  setup  - Run complete S3 bucket setup');
      console.log('  info   - Display bucket configuration');
      console.log('  cors   - Configure CORS only');
      console.log('  policy - Configure bucket policy only\n');
      process.exit(0);
  }
}

module.exports = {
  setupS3,
  configureCORS,
  configureBucketPolicy,
  enableEncryption,
  configureLifecycle,
  createBucket,
  checkBucketExists,
  getBucketInfo
};

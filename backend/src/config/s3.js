const AWS = require('aws-sdk');
const dotenv = require('dotenv');

dotenv.config();

// Configure AWS SDK
const s3 = new AWS.S3({
  region: process.env.AWS_REGION || 'ap-south-1',
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  signatureVersion: 'v4'
});

// S3 bucket name
const BUCKET_NAME = process.env.AWS_S3_BUCKET || 'visaduma-uploads';

// Validate AWS configuration
const validateS3Config = () => {
  if (!process.env.AWS_ACCESS_KEY_ID || !process.env.AWS_SECRET_ACCESS_KEY) {
    console.warn('⚠️  AWS credentials not configured. S3 uploads will fail.');
    return false;
  }
  return true;
};

module.exports = {
  s3,
  BUCKET_NAME,
  validateS3Config
};

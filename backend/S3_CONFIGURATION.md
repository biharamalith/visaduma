# AWS S3 Configuration for VisaDuma

This document describes the AWS S3 file storage configuration for the VisaDuma super app backend.

## Overview

AWS S3 is configured for storing and serving various types of files:
- User avatars
- Product images
- Shop logos and banners
- Vehicle photos
- Service provider certifications
- Review images
- Chat attachments

## Architecture

```
┌─────────────────┐
│  Flutter App    │
│  (Mobile)       │
└────────┬────────┘
         │
         │ HTTP POST (multipart/form-data)
         │
         ▼
┌─────────────────┐
│  Express API    │
│  + Multer       │
└────────┬────────┘
         │
         │ Upload Buffer
         │
         ▼
┌─────────────────┐
│  S3 Service     │
│  (aws-sdk)      │
└────────┬────────┘
         │
         │ AWS SDK
         │
         ▼
┌─────────────────┐
│  AWS S3 Bucket  │
│  (Public Read)  │
└─────────────────┘
```

## Components

### 1. S3 Configuration (`src/config/s3.js`)

Initializes AWS SDK with credentials from environment variables:

```javascript
const s3 = new AWS.S3({
  region: process.env.AWS_REGION,
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  signatureVersion: 'v4'
});
```

### 2. S3 Service (`src/services/s3Service.js`)

Provides methods for file operations:

- `uploadFile(buffer, originalName, mimeType, folder)` - Upload single file
- `uploadMultipleFiles(files, folder)` - Upload multiple files
- `deleteFile(key)` - Delete single file
- `deleteMultipleFiles(keys)` - Delete multiple files
- `getSignedUrl(key, expiresIn)` - Generate signed URL for private access
- `fileExists(key)` - Check if file exists
- `getFileMetadata(key)` - Get file metadata
- `copyFile(sourceKey, destinationKey)` - Copy file within S3
- `listFiles(folder, maxKeys)` - List files in folder

### 3. Multer Middleware (`src/middleware/upload.js`)

Handles multipart form data uploads with validation:

**Pre-configured Middleware:**
- `uploadAvatar` - Single avatar (5MB, images only)
- `uploadImage` - Single image (10MB, images only)
- `uploadImages` - Multiple images (10MB each, up to 10)
- `uploadProductImages` - Product images (10MB each, up to 5)
- `uploadDocument` - Single document (20MB, documents only)
- `uploadDocuments` - Multiple documents (20MB each, up to 5)
- `uploadAttachment` - Chat attachment (25MB, all types)
- `uploadAttachments` - Multiple attachments (25MB each, up to 3)
- `uploadShopImages` - Shop logo and banner (10MB each)

**File Size Limits:**
- Avatar: 5MB
- Image: 10MB
- Document: 20MB
- Attachment: 25MB

**Allowed MIME Types:**
- Images: `image/jpeg`, `image/jpg`, `image/png`, `image/gif`, `image/webp`
- Documents: `application/pdf`, `.doc`, `.docx`, `.xls`, `.xlsx`

### 4. Upload Routes (`src/routes/upload.js`)

RESTful API endpoints for file operations:

- `POST /api/v1/upload/avatar` - Upload user avatar
- `POST /api/v1/upload/image` - Upload single image
- `POST /api/v1/upload/images` - Upload multiple images
- `POST /api/v1/upload/product-images` - Upload product images
- `POST /api/v1/upload/shop-images` - Upload shop logo/banner
- `POST /api/v1/upload/document` - Upload document
- `POST /api/v1/upload/attachment` - Upload chat attachment
- `DELETE /api/v1/upload/:key` - Delete file
- `GET /api/v1/upload/signed-url/:key` - Get signed URL

### 5. S3 Setup Utility (`src/utils/s3Setup.js`)

CLI tool for bucket configuration:

```bash
# Run complete setup
node src/utils/s3Setup.js setup

# View bucket info
node src/utils/s3Setup.js info

# Configure CORS only
node src/utils/s3Setup.js cors

# Configure bucket policy only
node src/utils/s3Setup.js policy
```

## Environment Variables

Add these to your `.env` file:

```env
# AWS Configuration
AWS_REGION=ap-south-1
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_S3_BUCKET=visaduma-uploads
```

## Setup Instructions

### 1. AWS IAM User Setup

Create an IAM user with the following permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket",
        "s3:PutBucketCors",
        "s3:PutBucketPolicy",
        "s3:PutBucketEncryption",
        "s3:PutLifecycleConfiguration"
      ],
      "Resource": [
        "arn:aws:s3:::visaduma-uploads",
        "arn:aws:s3:::visaduma-uploads/*"
      ]
    }
  ]
}
```

### 2. Configure Environment Variables

1. Copy `.env.example` to `.env`
2. Add your AWS credentials
3. Set your bucket name

### 3. Run S3 Setup

```bash
cd backend
node src/utils/s3Setup.js setup
```

This will:
- Create the S3 bucket (if it doesn't exist)
- Configure CORS for cross-origin uploads
- Set bucket policy for public read access
- Enable server-side encryption (AES256)
- Configure lifecycle rules for cleanup

### 4. Verify Configuration

```bash
node src/utils/s3Setup.js info
```

## Bucket Configuration

### CORS Configuration

Allows uploads from web and mobile clients:

```json
{
  "AllowedOrigins": ["*"],
  "AllowedMethods": ["GET", "POST", "PUT", "DELETE", "HEAD"],
  "AllowedHeaders": ["*"],
  "ExposeHeaders": ["ETag", "x-amz-server-side-encryption"],
  "MaxAgeSeconds": 3600
}
```

**Production Note:** Replace `"*"` with specific domains for security.

### Bucket Policy

Allows public read access to uploaded files:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::visaduma-uploads/*"
    }
  ]
}
```

### Encryption

Server-side encryption with AES256 is enabled by default for all uploads.

### Lifecycle Rules

Incomplete multipart uploads are automatically deleted after 7 days.

## Usage Examples

### Upload Avatar

```bash
curl -X POST http://localhost:3000/api/v1/upload/avatar \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "avatar=@/path/to/image.jpg"
```

Response:
```json
{
  "success": true,
  "message": "Avatar uploaded successfully",
  "data": {
    "url": "https://visaduma-uploads.s3.ap-south-1.amazonaws.com/avatars/uuid.jpg",
    "key": "avatars/uuid.jpg"
  }
}
```

### Upload Product Images

```bash
curl -X POST http://localhost:3000/api/v1/upload/product-images \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "images=@/path/to/image1.jpg" \
  -F "images=@/path/to/image2.jpg"
```

### Upload Shop Logo and Banner

```bash
curl -X POST http://localhost:3000/api/v1/upload/shop-images \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "logo=@/path/to/logo.png" \
  -F "banner=@/path/to/banner.jpg"
```

### Delete File

```bash
curl -X DELETE http://localhost:3000/api/v1/upload/avatars/uuid.jpg \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Get Signed URL (for private files)

```bash
curl -X GET "http://localhost:3000/api/v1/upload/signed-url/documents/uuid.pdf?expires=3600" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## File Organization

Files are organized in S3 with the following folder structure:

```
visaduma-uploads/
├── avatars/              # User profile pictures
├── products/             # Product images
├── shops/
│   ├── logos/           # Shop logos
│   └── banners/         # Shop banners
├── vehicles/            # Vehicle photos
├── certifications/      # Service provider certifications
├── reviews/             # Review images
├── chat/
│   └── attachments/     # Chat attachments
└── documents/           # General documents
```

## Security Considerations

### 1. File Validation
- File type validation (MIME type checking)
- File size limits enforced
- Malicious file detection (basic)

### 2. Access Control
- JWT authentication required for uploads
- Public read access for uploaded files
- Signed URLs for private file access

### 3. Encryption
- Server-side encryption (AES256) at rest
- HTTPS/TLS encryption in transit
- Secure credential management via environment variables

### 4. Best Practices
- Never commit AWS credentials to version control
- Use IAM roles with minimal required permissions
- Implement rate limiting on upload endpoints
- Scan uploaded files for malware (recommended)
- Use CloudFront CDN for better performance and DDoS protection

## Error Handling

The middleware includes comprehensive error handling:

```javascript
// Multer errors
- LIMIT_FILE_SIZE: File too large
- LIMIT_FILE_COUNT: Too many files
- LIMIT_UNEXPECTED_FILE: Unexpected field

// Custom errors
- Invalid file type
- S3 upload failure
- Authentication failure
```

## Integration with Server

Add upload routes to your Express app:

```javascript
// src/server.js
const uploadRoutes = require('./routes/upload');

app.use('/api/v1/upload', uploadRoutes);
```

## Testing

### Test S3 Connection

```bash
node src/utils/s3Setup.js info
```

### Test File Upload

Use Postman or curl to test upload endpoints with a valid JWT token.

## Monitoring and Maintenance

### CloudWatch Metrics
- Monitor S3 bucket size
- Track request counts
- Monitor error rates

### Cost Optimization
- Use lifecycle policies to archive old files
- Implement CloudFront CDN to reduce S3 requests
- Compress images before upload
- Use S3 Intelligent-Tiering for cost savings

## Troubleshooting

### Issue: "Access Denied" errors

**Solution:**
1. Verify AWS credentials in `.env`
2. Check IAM user permissions
3. Ensure bucket policy is correctly configured

### Issue: CORS errors in browser

**Solution:**
1. Run `node src/utils/s3Setup.js cors`
2. Verify CORS configuration allows your domain
3. Check browser console for specific CORS errors

### Issue: Files not uploading

**Solution:**
1. Check file size limits
2. Verify MIME type is allowed
3. Check S3 bucket exists and is accessible
4. Review server logs for detailed errors

## Requirements Satisfied

This implementation satisfies the following requirements:

### Requirement 81.8: Technology Stack Constraints
✅ Uses AWS for cloud infrastructure
✅ Uses AWS S3 for file storage

### Additional Features
✅ Multer middleware for multipart form data
✅ File validation (type and size)
✅ Multiple upload strategies (single, multiple, fields)
✅ Secure file storage with encryption
✅ Public and private file access
✅ CORS configuration for cross-origin uploads
✅ Comprehensive error handling
✅ RESTful API endpoints
✅ CLI tools for bucket management

## Next Steps

1. **Integrate with modules:**
   - User profile (avatars)
   - Shops (product images, logos)
   - Services (certifications)
   - Chat (attachments)
   - Reviews (images)

2. **Add CloudFront CDN:**
   - Improve performance
   - Reduce S3 costs
   - Enable edge caching

3. **Implement image processing:**
   - Resize images on upload
   - Generate thumbnails
   - Optimize for web delivery

4. **Add virus scanning:**
   - Integrate ClamAV or similar
   - Scan files before storing

5. **Implement analytics:**
   - Track upload metrics
   - Monitor storage usage
   - Analyze file types and sizes

## References

- [AWS S3 Documentation](https://docs.aws.amazon.com/s3/)
- [Multer Documentation](https://github.com/expressjs/multer)
- [AWS SDK for JavaScript](https://docs.aws.amazon.com/sdk-for-javascript/)

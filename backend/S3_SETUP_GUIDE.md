# AWS S3 Setup Guide for VisaDuma

Quick guide to set up AWS S3 for file uploads in the VisaDuma backend.

## Prerequisites

- AWS Account
- AWS CLI installed (optional but recommended)
- Node.js and npm installed

## Step 1: Create AWS IAM User

1. Log in to AWS Console
2. Navigate to IAM → Users → Add User
3. User name: `visaduma-s3-user`
4. Access type: Programmatic access
5. Attach policy: Create custom policy with the following JSON:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:CreateBucket",
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetBucketCors",
        "s3:PutBucketCors",
        "s3:GetBucketPolicy",
        "s3:PutBucketPolicy",
        "s3:GetBucketEncryption",
        "s3:PutBucketEncryption",
        "s3:PutLifecycleConfiguration",
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:HeadObject"
      ],
      "Resource": [
        "arn:aws:s3:::visaduma-uploads",
        "arn:aws:s3:::visaduma-uploads/*"
      ]
    }
  ]
}
```

6. Save the Access Key ID and Secret Access Key

## Step 2: Configure Environment Variables

1. Navigate to the backend directory:
```bash
cd backend
```

2. Copy the example environment file:
```bash
cp .env.example .env
```

3. Edit `.env` and add your AWS credentials:
```env
# AWS Configuration
AWS_REGION=ap-south-1
AWS_ACCESS_KEY_ID=your_access_key_here
AWS_SECRET_ACCESS_KEY=your_secret_key_here
AWS_S3_BUCKET=visaduma-uploads
```

**Important:** Never commit `.env` to version control!

## Step 3: Install Dependencies

```bash
npm install
```

This will install:
- `aws-sdk` - AWS SDK for JavaScript
- `multer` - Middleware for handling multipart/form-data
- `uuid` - For generating unique filenames

## Step 4: Run S3 Setup

Run the automated setup script:

```bash
npm run s3:setup
```

This will:
- ✅ Create the S3 bucket (if it doesn't exist)
- ✅ Configure CORS for cross-origin uploads
- ✅ Set bucket policy for public read access
- ✅ Enable server-side encryption (AES256)
- ✅ Configure lifecycle rules for cleanup

## Step 5: Verify Configuration

Test the S3 connection:

```bash
npm run test:s3
```

Expected output:
```
✅ All S3 connection tests passed!

Bucket: visaduma-uploads
Region: ap-south-1

You can now use S3 for file uploads in the VisaDuma app.
```

View bucket information:

```bash
npm run s3:info
```

## Step 6: Start the Server

```bash
npm run dev
```

The server will start with S3 upload routes available at:
- `POST /api/v1/upload/avatar`
- `POST /api/v1/upload/image`
- `POST /api/v1/upload/images`
- `POST /api/v1/upload/product-images`
- `POST /api/v1/upload/shop-images`
- `POST /api/v1/upload/document`
- `POST /api/v1/upload/attachment`
- `DELETE /api/v1/upload/:key`
- `GET /api/v1/upload/signed-url/:key`

## Testing Upload Endpoints

### Using curl

1. First, get a JWT token by logging in:
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}'
```

2. Upload an avatar:
```bash
curl -X POST http://localhost:3000/api/v1/upload/avatar \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "avatar=@/path/to/image.jpg"
```

### Using Postman

1. Create a new POST request to `http://localhost:3000/api/v1/upload/avatar`
2. Add Authorization header: `Bearer YOUR_JWT_TOKEN`
3. In Body tab, select `form-data`
4. Add key `avatar` with type `File`
5. Select an image file
6. Send the request

Expected response:
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

## Troubleshooting

### Issue: "AWS credentials not configured"

**Solution:**
- Check that `.env` file exists in the backend directory
- Verify AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are set
- Ensure there are no extra spaces or quotes around the values

### Issue: "Bucket does not exist"

**Solution:**
```bash
npm run s3:setup
```

### Issue: "Access Denied"

**Solution:**
- Verify IAM user has the correct permissions
- Check that the bucket name in `.env` matches the IAM policy
- Ensure AWS credentials are correct

### Issue: "CORS errors in browser"

**Solution:**
```bash
node src/utils/s3Setup.js cors
```

### Issue: "File too large"

**Solution:**
- Check file size limits in `src/middleware/upload.js`
- Avatar: 5MB max
- Images: 10MB max
- Documents: 20MB max
- Attachments: 25MB max

## File Organization

Uploaded files are organized in folders:

```
visaduma-uploads/
├── avatars/              # User avatars (5MB max)
├── products/             # Product images (10MB max)
├── shops/
│   ├── logos/           # Shop logos (10MB max)
│   └── banners/         # Shop banners (10MB max)
├── vehicles/            # Vehicle photos (10MB max)
├── certifications/      # Provider certifications (20MB max)
├── reviews/             # Review images (10MB max)
├── chat/
│   └── attachments/     # Chat attachments (25MB max)
└── documents/           # General documents (20MB max)
```

## Security Best Practices

1. **Never commit AWS credentials** to version control
2. **Use IAM roles** with minimal required permissions
3. **Enable CloudTrail** to audit S3 access
4. **Implement rate limiting** on upload endpoints (already configured)
5. **Scan uploaded files** for malware (recommended for production)
6. **Use CloudFront CDN** for better performance and security
7. **Rotate AWS credentials** regularly
8. **Monitor S3 costs** and set up billing alerts

## Production Considerations

### 1. Update CORS Configuration

Edit `src/utils/s3Setup.js` and replace `"*"` with your actual domains:

```javascript
AllowedOrigins: [
  'https://visaduma.com',
  'https://www.visaduma.com',
  'https://app.visaduma.com'
]
```

### 2. Set up CloudFront CDN

1. Create CloudFront distribution
2. Set S3 bucket as origin
3. Update application to use CloudFront URLs
4. Enable caching for better performance

### 3. Enable CloudWatch Monitoring

- Monitor bucket size and request counts
- Set up alarms for unusual activity
- Track upload success/failure rates

### 4. Implement Image Processing

Consider adding:
- Image resizing on upload
- Thumbnail generation
- Format conversion (WebP)
- Compression

### 5. Add Virus Scanning

Integrate with:
- AWS Lambda + ClamAV
- Third-party scanning service
- Scan files before making them public

## Cost Estimation

Approximate AWS S3 costs (ap-south-1 region):

- **Storage:** $0.023 per GB/month
- **PUT requests:** $0.005 per 1,000 requests
- **GET requests:** $0.0004 per 1,000 requests
- **Data transfer out:** $0.109 per GB (first 10 TB)

Example for 10,000 users:
- 10,000 avatars × 500KB = 5GB storage = $0.12/month
- 10,000 uploads = $0.05
- 100,000 views = $0.04
- **Total: ~$0.21/month**

Use CloudFront CDN to reduce costs significantly.

## Next Steps

1. ✅ S3 configured and tested
2. Integrate upload functionality into user profile module
3. Add image upload to shops/products modules
4. Implement chat attachments
5. Add document upload for service providers
6. Set up CloudFront CDN for production
7. Implement image processing pipeline
8. Add virus scanning for security

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review `S3_CONFIGURATION.md` for detailed documentation
3. Check AWS S3 documentation: https://docs.aws.amazon.com/s3/
4. Review Multer documentation: https://github.com/expressjs/multer

## Summary

You now have a fully configured AWS S3 file upload system with:
- ✅ Secure file storage
- ✅ Multiple upload endpoints
- ✅ File validation and size limits
- ✅ CORS configuration
- ✅ Public read access
- ✅ Server-side encryption
- ✅ Comprehensive error handling
- ✅ RESTful API
- ✅ CLI management tools

Ready to integrate with your VisaDuma modules! 🚀

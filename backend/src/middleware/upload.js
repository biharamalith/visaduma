const multer = require('multer');
const path = require('path');

/**
 * Multer middleware for handling multipart form data file uploads
 * Stores files in memory for direct S3 upload
 */

// File size limits (in bytes)
const FILE_SIZE_LIMITS = {
  avatar: 5 * 1024 * 1024, // 5MB for avatars
  image: 10 * 1024 * 1024, // 10MB for general images
  document: 20 * 1024 * 1024, // 20MB for documents/certifications
  attachment: 25 * 1024 * 1024 // 25MB for chat attachments
};

// Allowed MIME types
const ALLOWED_MIME_TYPES = {
  image: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'],
  document: [
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  ],
  all: [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/gif',
    'image/webp',
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  ]
};

// Configure multer storage (memory storage for S3 upload)
const storage = multer.memoryStorage();

/**
 * File filter function
 * @param {string} allowedTypes - 'image', 'document', or 'all'
 */
const createFileFilter = (allowedTypes = 'all') => {
  return (req, file, cb) => {
    const allowedMimeTypes = ALLOWED_MIME_TYPES[allowedTypes] || ALLOWED_MIME_TYPES.all;

    if (allowedMimeTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(
        new Error(
          `Invalid file type. Allowed types: ${allowedMimeTypes.join(', ')}`
        ),
        false
      );
    }
  };
};

/**
 * Create multer upload middleware with custom configuration
 * @param {Object} options - Configuration options
 * @param {string} options.fileType - 'avatar', 'image', 'document', or 'attachment'
 * @param {string} options.allowedTypes - 'image', 'document', or 'all'
 * @param {number} options.maxFiles - Maximum number of files (for array uploads)
 */
const createUploadMiddleware = (options = {}) => {
  const {
    fileType = 'image',
    allowedTypes = 'all',
    maxFiles = 1
  } = options;

  const maxSize = FILE_SIZE_LIMITS[fileType] || FILE_SIZE_LIMITS.image;

  return multer({
    storage: storage,
    limits: {
      fileSize: maxSize,
      files: maxFiles
    },
    fileFilter: createFileFilter(allowedTypes)
  });
};

// Pre-configured middleware for common use cases

/**
 * Single avatar upload (5MB limit, images only)
 */
const uploadAvatar = createUploadMiddleware({
  fileType: 'avatar',
  allowedTypes: 'image',
  maxFiles: 1
}).single('avatar');

/**
 * Single image upload (10MB limit, images only)
 */
const uploadImage = createUploadMiddleware({
  fileType: 'image',
  allowedTypes: 'image',
  maxFiles: 1
}).single('image');

/**
 * Multiple images upload (10MB per file, up to 10 images)
 */
const uploadImages = createUploadMiddleware({
  fileType: 'image',
  allowedTypes: 'image',
  maxFiles: 10
}).array('images', 10);

/**
 * Product images upload (10MB per file, up to 5 images)
 */
const uploadProductImages = createUploadMiddleware({
  fileType: 'image',
  allowedTypes: 'image',
  maxFiles: 5
}).array('images', 5);

/**
 * Document upload (20MB limit, documents only)
 */
const uploadDocument = createUploadMiddleware({
  fileType: 'document',
  allowedTypes: 'document',
  maxFiles: 1
}).single('document');

/**
 * Multiple documents upload (20MB per file, up to 5 documents)
 */
const uploadDocuments = createUploadMiddleware({
  fileType: 'document',
  allowedTypes: 'document',
  maxFiles: 5
}).array('documents', 5);

/**
 * Chat attachment upload (25MB limit, all types)
 */
const uploadAttachment = createUploadMiddleware({
  fileType: 'attachment',
  allowedTypes: 'all',
  maxFiles: 1
}).single('attachment');

/**
 * Multiple chat attachments (25MB per file, up to 3 files)
 */
const uploadAttachments = createUploadMiddleware({
  fileType: 'attachment',
  allowedTypes: 'all',
  maxFiles: 3
}).array('attachments', 3);

/**
 * Shop logo and banner upload (fields: logo, banner)
 */
const uploadShopImages = createUploadMiddleware({
  fileType: 'image',
  allowedTypes: 'image',
  maxFiles: 2
}).fields([
  { name: 'logo', maxCount: 1 },
  { name: 'banner', maxCount: 1 }
]);

/**
 * Error handler middleware for multer errors
 */
const handleUploadError = (err, req, res, next) => {
  if (err instanceof multer.MulterError) {
    // Multer-specific errors
    if (err.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({
        success: false,
        error: 'File too large',
        message: `File size exceeds the maximum allowed limit`
      });
    }
    if (err.code === 'LIMIT_FILE_COUNT') {
      return res.status(400).json({
        success: false,
        error: 'Too many files',
        message: 'Number of files exceeds the maximum allowed'
      });
    }
    if (err.code === 'LIMIT_UNEXPECTED_FILE') {
      return res.status(400).json({
        success: false,
        error: 'Unexpected field',
        message: 'Unexpected file field in the request'
      });
    }
    return res.status(400).json({
      success: false,
      error: 'Upload error',
      message: err.message
    });
  }

  if (err) {
    // Other errors (e.g., file type validation)
    return res.status(400).json({
      success: false,
      error: 'Upload error',
      message: err.message
    });
  }

  next();
};

module.exports = {
  // Factory function
  createUploadMiddleware,

  // Pre-configured middleware
  uploadAvatar,
  uploadImage,
  uploadImages,
  uploadProductImages,
  uploadDocument,
  uploadDocuments,
  uploadAttachment,
  uploadAttachments,
  uploadShopImages,

  // Error handler
  handleUploadError,

  // Constants
  FILE_SIZE_LIMITS,
  ALLOWED_MIME_TYPES
};

const express = require('express');
const router = express.Router();
const s3Service = require('../services/s3Service');
const {
  uploadAvatar,
  uploadImage,
  uploadImages,
  uploadProductImages,
  uploadDocument,
  uploadAttachment,
  uploadShopImages,
  handleUploadError
} = require('../middleware/upload');
const { requireAuth } = require('../middleware/auth');

/**
 * Upload Routes
 * Demonstrates S3 file upload functionality for various use cases
 */

/**
 * @route   POST /api/v1/upload/avatar
 * @desc    Upload user avatar
 * @access  Private
 */
router.post('/avatar', requireAuth, uploadAvatar, async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'No file uploaded'
      });
    }

    // Upload to S3
    const result = await s3Service.uploadFile(
      req.file.buffer,
      req.file.originalname,
      req.file.mimetype,
      'avatars'
    );

    res.status(200).json({
      success: true,
      message: 'Avatar uploaded successfully',
      data: {
        url: result.url,
        key: result.key
      }
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route   POST /api/v1/upload/image
 * @desc    Upload single image
 * @access  Private
 */
router.post('/image', requireAuth, uploadImage, async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'No file uploaded'
      });
    }

    const folder = req.body.folder || 'images';

    const result = await s3Service.uploadFile(
      req.file.buffer,
      req.file.originalname,
      req.file.mimetype,
      folder
    );

    res.status(200).json({
      success: true,
      message: 'Image uploaded successfully',
      data: {
        url: result.url,
        key: result.key
      }
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route   POST /api/v1/upload/images
 * @desc    Upload multiple images
 * @access  Private
 */
router.post('/images', requireAuth, uploadImages, async (req, res, next) => {
  try {
    if (!req.files || req.files.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'No files uploaded'
      });
    }

    const folder = req.body.folder || 'images';

    const results = await s3Service.uploadMultipleFiles(req.files, folder);

    res.status(200).json({
      success: true,
      message: `${results.length} images uploaded successfully`,
      data: results.map(r => ({
        url: r.url,
        key: r.key
      }))
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route   POST /api/v1/upload/product-images
 * @desc    Upload product images (for e-commerce)
 * @access  Private (shop owners)
 */
router.post('/product-images', requireAuth, uploadProductImages, async (req, res, next) => {
  try {
    if (!req.files || req.files.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'No files uploaded'
      });
    }

    const results = await s3Service.uploadMultipleFiles(req.files, 'products');

    res.status(200).json({
      success: true,
      message: `${results.length} product images uploaded successfully`,
      data: results.map(r => ({
        url: r.url,
        key: r.key
      }))
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route   POST /api/v1/upload/shop-images
 * @desc    Upload shop logo and banner
 * @access  Private (shop owners)
 */
router.post('/shop-images', requireAuth, uploadShopImages, async (req, res, next) => {
  try {
    if (!req.files || (!req.files.logo && !req.files.banner)) {
      return res.status(400).json({
        success: false,
        error: 'No files uploaded'
      });
    }

    const results = {};

    // Upload logo if provided
    if (req.files.logo && req.files.logo[0]) {
      const logoResult = await s3Service.uploadFile(
        req.files.logo[0].buffer,
        req.files.logo[0].originalname,
        req.files.logo[0].mimetype,
        'shops/logos'
      );
      results.logo = {
        url: logoResult.url,
        key: logoResult.key
      };
    }

    // Upload banner if provided
    if (req.files.banner && req.files.banner[0]) {
      const bannerResult = await s3Service.uploadFile(
        req.files.banner[0].buffer,
        req.files.banner[0].originalname,
        req.files.banner[0].mimetype,
        'shops/banners'
      );
      results.banner = {
        url: bannerResult.url,
        key: bannerResult.key
      };
    }

    res.status(200).json({
      success: true,
      message: 'Shop images uploaded successfully',
      data: results
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route   POST /api/v1/upload/document
 * @desc    Upload document (certifications, licenses, etc.)
 * @access  Private
 */
router.post('/document', requireAuth, uploadDocument, async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'No file uploaded'
      });
    }

    const folder = req.body.folder || 'documents';

    const result = await s3Service.uploadFile(
      req.file.buffer,
      req.file.originalname,
      req.file.mimetype,
      folder
    );

    res.status(200).json({
      success: true,
      message: 'Document uploaded successfully',
      data: {
        url: result.url,
        key: result.key
      }
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route   POST /api/v1/upload/attachment
 * @desc    Upload chat attachment
 * @access  Private
 */
router.post('/attachment', requireAuth, uploadAttachment, async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'No file uploaded'
      });
    }

    const result = await s3Service.uploadFile(
      req.file.buffer,
      req.file.originalname,
      req.file.mimetype,
      'chat/attachments'
    );

    res.status(200).json({
      success: true,
      message: 'Attachment uploaded successfully',
      data: {
        url: result.url,
        key: result.key,
        filename: req.file.originalname,
        size: req.file.size,
        mimetype: req.file.mimetype
      }
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route   DELETE /api/v1/upload/:key
 * @desc    Delete a file from S3
 * @access  Private
 */
router.delete('/:key(*)', requireAuth, async (req, res, next) => {
  try {
    const key = req.params.key;

    if (!key) {
      return res.status(400).json({
        success: false,
        error: 'File key is required'
      });
    }

    await s3Service.deleteFile(key);

    res.status(200).json({
      success: true,
      message: 'File deleted successfully'
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route   GET /api/v1/upload/signed-url/:key
 * @desc    Get signed URL for private file access
 * @access  Private
 */
router.get('/signed-url/:key(*)', requireAuth, async (req, res, next) => {
  try {
    const key = req.params.key;
    const expiresIn = parseInt(req.query.expires) || 3600; // Default 1 hour

    if (!key) {
      return res.status(400).json({
        success: false,
        error: 'File key is required'
      });
    }

    const url = await s3Service.getSignedUrl(key, expiresIn);

    res.status(200).json({
      success: true,
      data: {
        url,
        expiresIn
      }
    });
  } catch (error) {
    next(error);
  }
});

// Apply error handler
router.use(handleUploadError);

module.exports = router;

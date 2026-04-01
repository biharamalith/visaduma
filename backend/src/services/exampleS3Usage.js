const s3Service = require('./s3Service');

/**
 * Example usage of S3 Service
 * Demonstrates how to integrate S3 uploads in various modules
 */

// Example 1: User Profile - Upload Avatar
async function updateUserAvatar(userId, fileBuffer, originalName, mimeType) {
  try {
    // Upload to S3
    const result = await s3Service.uploadFile(
      fileBuffer,
      originalName,
      mimeType,
      'avatars'
    );

    // Update user record in database
    // await db.query('UPDATE users SET avatar_url = ? WHERE id = ?', [result.url, userId]);

    return {
      success: true,
      avatarUrl: result.url,
      key: result.key
    };
  } catch (error) {
    console.error('Failed to update avatar:', error);
    throw error;
  }
}

// Example 2: E-commerce - Upload Product Images
async function uploadProductImages(productId, files) {
  try {
    // Upload multiple images
    const results = await s3Service.uploadMultipleFiles(files, 'products');

    // Extract URLs
    const imageUrls = results.map(r => r.url);

    // Update product record with image URLs
    // await db.query('UPDATE products SET images = ? WHERE id = ?', [JSON.stringify(imageUrls), productId]);

    return {
      success: true,
      images: imageUrls,
      count: imageUrls.length
    };
  } catch (error) {
    console.error('Failed to upload product images:', error);
    throw error;
  }
}

// Example 3: Shop - Upload Logo and Banner
async function uploadShopImages(shopId, logoFile, bannerFile) {
  try {
    const results = {};

    // Upload logo
    if (logoFile) {
      const logoResult = await s3Service.uploadFile(
        logoFile.buffer,
        logoFile.originalname,
        logoFile.mimetype,
        'shops/logos'
      );
      results.logoUrl = logoResult.url;
      results.logoKey = logoResult.key;
    }

    // Upload banner
    if (bannerFile) {
      const bannerResult = await s3Service.uploadFile(
        bannerFile.buffer,
        bannerFile.originalname,
        bannerFile.mimetype,
        'shops/banners'
      );
      results.bannerUrl = bannerResult.url;
      results.bannerKey = bannerResult.key;
    }

    // Update shop record
    // await db.query('UPDATE shops SET logo_url = ?, banner_url = ? WHERE id = ?', 
    //   [results.logoUrl, results.bannerUrl, shopId]);

    return {
      success: true,
      ...results
    };
  } catch (error) {
    console.error('Failed to upload shop images:', error);
    throw error;
  }
}

// Example 4: Service Provider - Upload Certification
async function uploadProviderCertification(providerId, fileBuffer, originalName, mimeType) {
  try {
    // Upload document
    const result = await s3Service.uploadFile(
      fileBuffer,
      originalName,
      mimeType,
      'certifications'
    );

    // Store certification record
    // await db.query('INSERT INTO provider_certifications (provider_id, document_url, document_key) VALUES (?, ?, ?)',
    //   [providerId, result.url, result.key]);

    return {
      success: true,
      documentUrl: result.url,
      key: result.key
    };
  } catch (error) {
    console.error('Failed to upload certification:', error);
    throw error;
  }
}

// Example 5: Chat - Upload Attachment
async function uploadChatAttachment(chatId, fileBuffer, originalName, mimeType, fileSize) {
  try {
    // Upload attachment
    const result = await s3Service.uploadFile(
      fileBuffer,
      originalName,
      mimeType,
      'chat/attachments'
    );

    // Store message with attachment
    // await db.query('INSERT INTO chat_messages (chat_id, attachment_url, attachment_key, filename, file_size) VALUES (?, ?, ?, ?, ?)',
    //   [chatId, result.url, result.key, originalName, fileSize]);

    return {
      success: true,
      attachmentUrl: result.url,
      key: result.key,
      filename: originalName,
      size: fileSize
    };
  } catch (error) {
    console.error('Failed to upload chat attachment:', error);
    throw error;
  }
}

// Example 6: Reviews - Upload Review Images
async function uploadReviewImages(reviewId, files) {
  try {
    // Upload multiple review images
    const results = await s3Service.uploadMultipleFiles(files, 'reviews');

    // Extract URLs
    const imageUrls = results.map(r => r.url);

    // Update review record
    // await db.query('UPDATE reviews SET images = ? WHERE id = ?', [JSON.stringify(imageUrls), reviewId]);

    return {
      success: true,
      images: imageUrls,
      count: imageUrls.length
    };
  } catch (error) {
    console.error('Failed to upload review images:', error);
    throw error;
  }
}

// Example 7: Delete Old Avatar When Updating
async function replaceUserAvatar(userId, oldAvatarKey, newFileBuffer, originalName, mimeType) {
  try {
    // Upload new avatar
    const uploadResult = await s3Service.uploadFile(
      newFileBuffer,
      originalName,
      mimeType,
      'avatars'
    );

    // Delete old avatar if exists
    if (oldAvatarKey) {
      await s3Service.deleteFile(oldAvatarKey);
    }

    // Update user record
    // await db.query('UPDATE users SET avatar_url = ? WHERE id = ?', [uploadResult.url, userId]);

    return {
      success: true,
      avatarUrl: uploadResult.url,
      key: uploadResult.key
    };
  } catch (error) {
    console.error('Failed to replace avatar:', error);
    throw error;
  }
}

// Example 8: Delete Product with Images
async function deleteProductWithImages(productId, imageKeys) {
  try {
    // Delete all product images from S3
    if (imageKeys && imageKeys.length > 0) {
      await s3Service.deleteMultipleFiles(imageKeys);
    }

    // Delete product record
    // await db.query('DELETE FROM products WHERE id = ?', [productId]);

    return {
      success: true,
      message: 'Product and images deleted successfully'
    };
  } catch (error) {
    console.error('Failed to delete product:', error);
    throw error;
  }
}

// Example 9: Generate Signed URL for Private Document
async function getPrivateDocumentUrl(documentKey, expiresIn = 3600) {
  try {
    // Generate signed URL (valid for 1 hour by default)
    const signedUrl = await s3Service.getSignedUrl(documentKey, expiresIn);

    return {
      success: true,
      url: signedUrl,
      expiresIn
    };
  } catch (error) {
    console.error('Failed to generate signed URL:', error);
    throw error;
  }
}

// Example 10: Check if File Exists Before Processing
async function processFileIfExists(fileKey) {
  try {
    // Check if file exists
    const exists = await s3Service.fileExists(fileKey);

    if (!exists) {
      return {
        success: false,
        error: 'File not found'
      };
    }

    // Get file metadata
    const metadata = await s3Service.getFileMetadata(fileKey);

    // Process file...
    return {
      success: true,
      metadata
    };
  } catch (error) {
    console.error('Failed to process file:', error);
    throw error;
  }
}

module.exports = {
  updateUserAvatar,
  uploadProductImages,
  uploadShopImages,
  uploadProviderCertification,
  uploadChatAttachment,
  uploadReviewImages,
  replaceUserAvatar,
  deleteProductWithImages,
  getPrivateDocumentUrl,
  processFileIfExists
};

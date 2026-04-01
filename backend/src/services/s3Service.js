const { s3, BUCKET_NAME } = require('../config/s3');
const { v4: uuidv4 } = require('uuid');
const path = require('path');

/**
 * S3 Service for file upload, download, and management
 * Supports: user avatars, product images, shop logos, vehicle photos,
 * service provider certifications, review images, chat attachments
 */

class S3Service {
  /**
   * Upload a file to S3
   * @param {Buffer} fileBuffer - File buffer
   * @param {string} originalName - Original filename
   * @param {string} mimeType - File MIME type
   * @param {string} folder - S3 folder (e.g., 'avatars', 'products', 'shops')
   * @returns {Promise<{url: string, key: string}>}
   */
  async uploadFile(fileBuffer, originalName, mimeType, folder = 'uploads') {
    try {
      // Generate unique filename
      const fileExtension = path.extname(originalName);
      const fileName = `${uuidv4()}${fileExtension}`;
      const key = `${folder}/${fileName}`;

      // Upload parameters
      const params = {
        Bucket: BUCKET_NAME,
        Key: key,
        Body: fileBuffer,
        ContentType: mimeType,
        ACL: 'public-read', // Make files publicly accessible
        ServerSideEncryption: 'AES256' // Encrypt at rest
      };

      // Upload to S3
      const result = await s3.upload(params).promise();

      return {
        url: result.Location,
        key: result.Key,
        bucket: result.Bucket,
        etag: result.ETag
      };
    } catch (error) {
      console.error('S3 upload error:', error);
      throw new Error(`Failed to upload file: ${error.message}`);
    }
  }

  /**
   * Upload multiple files to S3
   * @param {Array} files - Array of file objects with buffer, originalName, mimeType
   * @param {string} folder - S3 folder
   * @returns {Promise<Array>}
   */
  async uploadMultipleFiles(files, folder = 'uploads') {
    try {
      const uploadPromises = files.map(file =>
        this.uploadFile(file.buffer, file.originalname, file.mimetype, folder)
      );
      return await Promise.all(uploadPromises);
    } catch (error) {
      console.error('S3 multiple upload error:', error);
      throw new Error(`Failed to upload files: ${error.message}`);
    }
  }

  /**
   * Delete a file from S3
   * @param {string} key - S3 object key
   * @returns {Promise<void>}
   */
  async deleteFile(key) {
    try {
      const params = {
        Bucket: BUCKET_NAME,
        Key: key
      };

      await s3.deleteObject(params).promise();
      return { success: true, message: 'File deleted successfully' };
    } catch (error) {
      console.error('S3 delete error:', error);
      throw new Error(`Failed to delete file: ${error.message}`);
    }
  }

  /**
   * Delete multiple files from S3
   * @param {Array<string>} keys - Array of S3 object keys
   * @returns {Promise<void>}
   */
  async deleteMultipleFiles(keys) {
    try {
      if (!keys || keys.length === 0) {
        return { success: true, message: 'No files to delete' };
      }

      const params = {
        Bucket: BUCKET_NAME,
        Delete: {
          Objects: keys.map(key => ({ Key: key })),
          Quiet: false
        }
      };

      const result = await s3.deleteObjects(params).promise();
      return {
        success: true,
        deleted: result.Deleted,
        errors: result.Errors
      };
    } catch (error) {
      console.error('S3 multiple delete error:', error);
      throw new Error(`Failed to delete files: ${error.message}`);
    }
  }

  /**
   * Get a signed URL for private file access
   * @param {string} key - S3 object key
   * @param {number} expiresIn - URL expiration in seconds (default: 1 hour)
   * @returns {Promise<string>}
   */
  async getSignedUrl(key, expiresIn = 3600) {
    try {
      const params = {
        Bucket: BUCKET_NAME,
        Key: key,
        Expires: expiresIn
      };

      const url = await s3.getSignedUrlPromise('getObject', params);
      return url;
    } catch (error) {
      console.error('S3 signed URL error:', error);
      throw new Error(`Failed to generate signed URL: ${error.message}`);
    }
  }

  /**
   * Check if a file exists in S3
   * @param {string} key - S3 object key
   * @returns {Promise<boolean>}
   */
  async fileExists(key) {
    try {
      const params = {
        Bucket: BUCKET_NAME,
        Key: key
      };

      await s3.headObject(params).promise();
      return true;
    } catch (error) {
      if (error.code === 'NotFound') {
        return false;
      }
      throw error;
    }
  }

  /**
   * Get file metadata
   * @param {string} key - S3 object key
   * @returns {Promise<Object>}
   */
  async getFileMetadata(key) {
    try {
      const params = {
        Bucket: BUCKET_NAME,
        Key: key
      };

      const metadata = await s3.headObject(params).promise();
      return {
        contentType: metadata.ContentType,
        contentLength: metadata.ContentLength,
        lastModified: metadata.LastModified,
        etag: metadata.ETag
      };
    } catch (error) {
      console.error('S3 metadata error:', error);
      throw new Error(`Failed to get file metadata: ${error.message}`);
    }
  }

  /**
   * Copy a file within S3
   * @param {string} sourceKey - Source S3 object key
   * @param {string} destinationKey - Destination S3 object key
   * @returns {Promise<Object>}
   */
  async copyFile(sourceKey, destinationKey) {
    try {
      const params = {
        Bucket: BUCKET_NAME,
        CopySource: `${BUCKET_NAME}/${sourceKey}`,
        Key: destinationKey
      };

      const result = await s3.copyObject(params).promise();
      return {
        success: true,
        etag: result.CopyObjectResult.ETag
      };
    } catch (error) {
      console.error('S3 copy error:', error);
      throw new Error(`Failed to copy file: ${error.message}`);
    }
  }

  /**
   * List files in a folder
   * @param {string} folder - S3 folder prefix
   * @param {number} maxKeys - Maximum number of keys to return
   * @returns {Promise<Array>}
   */
  async listFiles(folder, maxKeys = 1000) {
    try {
      const params = {
        Bucket: BUCKET_NAME,
        Prefix: folder,
        MaxKeys: maxKeys
      };

      const result = await s3.listObjectsV2(params).promise();
      return result.Contents.map(item => ({
        key: item.Key,
        size: item.Size,
        lastModified: item.LastModified,
        etag: item.ETag
      }));
    } catch (error) {
      console.error('S3 list error:', error);
      throw new Error(`Failed to list files: ${error.message}`);
    }
  }
}

// Export singleton instance
module.exports = new S3Service();

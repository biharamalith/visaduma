/**
 * ServiceCategory Model
 * 
 * Represents a service category in the service provider booking system.
 * Categories include services like Carpenter, Electrician, Plumber, etc.
 */

class ServiceCategory {
  constructor(data) {
    this.id = data.id;
    this.name = data.name;
    this.name_si = data.name_si || null;
    this.name_ta = data.name_ta || null;
    this.description = data.description || null;
    this.icon_name = data.icon_name;
    this.color_hex = data.color_hex;
    this.display_order = data.display_order || 0;
    this.is_active = data.is_active !== undefined ? data.is_active : true;
    this.created_at = data.created_at;
  }

  /**
   * Convert model to plain object for API responses
   */
  toJSON() {
    return {
      id: this.id,
      name: this.name,
      name_si: this.name_si,
      name_ta: this.name_ta,
      description: this.description,
      icon_name: this.icon_name,
      color_hex: this.color_hex,
      display_order: this.display_order,
      is_active: this.is_active,
      created_at: this.created_at,
    };
  }

  /**
   * Get localized name based on language code
   * @param {string} lang - Language code ('en', 'si', 'ta')
   * @returns {string} Localized name or default English name
   */
  getLocalizedName(lang = 'en') {
    switch (lang) {
      case 'si':
        return this.name_si || this.name;
      case 'ta':
        return this.name_ta || this.name;
      default:
        return this.name;
    }
  }

  /**
   * Validate category data
   * @param {Object} data - Category data to validate
   * @returns {Object} Validation result with isValid and errors
   */
  static validate(data) {
    const errors = [];

    if (!data.name || data.name.trim().length === 0) {
      errors.push('Name is required');
    }

    if (data.name && data.name.length > 100) {
      errors.push('Name must be 100 characters or less');
    }

    if (!data.icon_name || data.icon_name.trim().length === 0) {
      errors.push('Icon name is required');
    }

    if (data.icon_name && data.icon_name.length > 50) {
      errors.push('Icon name must be 50 characters or less');
    }

    if (!data.color_hex || data.color_hex.trim().length === 0) {
      errors.push('Color hex is required');
    }

    if (data.color_hex && !/^#[0-9A-Fa-f]{6}$/.test(data.color_hex)) {
      errors.push('Color hex must be in format #RRGGBB');
    }

    if (data.display_order !== undefined && typeof data.display_order !== 'number') {
      errors.push('Display order must be a number');
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }
}

module.exports = ServiceCategory;

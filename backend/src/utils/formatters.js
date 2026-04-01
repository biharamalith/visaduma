/**
 * Format database user row to API response format
 */
function formatUser(row) {
  return {
    id: row.id,
    fullName: row.full_name,
    email: row.email,
    phone: row.phone,
    role: row.role,
    avatarUrl: row.avatar_url,
    isVerified: row.is_verified,
    createdAt: row.created_at instanceof Date 
      ? row.created_at.toISOString() 
      : row.created_at,
  };
}

module.exports = {
  formatUser,
};

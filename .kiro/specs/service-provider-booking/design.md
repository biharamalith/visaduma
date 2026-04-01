# Service Provider Booking Feature - Design Document

## Overview

This document outlines the design for the Service Provider Booking feature in VisaDuma. The feature allows users to browse service categories, find service providers, view their profiles, and book services. The design is inspired by apps like Angi and FixMe but adapted for VisaDuma's super app context.

## User Flow

```
Home Screen
  ↓ (Tap "See More" on Popular Services)
Service Categories Screen (All categories)
  ↓ (Select a category, e.g., "Carpenter")
Service Providers List Screen (Filtered by category)
  ↓ (Tap a provider card)
Provider Profile Screen
  ↓ (Tap "Book Now")
Booking Form Screen
  ↓ (Submit booking)
Booking Confirmation Screen
```

## Screen Designs

### 1. Home Screen (Updated)

**Changes:**
- Keep existing "Popular Services" section with 6 categories
- Add "See More" button that navigates to full categories list
- Categories: Carpenter, Electrician, Plumber, Painter, AC Repair, Cleaning

**UI Elements:**
- 3-column grid of service category cards
- Each card: Icon, Label
- "See More" text button below grid

### 2. Service Categories Screen (New)

**Purpose:** Show all available service categories

**UI Elements:**
- App bar with title "Service Categories"
- Search bar for filtering categories
- Grid view (2 columns) of category cards
- Each card:
  - Large icon
  - Category name
  - Number of providers (e.g., "24 providers")
  - Subtle background color

**Categories List:**
1. Carpenter
2. Electrician
3. Plumber
4. Painter
5. AC Repair
6. Cleaning Services
7. Appliance Repair
8. Pest Control
9. Landscaping
10. Moving Services
11. Interior Design
12. Home Security

### 3. Service Providers List Screen (Updated)

**Purpose:** Show all providers for a selected category

**UI Elements:**
- App bar with category name
- Filter button (sort by: rating, price, distance)
- List of provider cards (vertical scroll)

**Provider Card Design:**
- Provider avatar (circular)
- Provider name
- Rating (stars + number, e.g., "4.8 ★")
- Experience (e.g., "5 years experience")
- Starting price (e.g., "From LKR 2,500/hr")
- Distance (e.g., "2.3 km away")
- Verified badge (if verified)
- Brief description (1 line)
- "View Profile" button

### 4. Provider Profile Screen (New)

**Purpose:** Detailed provider information and booking

**Sections:**

**A. Header**
- Large avatar
- Provider name
- Verified badge
- Rating with review count (e.g., "4.8 ★ (127 reviews)")
- Experience (e.g., "5 years in business")
- Response time (e.g., "Responds in ~30 min")

**B. Quick Actions**
- Three buttons in a row:
  - Call (phone icon)
  - Chat (message icon)
  - Book Now (primary button, full width below)

**C. About**
- Business description
- Service area (cities covered)
- Availability schedule

**D. Services & Pricing**
- List of services offered with prices
- Hourly rate or fixed rates

**E. Portfolio/Previous Work**
- Horizontal scrolling gallery of work images
- Tap to view full screen

**F. Certifications**
- List of certifications with icons
- Document verification status

**G. Reviews**
- Average rating breakdown (5★, 4★, 3★, etc.)
- Recent reviews with:
  - User name and avatar
  - Rating
  - Date
  - Review text
  - Photos (if any)
- "View All Reviews" button

**H. Location**
- Map showing service area
- Address

### 5. Booking Form Screen (New)

**Purpose:** Create a service booking

**Form Fields:**
- Service date (date picker)
- Service time (time picker)
- Duration (dropdown: 1hr, 2hr, 3hr, 4hr, 5hr+)
- Service address (text input + map picker)
- Contact phone (pre-filled, editable)
- Service description (text area)
- Special instructions (optional text area)
- Payment method (radio buttons: Cash, Wallet, Card)

**Bottom Section:**
- Estimated cost breakdown:
  - Base rate: LKR X
  - Duration: Y hours
  - Subtotal: LKR Z
  - Platform fee (5%): LKR A
  - Total: LKR B
- "Confirm Booking" button

### 6. Booking Confirmation Screen (New)

**Purpose:** Show booking success and details

**UI Elements:**
- Success icon (checkmark)
- "Booking Confirmed!" heading
- Booking number
- Provider info (avatar, name)
- Service details (date, time, address)
- Status: "Pending Provider Confirmation"
- "View Booking Details" button
- "Back to Home" button

## Database Schema

### service_categories Table
```sql
CREATE TABLE service_categories (
  id              VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
  name            VARCHAR(100) NOT NULL,
  name_si         VARCHAR(100) NULL, -- Sinhala
  name_ta         VARCHAR(100) NULL, -- Tamil
  description     TEXT NULL,
  icon_name       VARCHAR(50) NOT NULL, -- Material icon name
  color_hex       VARCHAR(7) NOT NULL, -- e.g., "#2563EB"
  display_order   INT NOT NULL DEFAULT 0,
  is_active       TINYINT(1) NOT NULL DEFAULT 1,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_display_order (display_order),
  INDEX idx_is_active (is_active)
);
```

### service_providers Table (Updated)
```sql
CREATE TABLE service_providers (
  id                VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
  user_id           VARCHAR(36) NOT NULL UNIQUE,
  business_name     VARCHAR(200) NOT NULL,
  description       TEXT NULL,
  category_id       VARCHAR(36) NOT NULL,
  hourly_rate       DECIMAL(10,2) NULL,
  fixed_rates       JSON NULL, -- {service_name: price}
  service_area      JSON NOT NULL, -- ["Colombo", "Gampaha"]
  availability      JSON NULL, -- Weekly schedule
  is_verified       TINYINT(1) NOT NULL DEFAULT 0,
  is_available      TINYINT(1) NOT NULL DEFAULT 1,
  rating            DECIMAL(3,2) NOT NULL DEFAULT 5.00,
  total_reviews     INT NOT NULL DEFAULT 0,
  total_bookings    INT NOT NULL DEFAULT 0,
  completion_rate   DECIMAL(5,2) NOT NULL DEFAULT 100.00,
  response_time_min INT NOT NULL DEFAULT 60, -- Average response time
  years_experience  INT NOT NULL DEFAULT 0,
  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES service_categories(id),
  INDEX idx_category_id (category_id),
  INDEX idx_rating (rating),
  INDEX idx_is_verified (is_verified),
  INDEX idx_is_available (is_available),
  FULLTEXT idx_business_name_desc (business_name, description)
);
```

### provider_portfolio Table (New)
```sql
CREATE TABLE provider_portfolio (
  id              INT PRIMARY KEY AUTO_INCREMENT,
  provider_id     VARCHAR(36) NOT NULL,
  image_url       VARCHAR(500) NOT NULL,
  title           VARCHAR(200) NULL,
  description     TEXT NULL,
  display_order   INT NOT NULL DEFAULT 0,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (provider_id) REFERENCES service_providers(id) ON DELETE CASCADE,
  INDEX idx_provider_id (provider_id),
  INDEX idx_display_order (display_order)
);
```

### provider_certifications Table (Updated)
```sql
CREATE TABLE provider_certifications (
  id              INT PRIMARY KEY AUTO_INCREMENT,
  provider_id     VARCHAR(36) NOT NULL,
  certification_name VARCHAR(200) NOT NULL,
  issuing_org     VARCHAR(200) NULL,
  issue_date      DATE NULL,
  expiry_date     DATE NULL,
  document_url    VARCHAR(500) NULL,
  is_verified     TINYINT(1) NOT NULL DEFAULT 0,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (provider_id) REFERENCES service_providers(id) ON DELETE CASCADE,
  INDEX idx_provider_id (provider_id)
);
```

### bookings Table (Updated)
```sql
CREATE TABLE bookings (
  id                VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
  booking_number    VARCHAR(50) NOT NULL UNIQUE,
  user_id           VARCHAR(36) NOT NULL,
  provider_id       VARCHAR(36) NOT NULL,
  category_id       VARCHAR(36) NOT NULL,
  status            ENUM('pending','confirmed','in_progress','completed','cancelled') NOT NULL DEFAULT 'pending',
  service_date      DATE NOT NULL,
  service_time      TIME NOT NULL,
  duration_hours    DECIMAL(4,2) NOT NULL,
  service_address   TEXT NOT NULL,
  service_city      VARCHAR(100) NOT NULL,
  service_lat       DECIMAL(10,8) NULL,
  service_lng       DECIMAL(11,8) NULL,
  contact_phone     VARCHAR(20) NOT NULL,
  description       TEXT NULL,
  special_instructions TEXT NULL,
  estimated_cost    DECIMAL(10,2) NOT NULL,
  final_cost        DECIMAL(10,2) NULL,
  payment_method    ENUM('cash','wallet','card') NOT NULL DEFAULT 'cash',
  payment_status    ENUM('pending','completed','failed','refunded') NOT NULL DEFAULT 'pending',
  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  confirmed_at      DATETIME NULL,
  started_at        DATETIME NULL,
  completed_at      DATETIME NULL,
  cancelled_at      DATETIME NULL,
  cancellation_reason TEXT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (provider_id) REFERENCES service_providers(id),
  FOREIGN KEY (category_id) REFERENCES service_categories(id),
  INDEX idx_user_id (user_id),
  INDEX idx_provider_id (provider_id),
  INDEX idx_status (status),
  INDEX idx_service_date (service_date),
  INDEX idx_booking_number (booking_number)
);
```

## API Endpoints

### Service Categories
- `GET /api/v1/services/categories` - Get all categories
- `GET /api/v1/services/categories/:id` - Get category details

### Service Providers
- `GET /api/v1/services/providers` - List providers (with filters)
  - Query params: `category_id`, `city`, `min_rating`, `sort_by`, `page`, `limit`
- `GET /api/v1/services/providers/:id` - Get provider profile
- `GET /api/v1/services/providers/:id/portfolio` - Get portfolio images
- `GET /api/v1/services/providers/:id/availability` - Check availability

### Bookings
- `POST /api/v1/bookings` - Create booking
- `GET /api/v1/bookings` - List user's bookings
- `GET /api/v1/bookings/:id` - Get booking details
- `PUT /api/v1/bookings/:id/cancel` - Cancel booking
- `PUT /api/v1/bookings/:id/confirm` - Confirm booking (provider only)
- `PUT /api/v1/bookings/:id/start` - Start service (provider only)
- `PUT /api/v1/bookings/:id/complete` - Complete service (provider only)

## Provider Ranking Algorithm

```typescript
function calculateProviderRank(provider: Provider): number {
  let score = 0;
  
  // Rating (40% weight)
  score += (provider.rating / 5.0) * 0.40;
  
  // Completion rate (30% weight)
  score += (provider.completion_rate / 100.0) * 0.30;
  
  // Verification status (15% weight)
  if (provider.is_verified) {
    score += 0.15;
  }
  
  // Response time (10% weight)
  if (provider.response_time_min <= 30) {
    score += 0.10;
  } else if (provider.response_time_min <= 60) {
    score += 0.05;
  }
  
  // Experience (5% weight)
  const expScore = Math.min(provider.years_experience / 10, 1.0);
  score += expScore * 0.05;
  
  return score;
}
```

## Booking Conflict Detection

```typescript
async function checkBookingConflict(
  providerId: string,
  serviceDate: Date,
  serviceTime: string,
  durationHours: number
): Promise<boolean> {
  // Calculate end time
  const [hours, minutes] = serviceTime.split(':').map(Number);
  const startMinutes = hours * 60 + minutes;
  const endMinutes = startMinutes + (durationHours * 60);
  
  // Query for overlapping bookings
  const query = `
    SELECT COUNT(*) as count
    FROM bookings
    WHERE provider_id = ?
      AND service_date = ?
      AND status IN ('pending', 'confirmed', 'in_progress')
      AND (
        (TIME_TO_SEC(service_time) / 60 < ? AND 
         TIME_TO_SEC(service_time) / 60 + (duration_hours * 60) > ?)
        OR
        (TIME_TO_SEC(service_time) / 60 >= ? AND 
         TIME_TO_SEC(service_time) / 60 < ?)
      )
  `;
  
  const [result] = await db.execute(query, [
    providerId,
    serviceDate,
    endMinutes,
    startMinutes,
    startMinutes,
    endMinutes
  ]);
  
  return result[0].count > 0;
}
```

## Real-time Updates (Socket.IO)

### Events

**Client → Server:**
- `booking:create` - New booking created
- `booking:cancel` - Booking cancelled

**Server → Client:**
- `booking:confirmed` - Provider confirmed booking
- `booking:started` - Service started
- `booking:completed` - Service completed
- `booking:cancelled` - Booking cancelled

### Implementation

```typescript
// Server-side
io.on('connection', (socket) => {
  socket.on('booking:create', async (data) => {
    const booking = await createBooking(data);
    
    // Notify provider
    io.to(`user:${booking.provider_id}`).emit('booking:new', booking);
    
    // Notify user
    socket.emit('booking:created', booking);
  });
});

// Client-side (Flutter)
socket.on('booking:confirmed', (data) {
  // Update UI
  ref.read(bookingsProvider.notifier).updateBookingStatus(
    data.booking_id,
    BookingStatus.confirmed
  );
  
  // Show notification
  showNotification('Booking Confirmed', 'Your service provider has confirmed your booking');
});
```

## UI Components

### Provider Card Component
```dart
class ProviderCard extends StatelessWidget {
  final ProviderEntity provider;
  final VoidCallback onTap;
  
  // Shows: avatar, name, rating, experience, price, distance, verified badge
}
```

### Category Card Component
```dart
class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onTap;
  
  // Shows: icon, name, provider count
}
```

### Portfolio Gallery Component
```dart
class PortfolioGallery extends StatelessWidget {
  final List<PortfolioImage> images;
  
  // Horizontal scrolling gallery with tap to view full screen
}
```

### Booking Status Timeline Component
```dart
class BookingTimeline extends StatelessWidget {
  final BookingEntity booking;
  
  // Shows: pending → confirmed → in_progress → completed
}
```

## Performance Optimizations

1. **Caching:**
   - Cache service categories (Redis, TTL: 1 hour)
   - Cache provider rankings by category (Redis, TTL: 10 minutes)
   - Cache provider profiles (Redis, TTL: 5 minutes)

2. **Database Indexing:**
   - Composite index on (category_id, rating, is_verified)
   - Spatial index for location-based queries
   - Full-text index on business_name and description

3. **Image Optimization:**
   - Use CDN for portfolio images
   - Generate thumbnails for gallery view
   - Lazy load images in lists

4. **Pagination:**
   - Load 20 providers per page
   - Implement infinite scroll

## Security Considerations

1. **Booking Validation:**
   - Verify provider exists and is available
   - Check for scheduling conflicts
   - Validate service date is in the future
   - Validate duration is reasonable (0.5 - 8 hours)

2. **Authorization:**
   - Only booking owner can cancel
   - Only provider can confirm/start/complete
   - Verify user has permission to view booking details

3. **Rate Limiting:**
   - Limit booking creation to 5 per hour per user
   - Limit provider search to 100 requests per minute per IP

4. **Data Sanitization:**
   - Sanitize all text inputs
   - Validate phone numbers
   - Validate addresses

## Localization

All text should support English, Sinhala, and Tamil:
- Category names
- UI labels
- Error messages
- Notification messages

Use `intl` package for Flutter localization.

## Next Steps

1. Create database migrations for new tables
2. Implement backend API endpoints
3. Create Flutter UI screens
4. Implement state management with Riverpod
5. Add Socket.IO real-time updates
6. Write unit and integration tests
7. Add analytics tracking

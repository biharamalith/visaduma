# Service Provider Booking Feature

## Overview

This feature enables users to browse service categories, find service providers, view detailed profiles, and book services. The implementation is inspired by apps like Angi and FixMe but adapted for VisaDuma's super app context.

## Key Features

1. **Service Categories**
   - 12+ categories (Carpenter, Electrician, Plumber, Painter, AC Repair, Cleaning, etc.)
   - Icon-based navigation
   - Search and filter

2. **Provider Discovery**
   - Browse providers by category
   - Advanced filtering (rating, price, distance)
   - Provider ranking algorithm
   - Search functionality

3. **Provider Profiles**
   - Detailed business information
   - Portfolio gallery of previous work
   - Certifications and verification
   - Reviews and ratings
   - Service area and availability
   - Pricing information

4. **Booking System**
   - Date and time selection
   - Duration picker
   - Address selection with map
   - Conflict detection
   - Cost estimation
   - Multiple payment methods

5. **Real-time Updates**
   - Booking status notifications
   - Provider confirmation alerts
   - Service progress tracking

## User Flow

```
Home Screen
  ↓ Tap "See More" on Popular Services
Service Categories Screen
  ↓ Select category (e.g., "Carpenter")
Service Providers List
  ↓ Tap provider card
Provider Profile
  ↓ Tap "Book Now"
Booking Form
  ↓ Submit booking
Booking Confirmation
```

## Technical Architecture

### Backend
- **Framework:** Node.js + Express
- **Database:** PostgreSQL with PostGIS
- **Caching:** Redis
- **Real-time:** Socket.IO
- **File Storage:** AWS S3

### Frontend
- **Framework:** Flutter
- **State Management:** Riverpod
- **Navigation:** go_router
- **Real-time:** socket_io_client
- **Localization:** intl (English, Sinhala, Tamil)

## Database Schema

### New Tables
1. `service_categories` - Service category definitions
2. `provider_portfolio` - Provider work portfolio images
3. `provider_certifications` - Provider certifications (updated)

### Updated Tables
1. `service_providers` - Added category_id, years_experience, etc.
2. `bookings` - Added category_id, special_instructions, etc.

## API Endpoints

### Service Categories
- `GET /api/v1/services/categories` - List all categories
- `GET /api/v1/services/categories/:id` - Get category details

### Service Providers
- `GET /api/v1/services/providers` - List providers with filters
- `GET /api/v1/services/providers/:id` - Get provider profile
- `GET /api/v1/services/providers/:id/portfolio` - Get portfolio
- `GET /api/v1/services/providers/:id/availability` - Check availability

### Bookings
- `POST /api/v1/bookings` - Create booking
- `GET /api/v1/bookings` - List user bookings
- `GET /api/v1/bookings/:id` - Get booking details
- `PUT /api/v1/bookings/:id/cancel` - Cancel booking
- `PUT /api/v1/bookings/:id/confirm` - Confirm (provider)
- `PUT /api/v1/bookings/:id/start` - Start service (provider)
- `PUT /api/v1/bookings/:id/complete` - Complete (provider)

## Key Algorithms

### Provider Ranking
Ranks providers based on:
- Rating (40%)
- Completion rate (30%)
- Verification status (15%)
- Response time (10%)
- Experience (5%)

### Booking Conflict Detection
Prevents double-booking by checking for time overlaps:
- Queries existing bookings for provider
- Checks for time range overlaps
- Returns conflict status

## Real-time Events (Socket.IO)

### Client → Server
- `booking:create` - New booking
- `booking:cancel` - Cancel booking

### Server → Client
- `booking:new` - Notify provider
- `booking:confirmed` - Notify user
- `booking:started` - Service started
- `booking:completed` - Service completed
- `booking:cancelled` - Booking cancelled

## UI Screens

1. **Home Screen** (updated) - Popular services with "See More"
2. **Service Categories Screen** (new) - All categories grid
3. **Service Providers List** (updated) - Filtered provider cards
4. **Provider Profile Screen** (new) - Detailed profile
5. **Booking Form Screen** (new) - Create booking
6. **Booking Confirmation Screen** (new) - Success message
7. **Bookings List Screen** (new) - User's bookings
8. **Booking Detail Screen** (new) - Booking details with timeline

## Implementation Status

See `tasks.md` for detailed implementation checklist.

### Phase 1: Database & Backend (Not Started)
- Database schema
- API endpoints
- Business logic
- Real-time events

### Phase 2: Flutter Frontend (Not Started)
- Domain entities
- Data models
- State management
- UI screens
- UI components

### Phase 3: Testing & Polish (Not Started)
- Unit tests
- Integration tests
- Performance optimization
- UI/UX polish

## Getting Started

### Prerequisites
- Node.js 18+
- PostgreSQL 14+ with PostGIS
- Redis 6+
- Flutter 3.10+

### Backend Setup
```bash
cd backend
npm install
npm run migrate
npm run seed:categories
npm run dev
```

### Frontend Setup
```bash
flutter pub get
flutter pub run build_runner build
flutter run
```

## Testing

### Backend Tests
```bash
cd backend
npm test
```

### Frontend Tests
```bash
flutter test
```

## Documentation

- `design.md` - Detailed design document
- `tasks.md` - Implementation task checklist
- `README.md` - This file

## References

- Angi app (formerly Angie's List)
- FixMe app
- VisaDuma system design spec

## Notes

- All text supports English, Sinhala, and Tamil
- Images stored in AWS S3 with CDN
- Real-time updates via Socket.IO
- Caching with Redis for performance
- Provider ranking algorithm for quality
- Conflict detection prevents double-booking

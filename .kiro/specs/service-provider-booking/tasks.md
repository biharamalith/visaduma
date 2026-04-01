# Service Provider Booking Feature - Implementation Tasks

## Overview

This document outlines the step-by-step implementation tasks for the Service Provider Booking feature. Tasks are organized by layer (database, backend, frontend) and should be completed in order.

## Phase 1: Database & Backend Foundation

### Task 1: Database Schema Setup

- [x] 1.1 Create service_categories table migration
  - Add table with all fields (id, name, name_si, name_ta, description, icon_name, color_hex, display_order, is_active)
  - Add indexes for display_order and is_active
  - Seed with initial 12 categories

- [x] 1.2 Update service_providers table migration
  - Add new fields: category_id, years_experience, total_bookings, response_time_min
  - Add foreign key to service_categories
  - Add composite index on (category_id, rating, is_verified)
  - Update existing records if any

- [x] 1.3 Create provider_portfolio table migration
  - Add table with fields (id, provider_id, image_url, title, description, display_order)
  - Add foreign key to service_providers with CASCADE delete
  - Add indexes for provider_id and display_order

- [x] 1.4 Update provider_certifications table migration
  - Verify existing structure matches design
  - Add any missing fields (issuing_org, issue_date, expiry_date)

- [x] 1.5 Update bookings table migration
  - Add new fields: category_id, service_lat, service_lng, special_instructions, cancellation_reason
  - Add foreign key to service_categories
  - Add index on service_date
  - Update status enum if needed

- [-] 1.6 Run all migrations and verify
  - Execute migrations in development environment
  - Verify all tables created successfully
  - Check all foreign keys and indexes

### Task 2: Backend API - Service Categories

- [x] 2.1 Create category model and repository
  - Create `src/models/ServiceCategory.js`
  - Create `src/repositories/serviceCategoryRepository.js`
  - Implement CRUD operations

- [x] 2.2 Create category service layer
  - Create `src/services/serviceCategoryService.js`
  - Implement `getAllCategories()` with caching
  - Implement `getCategoryById(id)`
  - Add Redis caching (TTL: 1 hour)

- [~] 2.3 Create category API endpoints
  - Create `src/routes/serviceCategories.js`
  - Implement `GET /api/v1/services/categories`
  - Implement `GET /api/v1/services/categories/:id`
  - Add response formatting

- [~] 2.4 Seed initial categories
  - Create seed script `src/utils/seedCategories.js`
  - Add 12 categories with icons and colors
  - Run seed script

### Task 3: Backend API - Service Providers

- [~] 3.1 Update provider model and repository
  - Update `src/models/ServiceProvider.js` with new fields
  - Update `src/repositories/serviceProviderRepository.js`
  - Add methods for portfolio and certifications

- [~] 3.2 Implement provider ranking algorithm
  - Create `src/utils/providerRanking.js`
  - Implement `calculateProviderRank(provider)` function
  - Add unit tests for ranking logic

- [~] 3.3 Create provider service layer
  - Update `src/services/serviceProviderService.js`
  - Implement `getProvidersByCategory(categoryId, filters, sort)`
  - Implement `getProviderProfile(id)` with portfolio and certs
  - Implement `checkProviderAvailability(id, date, time, duration)`
  - Add Redis caching for provider lists and profiles

- [~] 3.4 Create provider API endpoints
  - Update `src/routes/serviceProviders.js`
  - Implement `GET /api/v1/services/providers` with filters
    - Query params: category_id, city, min_rating, sort_by, page, limit
  - Implement `GET /api/v1/services/providers/:id`
  - Implement `GET /api/v1/services/providers/:id/portfolio`
  - Implement `GET /api/v1/services/providers/:id/availability`

- [~] 3.5 Add provider search functionality
  - Implement full-text search on business_name and description
  - Add relevance scoring
  - Support filtering and sorting

### Task 4: Backend API - Bookings

- [~] 4.1 Create booking model and repository
  - Update `src/models/Booking.js` with new fields
  - Update `src/repositories/bookingRepository.js`
  - Add methods for conflict detection

- [~] 4.2 Implement booking conflict detection
  - Create `src/utils/bookingConflict.js`
  - Implement `checkBookingConflict(providerId, date, time, duration)`
  - Add unit tests for conflict detection logic

- [~] 4.3 Create booking service layer
  - Update `src/services/bookingService.js`
  - Implement `createBooking(data)` with validation and conflict check
  - Implement `getUserBookings(userId, filters)`
  - Implement `getBookingDetails(id)`
  - Implement `cancelBooking(id, userId, reason)`
  - Implement provider methods: `confirmBooking`, `startBooking`, `completeBooking`

- [~] 4.4 Create booking API endpoints
  - Update `src/routes/bookings.js`
  - Implement `POST /api/v1/bookings`
  - Implement `GET /api/v1/bookings`
  - Implement `GET /api/v1/bookings/:id`
  - Implement `PUT /api/v1/bookings/:id/cancel`
  - Implement `PUT /api/v1/bookings/:id/confirm` (provider only)
  - Implement `PUT /api/v1/bookings/:id/start` (provider only)
  - Implement `PUT /api/v1/bookings/:id/complete` (provider only)

- [~] 4.5 Add booking validation
  - Validate service date is in future
  - Validate duration is between 0.5 and 8 hours
  - Validate provider exists and is available
  - Validate payment method
  - Add rate limiting (5 bookings per hour per user)

### Task 5: Real-time Updates (Socket.IO)

- [~] 5.1 Create booking Socket.IO events
  - Update `src/config/socket.js`
  - Add event handlers for `booking:create`, `booking:cancel`
  - Emit events: `booking:new`, `booking:confirmed`, `booking:started`, `booking:completed`, `booking:cancelled`

- [~] 5.2 Integrate Socket.IO with booking service
  - Emit `booking:new` to provider when booking created
  - Emit `booking:confirmed` to user when provider confirms
  - Emit status updates for start and complete

- [~] 5.3 Add notification integration
  - Send push notification when booking status changes
  - Send SMS notification for important updates
  - Create notification templates for booking events

## Phase 2: Flutter Frontend Implementation

### Task 6: Domain Layer - Entities & Repositories

- [x] 6.1 Create service category entity
  - Create `lib/features/services/domain/entities/service_category_entity.dart`
  - Add fields: id, name, nameSi, nameTa, description, iconName, colorHex, providerCount

- [x] 6.2 Update service provider entity
  - Update `lib/features/services/domain/entities/service_provider_entity.dart`
  - Add fields: categoryId, yearsExperience, totalBookings, responseTimeMin, completionRate
  - Add portfolio and certifications lists

- [x] 6.3 Create booking entity
  - Create `lib/features/bookings/domain/entities/booking_entity.dart`
  - Add all fields from database schema
  - Add status enum

- [x] 6.4 Create portfolio entity
  - Create `lib/features/services/domain/entities/portfolio_entity.dart`
  - Add fields: id, imageUrl, title, description

- [x] 6.5 Create certification entity
  - Create `lib/features/services/domain/entities/certification_entity.dart`
  - Add fields: id, name, issuingOrg, issueDate, expiryDate, isVerified

- [x] 6.6 Create repository interfaces
  - Create `lib/features/services/domain/repositories/service_category_repository.dart`
  - Create `lib/features/services/domain/repositories/service_provider_repository.dart`
  - Update `lib/features/bookings/domain/repositories/booking_repository.dart`

### Task 7: Data Layer - Models & API

- [x] 7.1 Create service category model
  - Create `lib/features/services/data/models/service_category_model.dart`
  - Implement `fromJson` and `toJson`
  - Implement `toEntity` method

- [x] 7.2 Update service provider model
  - Update `lib/features/services/data/models/service_provider_model.dart`
  - Add new fields
  - Update JSON serialization

- [x] 7.3 Create booking model
  - Create `lib/features/bookings/data/models/booking_model.dart`
  - Implement JSON serialization
  - Implement `toEntity` method

- [x] 7.4 Create portfolio and certification models
  - Create `lib/features/services/data/models/portfolio_model.dart`
  - Create `lib/features/services/data/models/certification_model.dart`
  - Implement JSON serialization

- [x] 7.5 Create API data sources
  - Create `lib/features/services/data/datasources/service_category_remote_datasource.dart`
  - Update `lib/features/services/data/datasources/service_provider_remote_datasource.dart`
  - Update `lib/features/bookings/data/datasources/booking_remote_datasource.dart`

- [~] 7.6 Implement repository implementations
  - Create `lib/features/services/data/repositories/service_category_repository_impl.dart`
  - Update `lib/features/services/data/repositories/service_provider_repository_impl.dart`
  - Update `lib/features/bookings/data/repositories/booking_repository_impl.dart`

### Task 8: Presentation Layer - State Management

- [~] 8.1 Create service categories view model
  - Create `lib/features/services/presentation/viewmodels/service_categories_viewmodel.dart`
  - Implement Riverpod provider
  - Add methods: `loadCategories()`, `searchCategories(query)`

- [~] 8.2 Update service providers view model
  - Update `lib/features/services/presentation/viewmodels/service_providers_viewmodel.dart`
  - Add methods: `loadProvidersByCategory(categoryId)`, `filterProviders(filters)`, `sortProviders(sortBy)`

- [~] 8.3 Create provider profile view model
  - Create `lib/features/services/presentation/viewmodels/provider_profile_viewmodel.dart`
  - Add methods: `loadProviderProfile(id)`, `loadPortfolio(id)`, `checkAvailability(id, date, time, duration)`

- [~] 8.4 Create bookings view model
  - Create `lib/features/bookings/presentation/viewmodels/bookings_viewmodel.dart`
  - Add methods: `createBooking(data)`, `loadUserBookings()`, `cancelBooking(id, reason)`

- [~] 8.5 Create booking detail view model
  - Create `lib/features/bookings/presentation/viewmodels/booking_detail_viewmodel.dart`
  - Add methods: `loadBookingDetails(id)`, `subscribeToUpdates(id)`

- [~] 8.6 Integrate Socket.IO for real-time updates
  - Update `lib/core/services/socket_service.dart`
  - Add booking event listeners
  - Update view models to handle real-time events

### Task 9: Presentation Layer - UI Screens

- [~] 9.1 Update home screen
  - Update `lib/features/home/presentation/screens/home_screen.dart`
  - Keep existing "Popular Services" section
  - Add "See More" button
  - Update navigation to categories screen

- [~] 9.2 Create service categories screen
  - Create `lib/features/services/presentation/screens/service_categories_screen.dart`
  - Add search bar
  - Add 2-column grid of category cards
  - Implement navigation to providers list

- [~] 9.3 Update service providers list screen
  - Update `lib/features/services/presentation/screens/service_providers_list_screen.dart`
  - Add filter button (sort by rating, price, distance)
  - Update provider card design
  - Add pagination/infinite scroll

- [~] 9.4 Create provider profile screen
  - Create `lib/features/services/presentation/screens/provider_profile_screen.dart`
  - Add header section (avatar, name, rating, experience)
  - Add quick actions (call, chat, book)
  - Add about section
  - Add services & pricing section
  - Add portfolio gallery
  - Add certifications section
  - Add reviews section
  - Add location map

- [~] 9.5 Create booking form screen
  - Create `lib/features/bookings/presentation/screens/booking_form_screen.dart`
  - Add form fields (date, time, duration, address, phone, description)
  - Add date/time pickers
  - Add map picker for address
  - Add payment method selector
  - Add cost breakdown
  - Add "Confirm Booking" button

- [~] 9.6 Create booking confirmation screen
  - Create `lib/features/bookings/presentation/screens/booking_confirmation_screen.dart`
  - Add success icon and message
  - Add booking details
  - Add navigation buttons

- [~] 9.7 Create bookings list screen
  - Create `lib/features/bookings/presentation/screens/bookings_list_screen.dart`
  - Add tabs for active/past bookings
  - Add booking cards with status
  - Implement navigation to booking details

- [~] 9.8 Create booking detail screen
  - Create `lib/features/bookings/presentation/screens/booking_detail_screen.dart`
  - Add booking info
  - Add status timeline
  - Add provider info
  - Add cancel button (if applicable)
  - Add real-time status updates

### Task 10: Presentation Layer - UI Components

- [~] 10.1 Create category card widget
  - Create `lib/features/services/presentation/widgets/category_card.dart`
  - Add icon, name, provider count
  - Add tap animation

- [~] 10.2 Update provider card widget
  - Update `lib/features/services/presentation/widgets/provider_card.dart`
  - Add avatar, name, rating, experience, price, distance
  - Add verified badge
  - Add "View Profile" button

- [~] 10.3 Create portfolio gallery widget
  - Create `lib/features/services/presentation/widgets/portfolio_gallery.dart`
  - Add horizontal scrolling
  - Add tap to view full screen
  - Add image caching

- [~] 10.4 Create certification card widget
  - Create `lib/features/services/presentation/widgets/certification_card.dart`
  - Add certification info
  - Add verified badge

- [~] 10.5 Create booking status timeline widget
  - Create `lib/features/bookings/presentation/widgets/booking_timeline.dart`
  - Add status steps (pending → confirmed → in_progress → completed)
  - Add visual indicators

- [~] 10.6 Create booking card widget
  - Create `lib/features/bookings/presentation/widgets/booking_card.dart`
  - Add booking info summary
  - Add status badge
  - Add tap to view details

- [~] 10.7 Create cost breakdown widget
  - Create `lib/features/bookings/presentation/widgets/cost_breakdown.dart`
  - Add itemized costs
  - Add total

### Task 11: Navigation & Routing

- [~] 11.1 Update app router
  - Update `lib/core/router/app_router.dart`
  - Add routes for all new screens
  - Add route parameters for IDs

- [~] 11.2 Update navigation flow
  - Test navigation from home to categories
  - Test navigation from categories to providers
  - Test navigation from providers to profile
  - Test navigation from profile to booking form
  - Test navigation from booking form to confirmation

### Task 12: Localization

- [~] 12.1 Add English translations
  - Update `lib/core/localization/app_en.arb`
  - Add all new UI strings

- [~] 12.2 Add Sinhala translations
  - Update `lib/core/localization/app_si.arb`
  - Translate all new strings

- [~] 12.3 Add Tamil translations
  - Update `lib/core/localization/app_ta.arb`
  - Translate all new strings

## Phase 3: Testing & Polish

### Task 13: Backend Testing

- [~] 13.1 Write unit tests for provider ranking
  - Test ranking algorithm with various inputs
  - Test edge cases

- [~] 13.2 Write unit tests for conflict detection
  - Test overlapping bookings
  - Test non-overlapping bookings
  - Test edge cases (same start/end time)

- [~] 13.3 Write integration tests for booking flow
  - Test create booking
  - Test cancel booking
  - Test provider confirm/start/complete

- [~] 13.4 Write API endpoint tests
  - Test all category endpoints
  - Test all provider endpoints
  - Test all booking endpoints
  - Test error handling

### Task 14: Frontend Testing

- [~] 14.1 Write widget tests
  - Test category card
  - Test provider card
  - Test booking card
  - Test portfolio gallery

- [~] 14.2 Write view model tests
  - Test categories view model
  - Test providers view model
  - Test bookings view model

- [~] 14.3 Write integration tests
  - Test complete booking flow
  - Test provider search and filter
  - Test real-time updates

### Task 15: Performance & Optimization

- [~] 15.1 Optimize database queries
  - Add missing indexes
  - Optimize provider search query
  - Add query result caching

- [~] 15.2 Optimize image loading
  - Implement image caching
  - Generate thumbnails for portfolio
  - Use CDN for images

- [~] 15.3 Optimize API responses
  - Implement pagination
  - Add response compression
  - Minimize payload size

- [~] 15.4 Add loading states
  - Add shimmer loading for lists
  - Add skeleton screens
  - Add progress indicators

### Task 16: Final Polish

- [~] 16.1 Add error handling
  - Add error messages for all failure cases
  - Add retry mechanisms
  - Add offline support

- [~] 16.2 Add analytics
  - Track screen views
  - Track booking creation
  - Track provider profile views
  - Track search queries

- [~] 16.3 Add accessibility
  - Add semantic labels
  - Test with screen reader
  - Ensure proper contrast ratios

- [~] 16.4 UI/UX refinements
  - Add animations and transitions
  - Polish spacing and alignment
  - Test on different screen sizes
  - Test on Android and iOS

## Checkpoint

After completing all tasks:
- [ ] Test complete user flow end-to-end
- [ ] Verify all API endpoints work correctly
- [ ] Verify real-time updates work
- [ ] Test on multiple devices
- [ ] Get user feedback
- [ ] Fix any bugs found
- [ ] Deploy to staging environment
- [ ] Conduct final QA
- [ ] Deploy to production

## Estimated Timeline

- Phase 1 (Backend): 5-7 days
- Phase 2 (Frontend): 7-10 days
- Phase 3 (Testing & Polish): 3-5 days

Total: 15-22 days

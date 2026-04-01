# Implementation Plan: VisaDuma Super App

## Overview

This implementation plan breaks down the VisaDuma super app into actionable coding tasks organized by implementation phases. The system uses Flutter for mobile frontend, Node.js + Express for backend API, PostgreSQL with PostGIS for database (with geospatial capabilities), and Socket.IO for real-time features. Authentication is already implemented with JWT tokens and refresh token rotation.

The plan follows an incremental approach where each task builds on previous work, with checkpoints for validation and optional testing sub-tasks marked with `*` for faster MVP delivery.

## Tasks

### Phase 1: Foundation & Infrastructure Setup

- [x] 1. Set up backend project structure and core infrastructure
  - [x] 1.1 Initialize Node.js project with Express and TypeScript configuration
    - Create package.json with dependencies (express, pg, socket.io, bcryptjs, jsonwebtoken, multer, aws-sdk, cors, helmet, express-rate-limit)
    - Set up TypeScript configuration with strict mode
    - Create folder structure: src/{routes,controllers,services,models,middleware,utils,config}
    - Set up environment variables (.env file with database, JWT, AWS, Google Maps, Firebase credentials)
    - _Requirements: 81.2, 81.3, 81.4, 81.5_

  - [x] 1.2 Configure PostgreSQL database connection with connection pooling
    - Create database configuration file with node-postgres (pg)
    - Implement connection pool with proper limits (min: 5, max: 20)
    - Enable PostGIS extension for geospatial queries
    - Add database health check endpoint
    - _Requirements: 81.3, 61.10_

  - [x] 1.3 Set up Redis client for caching and session management
    - Install and configure Redis client (ioredis)
    - Create Redis service wrapper with connection handling
    - Implement cache helper functions (get, set, delete, expire)
    - _Requirements: 81.4, 61.7_

  - [x] 1.4 Configure AWS S3 for file uploads
    - Set up AWS SDK with credentials
    - Create S3 service for file upload/download
    - Implement multer middleware for multipart form data
    - Configure bucket policies and CORS
    - _Requirements: 81.8_

  - [x] 1.5 Set up Socket.IO server with JWT authentication
    - Initialize Socket.IO server with CORS configuration
    - Implement JWT authentication middleware for Socket.IO
    - Create connection/disconnection handlers
    - Set up room management for user-specific channels
    - _Requirements: 26.1, 26.2, 26.3, 26.4_


- [x] 2. Set up Flutter project structure with clean architecture
  - [x] 2.1 Initialize Flutter project with required dependencies
    - Create Flutter project with proper package name (com.visaduma.app)
    - Add dependencies to pubspec.yaml (riverpod, go_router, dio, socket_io_client, google_maps_flutter, firebase_messaging, flutter_secure_storage, cached_network_image, freezed, json_serializable, dartz, intl)
    - Set up dev dependencies (build_runner, riverpod_generator, freezed, json_serializable)
    - Configure analysis_options.yaml with strict linting rules
    - _Requirements: 81.1, 77.1, 77.2_

  - [x] 2.2 Create clean architecture folder structure
    - Create lib/features/{auth,rides,shops,services,bookings,wallet,chat,notifications,reviews,jobs,vehicles,loyalty,recommendations,maps,provider} folders
    - Create data/domain/presentation layers in each feature
    - Create lib/core/{network,storage,utils,constants,theme,localization} folders
    - Set up barrel exports for each module
    - _Requirements: 77.7, 77.8_

  - [x] 2.3 Configure Dio HTTP client with interceptors
    - Create Dio instance with base URL configuration
    - Implement auth interceptor for JWT token injection
    - Implement refresh token interceptor for automatic token refresh
    - Implement logging interceptor for debugging
    - Implement error handling interceptor
    - _Requirements: 6.6, 6.7, 8.5_

  - [x] 2.4 Set up secure storage for tokens and sensitive data
    - Configure flutter_secure_storage for iOS Keychain and Android Keystore
    - Create SecureStorageService wrapper
    - Implement methods for storing/retrieving access tokens, refresh tokens, and user data
    - _Requirements: 67.3, 67.4, 67.5_

  - [x] 2.5 Configure Firebase for push notifications
    - Add Firebase configuration files (google-services.json for Android, GoogleService-Info.plist for iOS)
    - Initialize Firebase in main.dart
    - Request notification permissions
    - Implement FCM token registration
    - _Requirements: 30.1, 30.2, 30.3, 30.4_

- [-] 3. Implement database schema and migrations
  - [x] 3.1 Create database migration system
    - Set up migration framework (node-pg-migrate or custom solution)
    - Create migrations folder structure
    - Implement migration runner script
    - _Requirements: 72.8_

  - [ ] 3.2 Create core tables (users, refresh_tokens already exist from auth module)
    - Verify existing users and refresh_tokens tables
    - Document existing schema
    - _Requirements: 4.1, 4.2, 4.3_

  - [ ] 3.3 Create rides module tables
    - Create migration for rides table with all fields and indexes
    - Create migration for drivers table with spatial index
    - Create migration for ride_locations table
    - _Requirements: 8.1, 8.4, 9.1, 9.8, 10.8_

  - [ ] 3.4 Create shops module tables
    - Create migration for shops table with fulltext indexes
    - Create migration for products table with fulltext indexes
    - Create migration for orders table
    - Create migration for order_items table
    - Create migration for cart_items table
    - Create migration for inventory_reservations table
    - _Requirements: 12.1, 12.5, 13.1, 13.5, 14.1, 15.1_

  - [ ] 3.5 Create services module tables
    - Create migration for service_categories table
    - Create migration for service_providers table
    - Create migration for provider_certifications table
    - Create migration for bookings table
    - _Requirements: 17.1, 17.3, 18.1, 18.4, 19.1_


  - [ ] 3.6 Create wallet module tables
    - Create migration for wallets table with balance constraint
    - Create migration for wallet_transactions table
    - Create migration for wallet_transfers table
    - _Requirements: 21.1, 21.2, 22.1, 23.6_

  - [ ] 3.7 Create chat module tables
    - Create migration for conversations table with unique constraint
    - Create migration for messages table
    - _Requirements: 27.1, 27.2, 28.1_

  - [ ] 3.8 Create notifications module tables
    - Create migration for notifications table
    - Create migration for fcm_tokens table
    - Create migration for notification_preferences table
    - _Requirements: 30.4, 31.1, 32.1_

  - [ ] 3.9 Create reviews module tables
    - Create migration for reviews table
    - Create migration for review_helpful_votes table
    - Create migration for review_responses table
    - _Requirements: 34.1, 34.5, 37.1, 37.6_

  - [ ] 3.10 Create jobs module tables
    - Create migration for job_categories table
    - Create migration for jobs table with fulltext indexes
    - Create migration for job_applications table
    - Create migration for job_contracts table
    - Create migration for job_milestones table
    - _Requirements: 38.1, 38.7, 39.1, 40.4_

  - [ ] 3.11 Create vehicles module tables
    - Create migration for vehicles table with fulltext indexes
    - Create migration for vehicle_rentals table
    - Create migration for vehicle_availability table
    - _Requirements: 42.1, 42.5, 43.1, 45.1_

  - [ ] 3.12 Create loyalty module tables
    - Create migration for loyalty_points table
    - Create migration for user_badges table
    - Create migration for user_streaks table
    - Create migration for referrals table
    - Create migration for rewards_catalog table
    - Create migration for reward_redemptions table
    - _Requirements: 46.1, 47.1, 48.1, 49.1, 50.1_

  - [ ] 3.13 Create AI recommendations module tables
    - Create migration for user_preferences table
    - Create migration for user_interactions table
    - Create migration for recommendations_cache table
    - _Requirements: 51.1, 51.7, 52.1_

  - [ ] 3.14 Create provider dashboard tables
    - Create migration for provider_earnings table
    - Create migration for payout_requests table
    - _Requirements: 57.1, 58.3_

- [ ] 4. Checkpoint - Verify database setup
  - Run all migrations successfully
  - Verify all tables created with proper constraints and indexes
  - Test database connection and queries
  - Ensure all tests pass, ask the user if questions arise.


### Phase 2: Core Services Implementation (Rides, Shops, Services)

- [ ] 5. Implement Rides module backend
  - [ ] 5.1 Create rides API endpoints
    - Implement POST /api/v1/rides/request with fare calculation
    - Implement GET /api/v1/rides/history with pagination
    - Implement GET /api/v1/rides/{id} for ride details
    - Implement POST /api/v1/rides/{id}/cancel for user cancellation
    - Implement driver endpoints: POST /api/v1/rides/{id}/accept, /start, /complete
    - _Requirements: 8.1, 8.2, 8.3, 8.8, 11.1, 11.2, 11.3_

  - [ ] 5.2 Implement driver matching algorithm
    - Create findNearbyDrivers function using Haversine formula
    - Implement driver ranking by distance, rating, and total rides
    - Add support for expanding search radius if no drivers found
    - Implement driver availability filtering
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.9, 9.10_

  - [ ] 5.3 Implement fare calculation algorithm
    - Create calculateFare function with base fare, per-km rate, per-minute rate
    - Implement surge multiplier support
    - Add fare rounding to nearest 10 LKR
    - Support all vehicle types (bike, tuk_tuk, car, van)
    - _Requirements: 8.8, 8.9_

  - [ ] 5.4 Implement real-time ride tracking with Socket.IO
    - Create Socket.IO events for ride requests, driver assignment, location updates
    - Implement driver location broadcast to users
    - Add location update throttling (5-second intervals)
    - Store location history in ride_locations table
    - _Requirements: 10.1, 10.2, 10.3, 10.8_

  - [ ] 5.5 Implement driver management endpoints
    - Create GET /api/v1/drivers/nearby endpoint with geospatial query
    - Implement PUT /api/v1/drivers/availability for online/offline toggle
    - Implement PUT /api/v1/drivers/location for location updates
    - _Requirements: 9.1, 9.8_

  - [ ] 5.6 Write unit tests for rides module
    - Test fare calculation with various inputs
    - Test driver matching algorithm
    - Test ride lifecycle state transitions
    - _Requirements: 79.1, 79.4_

- [ ] 6. Implement Shops module backend
  - [ ] 6.1 Create shops API endpoints
    - Implement GET /api/v1/shops with filtering by category and city
    - Implement GET /api/v1/shops/{id} for shop details
    - Implement POST /api/v1/shops for shop creation (shop owner only)
    - Implement PUT /api/v1/shops/{id} for shop updates
    - Implement DELETE /api/v1/shops/{id} for shop deletion
    - _Requirements: 12.1, 12.2, 12.7, 12.8_

  - [ ] 6.2 Create products API endpoints
    - Implement GET /api/v1/products with filtering and pagination
    - Implement GET /api/v1/products/{id} for product details
    - Implement GET /api/v1/products/search with full-text search
    - Implement POST /api/v1/products for product creation
    - Implement PUT /api/v1/products/{id} for product updates
    - Implement DELETE /api/v1/products/{id} for product deletion
    - _Requirements: 13.1, 13.2, 13.10, 16.1, 16.2_

  - [ ] 6.3 Implement product search with relevance scoring
    - Create searchProducts function with MATCH AGAINST full-text search
    - Implement filtering by category, price range, and shop
    - Implement sorting by relevance, price, rating, and popularity
    - Add Redis caching for search results (TTL: 2 minutes)
    - _Requirements: 16.1, 16.2, 16.3, 16.4, 16.6, 16.9, 16.10_


  - [ ] 6.4 Create cart API endpoints
    - Implement GET /api/v1/cart to retrieve user cart
    - Implement POST /api/v1/cart/add to add items
    - Implement PUT /api/v1/cart/update to update quantities
    - Implement DELETE /api/v1/cart/remove/{product_id} to remove items
    - Implement DELETE /api/v1/cart/clear to clear cart
    - Add stock validation when adding/updating cart items
    - _Requirements: 14.1, 14.2, 14.3, 14.4, 14.5_

  - [ ] 6.5 Implement inventory management with reservation system
    - Create reserveInventory function with database transactions and row locking
    - Create confirmInventoryDeduction function for order confirmation
    - Implement inventory restoration for cancelled orders
    - Add cleanup job for expired reservations (15-minute timeout)
    - _Requirements: 14.7, 15.2, 15.9_

  - [ ] 6.6 Create orders API endpoints
    - Implement POST /api/v1/orders/create with inventory reservation
    - Implement GET /api/v1/orders with filtering and pagination
    - Implement GET /api/v1/orders/{id} for order details
    - Implement POST /api/v1/orders/{id}/cancel with inventory restoration
    - Implement PUT /api/v1/orders/{id}/status for shop owner updates
    - Generate unique order_number for each order
    - _Requirements: 14.6, 14.8, 15.1, 15.4, 15.11, 15.12_

  - [ ] 6.7 Write unit tests for shops module
    - Test product search and filtering logic
    - Test inventory reservation and deduction
    - Test order creation and lifecycle
    - Test cart operations
    - _Requirements: 79.1, 79.4_

- [ ] 7. Implement Services module backend
  - [ ] 7.1 Create service categories and providers API endpoints
    - Implement GET /api/v1/services/categories
    - Implement GET /api/v1/services/providers with filtering by category and city
    - Implement GET /api/v1/services/providers/{id} for provider details
    - Implement POST /api/v1/services/providers for provider registration
    - Implement PUT /api/v1/services/providers/{id} for profile updates
    - _Requirements: 17.1, 17.2, 17.9, 20.1_

  - [ ] 7.2 Implement provider ranking algorithm
    - Create rankProviders function with multi-factor scoring
    - Calculate rank_score using rating (40%), completion_rate (30%), verification (15%), response_time (10%), experience (5%)
    - Implement filtering by availability on requested service_date
    - Add Redis caching for provider rankings (TTL: 10 minutes)
    - _Requirements: 20.3, 20.4, 20.5, 20.6, 20.7, 20.9_

  - [ ] 7.3 Create bookings API endpoints
    - Implement POST /api/v1/bookings/create with conflict detection
    - Implement GET /api/v1/bookings with filtering and pagination
    - Implement GET /api/v1/bookings/{id} for booking details
    - Implement POST /api/v1/bookings/{id}/cancel
    - Implement provider endpoints: POST /api/v1/bookings/{id}/accept, /start, /complete
    - Generate unique booking_number for each booking
    - _Requirements: 18.1, 18.2, 18.3, 18.5, 19.1, 19.4, 19.6_

  - [ ] 7.4 Implement booking conflict detection
    - Create checkBookingConflict function with time overlap logic
    - Validate provider availability before creating booking
    - Reject bookings with scheduling conflicts
    - _Requirements: 18.3, 18.4_

  - [ ] 7.5 Write unit tests for services module
    - Test provider ranking algorithm
    - Test booking conflict detection
    - Test booking lifecycle state transitions
    - _Requirements: 79.1, 79.4_

- [ ] 8. Checkpoint - Verify core services implementation
  - Test all API endpoints with Postman/Thunder Client
  - Verify database operations and transactions
  - Test real-time Socket.IO events for rides
  - Ensure all tests pass, ask the user if questions arise.


### Phase 3: Financial & Communication Systems (Wallet, Chat, Notifications)

- [ ] 9. Implement Wallet module backend
  - [ ] 9.1 Create wallet API endpoints
    - Implement GET /api/v1/wallet/balance with daily/monthly spent calculation
    - Implement POST /api/v1/wallet/topup with payment gateway integration
    - Implement POST /api/v1/wallet/withdraw with bank account validation
    - Implement POST /api/v1/wallet/transfer for peer-to-peer transfers
    - Implement POST /api/v1/wallet/pay for service payments
    - Implement GET /api/v1/wallet/transactions with filtering and pagination
    - _Requirements: 21.7, 22.1, 23.1, 24.1, 25.1_

  - [ ] 9.2 Implement wallet payment processing with transactions
    - Create processWalletPayment function with database transactions and row-level locking
    - Implement balance verification and limit checks
    - Implement debit/credit operations with balance tracking
    - Create transaction records for both payer and payee
    - _Requirements: 23.1, 23.2, 23.3, 23.6, 23.7, 23.8_

  - [ ] 9.3 Implement wallet top-up with payment gateway integration
    - Integrate with payment gateway API (placeholder for actual gateway)
    - Create webhook handler for payment confirmation
    - Implement transaction status updates (pending → completed/failed)
    - Add 2% transaction fee calculation
    - _Requirements: 22.1, 22.2, 22.3, 22.9_

  - [ ] 9.4 Implement wallet withdrawal and payout system
    - Create withdrawal request processing
    - Implement instant payout with 1% fee
    - Implement standard payout (1-3 days, no fee)
    - Add bank account validation
    - _Requirements: 24.1, 24.2, 24.7, 24.8_

  - [ ] 9.5 Write unit tests for wallet module
    - Test payment processing with various scenarios
    - Test balance and limit validations
    - Test transaction rollback on failures
    - Test concurrent payment handling
    - _Requirements: 79.1, 79.4_

- [ ] 10. Implement Chat module with Socket.IO
  - [ ] 10.1 Create chat Socket.IO event handlers
    - Implement message:send event handler with conversation validation
    - Implement typing:start and typing:stop event handlers
    - Implement message:read event handler
    - Implement conversation:join and conversation:leave handlers
    - _Requirements: 28.1, 28.2, 28.3, 29.1, 29.2_

  - [ ] 10.2 Implement conversation management
    - Create conversation creation logic for first message
    - Implement conversation list retrieval ordered by last_message_at
    - Implement unread count tracking and updates
    - Add support for conversation types (user_provider, user_driver, user_shop, user_user)
    - _Requirements: 27.1, 27.2, 27.5, 27.6, 27.10_

  - [ ] 10.3 Implement message delivery and offline handling
    - Save messages to database before broadcasting
    - Emit message:received to recipient via Socket.IO
    - Send push notification if recipient is offline
    - Implement message pagination (load 50 messages at a time)
    - _Requirements: 28.2, 28.3, 28.6, 27.7, 27.8_

  - [ ] 10.4 Implement typing indicators and presence tracking
    - Broadcast typing indicators to conversation participants
    - Implement auto-stop after 5 seconds of inactivity
    - Track online/offline presence in Redis
    - Update presence on connect/disconnect events
    - _Requirements: 29.3, 29.4, 29.5, 29.7, 29.8_

  - [ ] 10.5 Create chat REST API endpoints
    - Implement GET /api/v1/chat/conversations for conversation list
    - Implement GET /api/v1/chat/conversations/{id}/messages with pagination
    - Implement POST /api/v1/chat/conversations/create
    - Implement file upload endpoint for image/file messages
    - _Requirements: 27.7, 27.8, 28.7_

  - [ ] 10.6 Write integration tests for chat module
    - Test Socket.IO connection and authentication
    - Test message sending and receiving
    - Test typing indicators
    - Test offline message delivery
    - _Requirements: 79.3, 79.4_


- [ ] 11. Implement Notifications module
  - [ ] 11.1 Set up Firebase Admin SDK for FCM
    - Initialize Firebase Admin SDK with service account credentials
    - Create notification service wrapper
    - Implement multicast messaging for batch notifications
    - Handle failed token deactivation
    - _Requirements: 30.1, 30.7, 30.8_

  - [ ] 11.2 Create FCM token management endpoints
    - Implement POST /api/v1/notifications/fcm-token for token registration
    - Implement DELETE /api/v1/notifications/fcm-token for token removal
    - Support multiple devices per user
    - _Requirements: 30.4, 30.5, 30.6_

  - [ ] 11.3 Implement notification preferences system
    - Create GET /api/v1/notifications/preferences endpoint
    - Create PUT /api/v1/notifications/preferences endpoint
    - Initialize default preferences on user registration
    - Check preferences before sending notifications
    - Cache preferences in Redis for performance
    - _Requirements: 31.1, 31.2, 31.4, 31.6, 31.9_

  - [ ] 11.4 Create in-app notification center endpoints
    - Implement GET /api/v1/notifications with pagination and filtering
    - Implement POST /api/v1/notifications/{id}/read to mark as read
    - Implement POST /api/v1/notifications/read-all
    - Implement DELETE /api/v1/notifications/{id}
    - Calculate and return unread count
    - _Requirements: 32.1, 32.6, 32.7, 32.9, 32.10_

  - [ ] 11.5 Implement notification templates and delivery
    - Create notification templates for all event types (ride, order, booking, payment, chat)
    - Implement sendNotification function with preference checking
    - Add deep link data for navigation
    - Support notification localization based on user language
    - Implement auto-deletion of notifications older than 30 days
    - _Requirements: 33.1, 33.2, 33.3, 33.4, 33.5, 33.9, 33.10, 32.12_

  - [ ] 11.6 Write unit tests for notifications module
    - Test FCM token management
    - Test notification preference enforcement
    - Test notification template generation
    - _Requirements: 79.1, 79.4_

- [ ] 12. Checkpoint - Verify financial and communication systems
  - Test wallet payment flows end-to-end
  - Test chat message delivery and real-time updates
  - Test push notification delivery on Android and iOS
  - Verify transaction integrity and rollback scenarios
  - Ensure all tests pass, ask the user if questions arise.


### Phase 4: Engagement & Discovery (Reviews, Jobs, Vehicles)

- [ ] 13. Implement Reviews & Ratings module
  - [ ] 13.1 Create reviews API endpoints
    - Implement POST /api/v1/reviews with transaction verification
    - Implement GET /api/v1/reviews with filtering and sorting
    - Implement GET /api/v1/reviews/{id} for review details
    - Implement PUT /api/v1/reviews/{id} for review updates (author only)
    - Implement DELETE /api/v1/reviews/{id} for review deletion
    - Implement GET /api/v1/reviews/pending for user's pending reviews
    - _Requirements: 34.1, 34.2, 34.3, 36.1, 36.9_

  - [ ] 13.2 Implement rating calculation and aggregation
    - Create updateAverageRating function triggered on review submission
    - Calculate average rating from visible reviews only
    - Update rating in entity tables (drivers, shops, service_providers, vehicles)
    - Update total_reviews count
    - Calculate rating distribution (5-star to 1-star counts)
    - _Requirements: 35.1, 35.2, 35.3, 35.5, 35.6, 35.7, 35.10_

  - [ ] 13.3 Implement review interactions
    - Implement POST /api/v1/reviews/{id}/helpful for helpful votes
    - Implement DELETE /api/v1/reviews/{id}/helpful to remove vote
    - Implement POST /api/v1/reviews/{id}/response for provider responses
    - Prevent duplicate helpful votes per user
    - Send notification when provider responds to review
    - _Requirements: 37.1, 37.2, 37.3, 37.7, 37.8_

  - [ ] 13.4 Implement review sorting and display
    - Support sorting by recent, helpful, rating_high, rating_low
    - Add Redis caching for review lists (TTL: 5 minutes)
    - Include provider responses in review display
    - _Requirements: 36.2, 36.3, 36.4, 36.8, 36.10_

  - [ ] 13.5 Write unit tests for reviews module
    - Test rating calculation algorithm
    - Test review sorting logic
    - Test helpful vote tracking
    - _Requirements: 79.1, 79.4_

- [ ] 14. Implement Jobs & Gig Marketplace module
  - [ ] 14.1 Create job categories and jobs API endpoints
    - Implement GET /api/v1/jobs with filtering by category, job_type, location
    - Implement GET /api/v1/jobs/search with full-text search
    - Implement GET /api/v1/jobs/{id} for job details
    - Implement POST /api/v1/jobs for job posting
    - Implement PUT /api/v1/jobs/{id} for job updates
    - Implement POST /api/v1/jobs/{id}/close to close job
    - _Requirements: 38.1, 38.2, 38.7, 38.10, 38.11_

  - [ ] 14.2 Create job applications API endpoints
    - Implement POST /api/v1/jobs/{id}/apply for application submission
    - Implement GET /api/v1/jobs/{id}/applications for employer view
    - Implement GET /api/v1/applications for applicant's applications
    - Implement PUT /api/v1/applications/{id}/status for employer updates
    - Implement POST /api/v1/applications/{id}/withdraw for applicant withdrawal
    - Prevent duplicate applications per user per job
    - _Requirements: 39.1, 39.2, 39.7, 39.9, 40.1, 40.3_

  - [ ] 14.3 Implement job contracts and milestones
    - Implement POST /api/v1/contracts/create for hiring
    - Implement GET /api/v1/contracts with filtering
    - Implement POST /api/v1/contracts/{id}/complete
    - Implement milestone endpoints: /submit, /approve, /pay
    - Update job status to in_progress when contract is created
    - _Requirements: 40.4, 40.5, 40.7, 40.9_

  - [ ] 14.4 Implement job matching algorithm
    - Create getRecommendedJobs function with skill matching
    - Calculate match score using skills (40%), experience (20%), job_type (20%), location (10%), budget (10%)
    - Require minimum match score of 0.3
    - Cache recommendations per user (TTL: 10 minutes)
    - _Requirements: 41.1, 41.2, 41.7, 41.9_

  - [ ] 14.5 Write unit tests for jobs module
    - Test job matching algorithm
    - Test application workflow
    - Test contract creation and milestones
    - _Requirements: 79.1, 79.4_


- [ ] 15. Implement Vehicles module backend
  - [ ] 15.1 Create vehicles API endpoints
    - Implement GET /api/v1/vehicles with filtering by type, city, and date range
    - Implement GET /api/v1/vehicles/search with full-text search
    - Implement GET /api/v1/vehicles/{id} for vehicle details
    - Implement POST /api/v1/vehicles for vehicle listing
    - Implement PUT /api/v1/vehicles/{id} for vehicle updates
    - Implement GET /api/v1/vehicles/{id}/availability for availability check
    - _Requirements: 42.1, 42.2, 42.8, 42.11_

  - [ ] 15.2 Implement vehicle rental booking
    - Implement POST /api/v1/vehicles/{id}/rent with availability check
    - Calculate rental cost based on rental_type and duration
    - Create vehicle_availability record to block dates
    - Generate unique rental_number
    - _Requirements: 43.1, 43.4, 43.6, 43.10, 43.11_

  - [ ] 15.3 Implement rental lifecycle management
    - Implement POST /api/v1/rentals/{id}/confirm for owner confirmation
    - Implement POST /api/v1/rentals/{id}/start with odometer and fuel recording
    - Implement POST /api/v1/rentals/{id}/complete with extra charges calculation
    - Implement POST /api/v1/rentals/{id}/cancel with availability release
    - Process security deposit charge and refund
    - _Requirements: 44.1, 44.4, 44.7, 44.11, 44.12_

  - [ ] 15.4 Implement availability management system
    - Create checkVehicleAvailability function with date overlap detection
    - Implement vehicle_availability creation for rentals and maintenance
    - Use database transactions with row-level locking to prevent double-booking
    - _Requirements: 45.1, 45.2, 45.4, 45.8, 45.9_

  - [ ] 15.5 Implement rental cost calculation algorithm
    - Create calculateRentalCost function supporting hourly, daily, weekly, monthly rates
    - Calculate insurance amount (10% of base if not included)
    - Add platform fee (5% of base amount)
    - Include security deposit in total
    - _Requirements: 43.6, 43.7, 43.8_

  - [ ] 15.6 Write unit tests for vehicles module
    - Test availability check algorithm
    - Test rental cost calculation
    - Test rental lifecycle state transitions
    - _Requirements: 79.1, 79.4_

- [ ] 16. Checkpoint - Verify engagement and discovery features
  - Test review submission and rating calculation
  - Test job matching and application workflow
  - Test vehicle rental booking and availability
  - Verify all database transactions and constraints
  - Ensure all tests pass, ask the user if questions arise.


### Phase 5: Growth & Intelligence (Loyalty, AI, Provider Dashboard)

- [ ] 17. Implement Loyalty & Rewards module
  - [ ] 17.1 Create loyalty points system
    - Implement awardPoints function with points calculation rules
    - Award points for rides (10 + 1 per 100 LKR)
    - Award points for orders (20 + 5 per 1000 LKR)
    - Award points for bookings (15 + 2 per 500 LKR)
    - Award points for reviews (5 points, 10 with photo)
    - Set 1-year expiry for points
    - _Requirements: 46.1, 46.2, 46.3, 46.4, 46.5, 46.7, 46.8_

  - [ ] 17.2 Implement streak tracking system
    - Create updateStreak function with consecutive day logic
    - Increment streak for consecutive days, reset for gaps
    - Award bonus points for 7-day (50), 30-day (200), 100-day (1000) streaks
    - Update longest_streak when current exceeds it
    - _Requirements: 47.1, 47.2, 47.4, 47.6, 47.7, 47.8_

  - [ ] 17.3 Implement badges and achievements system
    - Create checkBadgeAchievements function
    - Award badges for milestones (first_ride, frequent_rider, top_shopper, service_pro, reviewer, referrer, streak_master)
    - Support badge levels with progression
    - Send notification when badge is earned
    - _Requirements: 48.1, 48.2, 48.3, 48.9, 48.11_

  - [ ] 17.4 Implement referral program
    - Generate unique referral_code on user registration
    - Create POST /api/v1/loyalty/apply-referral endpoint
    - Award 100 points to referrer and 50 to referee on first transaction
    - Track referral status (pending → completed)
    - _Requirements: 49.1, 49.2, 49.6, 49.7_

  - [ ] 17.5 Create rewards catalog and redemption system
    - Implement GET /api/v1/rewards/catalog endpoint
    - Implement POST /api/v1/rewards/{id}/redeem with points verification
    - Generate voucher codes for redeemed rewards
    - Implement GET /api/v1/rewards/my-vouchers
    - Track voucher usage and expiry
    - _Requirements: 50.1, 50.4, 50.6, 50.8, 50.12, 50.13_

  - [ ] 17.6 Create loyalty API endpoints
    - Implement GET /api/v1/loyalty/points with balance and expiring points
    - Implement GET /api/v1/loyalty/badges
    - Implement GET /api/v1/loyalty/streak
    - Implement GET /api/v1/loyalty/referral-code
    - _Requirements: 46.9, 47.9, 48.10, 49.9_

  - [ ] 17.7 Write unit tests for loyalty module
    - Test points calculation for various actions
    - Test streak tracking logic
    - Test badge achievement triggers
    - Test referral reward distribution
    - _Requirements: 79.1, 79.4_

- [ ] 18. Implement AI Recommendations module
  - [ ] 18.1 Create user interaction tracking
    - Implement POST /api/v1/interactions/track endpoint
    - Track view, click, search, book, purchase, review interactions
    - Store entity_type and entity_id with metadata
    - Implement 90-day retention policy
    - _Requirements: 51.1, 51.2, 51.3, 51.7, 51.10_

  - [ ] 18.2 Implement hybrid recommendation algorithm
    - Create generateRecommendations function with collaborative and content-based filtering
    - Implement findSimilarUsers using Jaccard similarity
    - Implement getContentBasedScores based on user preferences
    - Combine scores with 60% content-based, 40% collaborative weighting
    - Cache recommendations for 1 hour
    - _Requirements: 52.1, 52.2, 52.4, 52.5, 52.7, 52.8_

  - [ ] 18.3 Create recommendations API endpoints
    - Implement GET /api/v1/recommendations/services
    - Implement GET /api/v1/recommendations/products
    - Implement GET /api/v1/recommendations/vehicles
    - Implement GET /api/v1/recommendations/jobs
    - _Requirements: 52.1, 52.2_

  - [ ] 18.4 Implement simple rule-based chatbot
    - Create POST /api/v1/chatbot/message endpoint
    - Implement intent detection with keyword matching
    - Generate contextual responses with suggestions and actions
    - Support navigation actions to relevant screens
    - _Requirements: 52.1 (AI assistance)_

  - [ ] 18.5 Write unit tests for AI recommendations
    - Test similarity calculation
    - Test recommendation scoring
    - Test cache behavior
    - _Requirements: 79.1, 79.4_


- [ ] 19. Implement Provider Dashboard module
  - [ ] 19.1 Create provider earnings tracking
    - Create provider_earnings records on transaction completion
    - Calculate gross_amount, commission, and net_amount
    - Implement GET /api/v1/provider/earnings with period filtering
    - Calculate today, week, and month earnings
    - _Requirements: 57.1, 57.2, 57.3, 57.9_

  - [ ] 19.2 Implement payout management system
    - Implement POST /api/v1/provider/payout-request with balance verification
    - Create payout_requests record with bank account details
    - Implement payout processing workflow
    - Charge 1% fee for instant payouts, no fee for standard
    - _Requirements: 58.1, 58.2, 58.3, 58.7, 58.8_

  - [ ] 19.3 Create provider dashboard API
    - Implement GET /api/v1/provider/dashboard with key metrics
    - Calculate pending and active orders/bookings count
    - Display rating, completion rate, and available balance
    - _Requirements: 57.4, 57.5, 57.6, 57.7_

  - [ ] 19.4 Implement provider order/booking management
    - Implement GET /api/v1/provider/orders with status filtering
    - Display customer contact information for confirmed orders
    - Support sorting by date
    - _Requirements: 59.1, 59.2, 59.4, 59.9_

  - [ ] 19.5 Implement provider availability management
    - Implement PUT /api/v1/provider/availability for online/offline toggle
    - Store working schedule as JSON
    - Support date blocking for breaks/maintenance
    - _Requirements: 60.1, 60.2, 60.3, 60.6, 60.7_

  - [ ] 19.6 Write unit tests for provider dashboard
    - Test earnings calculation
    - Test payout request processing
    - Test availability management
    - _Requirements: 79.1, 79.4_

- [ ] 20. Checkpoint - Verify growth and intelligence features
  - Test loyalty points earning and redemption
  - Test recommendation generation
  - Test provider dashboard metrics
  - Verify payout processing workflow
  - Ensure all tests pass, ask the user if questions arise.


### Phase 6: Flutter Frontend Implementation

- [ ] 21. Implement Rides feature in Flutter
  - [ ] 21.1 Create rides domain layer
    - Define Ride, Driver, RideRequest entities with freezed
    - Create RidesRepository interface
    - Define use cases: RequestRide, GetRideHistory, CancelRide, TrackRide
    - _Requirements: 8.1, 10.1_

  - [ ] 21.2 Create rides data layer
    - Implement RidesRepositoryImpl with Dio
    - Create RidesRemoteDataSource for API calls
    - Implement JSON serialization with json_serializable
    - Add error handling and Either return types
    - _Requirements: 8.1, 71.4_

  - [ ] 21.3 Create rides presentation layer with Riverpod
    - Create RidesViewModel with state management
    - Implement requestRide, getRideHistory, cancelRide methods
    - Create driverLocationStream provider for real-time tracking
    - Integrate Socket.IO for ride updates
    - _Requirements: 8.1, 10.1, 10.2_

  - [ ] 21.4 Build rides UI screens
    - Create RideRequestScreen with pickup/dropoff selection
    - Create RideTrackingScreen with Google Maps integration
    - Create RideHistoryScreen with list view
    - Create RideDetailsScreen
    - Implement fare display and vehicle type selection
    - _Requirements: 8.1, 10.4, 10.5_

  - [ ] 21.5 Write widget tests for rides UI
    - Test ride request form validation
    - Test ride tracking map display
    - Test ride history list rendering
    - _Requirements: 79.2_

- [ ] 22. Implement Shops feature in Flutter
  - [ ] 22.1 Create shops domain layer
    - Define Shop, Product, Order, CartItem entities with freezed
    - Create ShopsRepository interface
    - Define use cases: GetShops, SearchProducts, AddToCart, CreateOrder
    - _Requirements: 12.1, 13.1, 14.1, 14.6_

  - [ ] 22.2 Create shops data layer
    - Implement ShopsRepositoryImpl with Dio
    - Create ShopsRemoteDataSource for API calls
    - Implement local cart storage with SharedPreferences
    - Add pagination support for shops and products
    - _Requirements: 12.1, 13.1, 16.9_

  - [ ] 22.3 Create shops presentation layer with Riverpod
    - Create ShopsViewModel with pagination
    - Create ProductsViewModel with search and filtering
    - Create CartViewModel with local state management
    - Create OrdersViewModel for order history
    - _Requirements: 12.1, 13.1, 14.1, 16.1_

  - [ ] 22.4 Build shops UI screens
    - Create ShopsListScreen with category filtering
    - Create ShopDetailsScreen with product grid
    - Create ProductDetailsScreen with image gallery
    - Create ProductSearchScreen with filters
    - Create CartScreen with checkout button
    - Create OrderHistoryScreen
    - Create OrderDetailsScreen with status tracking
    - _Requirements: 12.1, 13.1, 14.1, 16.1_

  - [ ] 22.5 Write widget tests for shops UI
    - Test product search and filtering
    - Test cart operations
    - Test checkout flow
    - _Requirements: 79.2_


- [ ] 23. Implement Services feature in Flutter
  - [ ] 23.1 Create services domain layer
    - Define ServiceCategory, ServiceProvider, Booking entities with freezed
    - Create ServicesRepository interface
    - Define use cases: GetCategories, GetProviders, CreateBooking
    - _Requirements: 17.1, 18.1_

  - [ ] 23.2 Create services data layer
    - Implement ServicesRepositoryImpl with Dio
    - Create ServicesRemoteDataSource for API calls
    - Implement provider ranking and filtering
    - _Requirements: 17.1, 20.1, 20.3_

  - [ ] 23.3 Create services presentation layer with Riverpod
    - Create ServicesViewModel for categories
    - Create ServiceProvidersViewModel with filtering
    - Create BookingsViewModel for booking management
    - _Requirements: 17.1, 18.1, 19.1_

  - [ ] 23.4 Build services UI screens
    - Create ServiceCategoriesScreen with grid layout
    - Create ServiceProvidersListScreen with ranking display
    - Create ProviderDetailsScreen with certifications and reviews
    - Create BookingFormScreen with date/time picker
    - Create BookingsHistoryScreen
    - Create BookingDetailsScreen with status tracking
    - _Requirements: 17.1, 18.1, 19.1, 20.1_

  - [ ] 23.5 Write widget tests for services UI
    - Test provider filtering and sorting
    - Test booking form validation
    - Test booking status display
    - _Requirements: 79.2_

- [ ] 24. Implement Wallet feature in Flutter
  - [ ] 24.1 Create wallet domain layer
    - Define Wallet, WalletTransaction, Transfer entities with freezed
    - Create WalletRepository interface
    - Define use cases: GetBalance, Topup, Withdraw, Transfer, Pay
    - _Requirements: 21.1, 22.1, 23.1, 24.1_

  - [ ] 24.2 Create wallet data layer
    - Implement WalletRepositoryImpl with Dio
    - Create WalletRemoteDataSource for API calls
    - Implement transaction history with pagination
    - _Requirements: 21.7, 25.1, 25.5_

  - [ ] 24.3 Create wallet presentation layer with Riverpod
    - Create WalletViewModel for balance and operations
    - Create WalletTransactionsViewModel with pagination
    - Implement payment flow integration with other modules
    - _Requirements: 21.7, 23.1, 25.1_

  - [ ] 24.4 Build wallet UI screens
    - Create WalletHomeScreen with balance display
    - Create TopupScreen with payment method selection
    - Create WithdrawScreen with bank account form
    - Create TransferScreen with recipient selection
    - Create TransactionHistoryScreen with filtering
    - Create TransactionDetailsScreen
    - _Requirements: 21.7, 22.1, 24.1, 25.1_

  - [ ] 24.5 Write widget tests for wallet UI
    - Test balance display
    - Test topup flow
    - Test transaction history filtering
    - _Requirements: 79.2_


- [ ] 25. Implement Chat feature in Flutter
  - [ ] 25.1 Create chat domain layer
    - Define Conversation, Message, TypingIndicator entities with freezed
    - Create ChatRepository interface
    - Define use cases: GetConversations, GetMessages, SendMessage
    - _Requirements: 27.1, 28.1_

  - [ ] 25.2 Create chat data layer
    - Implement ChatRepositoryImpl with Dio and Socket.IO
    - Create ChatRemoteDataSource for REST API calls
    - Implement Socket.IO integration for real-time messaging
    - _Requirements: 27.1, 28.2, 28.3_

  - [ ] 25.3 Create Socket.IO service for chat
    - Create SocketService class with connection management
    - Implement message:send, typing:start, typing:stop events
    - Create streams for message:received and typing:indicator
    - Handle reconnection and error scenarios
    - _Requirements: 26.5, 28.3, 28.4, 29.1, 29.2_

  - [ ] 25.4 Create chat presentation layer with Riverpod
    - Create ConversationsViewModel for conversation list
    - Create ChatViewModel for message history and sending
    - Integrate real-time message streams
    - Implement typing indicator state management
    - _Requirements: 27.7, 28.1, 29.3_

  - [ ] 25.5 Build chat UI screens
    - Create ConversationsListScreen with unread badges
    - Create ChatScreen with message list and input field
    - Implement typing indicator display
    - Add image/file attachment support
    - Implement message read receipts
    - _Requirements: 27.7, 28.1, 29.4_

  - [ ] 25.6 Write widget tests for chat UI
    - Test conversation list rendering
    - Test message sending
    - Test typing indicator display
    - _Requirements: 79.2_

- [ ] 26. Implement Notifications feature in Flutter
  - [ ] 26.1 Create notifications domain layer
    - Define Notification, NotificationPreferences entities with freezed
    - Create NotificationsRepository interface
    - Define use cases: GetNotifications, MarkAsRead, UpdatePreferences
    - _Requirements: 32.1, 31.1_

  - [ ] 26.2 Create notifications data layer
    - Implement NotificationsRepositoryImpl with Dio
    - Create NotificationsRemoteDataSource for API calls
    - Implement FCM token registration
    - _Requirements: 30.4, 32.1_

  - [ ] 26.3 Set up Firebase Cloud Messaging integration
    - Create FcmService class with initialization
    - Request notification permissions
    - Register FCM token with backend
    - Handle foreground, background, and terminated state messages
    - Implement notification tap handling with deep linking
    - _Requirements: 30.1, 30.2, 30.3, 33.9_

  - [ ] 26.4 Create notifications presentation layer with Riverpod
    - Create NotificationsViewModel with pagination
    - Create NotificationPreferencesViewModel
    - Implement unread count tracking
    - _Requirements: 32.6, 32.9, 31.6_

  - [ ] 26.5 Build notifications UI screens
    - Create NotificationCenterScreen with unread/all tabs
    - Create NotificationPreferencesScreen with toggle switches
    - Implement notification tap navigation to relevant screens
    - Display unread count badge on notification icon
    - _Requirements: 32.6, 32.7, 32.9, 31.6_

  - [ ] 26.6 Write widget tests for notifications UI
    - Test notification list rendering
    - Test mark as read functionality
    - Test preferences toggle
    - _Requirements: 79.2_

- [ ] 27. Checkpoint - Verify Flutter core features
  - Test all Flutter screens and navigation
  - Verify API integration and error handling
  - Test real-time features (chat, ride tracking)
  - Test push notifications on physical devices
  - Ensure all tests pass, ask the user if questions arise.


### Phase 7: Additional Flutter Features

- [ ] 28. Implement Reviews feature in Flutter
  - [ ] 28.1 Create reviews domain layer
    - Define Review, ReviewSummary entities with freezed
    - Create ReviewsRepository interface
    - Define use cases: GetReviews, SubmitReview, MarkHelpful
    - _Requirements: 34.1, 36.1, 37.1_

  - [ ] 28.2 Create reviews data layer
    - Implement ReviewsRepositoryImpl with Dio
    - Create ReviewsRemoteDataSource for API calls
    - Implement review sorting and filtering
    - _Requirements: 34.1, 36.2_

  - [ ] 28.3 Create reviews presentation layer with Riverpod
    - Create ReviewsViewModel with sorting support
    - Create PendingReviewsViewModel
    - Implement review submission with image upload
    - _Requirements: 34.1, 36.2_

  - [ ] 28.4 Build reviews UI screens
    - Create ReviewsListScreen with sorting options
    - Create ReviewFormScreen with rating stars and image picker
    - Create ReviewDetailsScreen with helpful votes
    - Display rating distribution chart
    - _Requirements: 34.1, 35.10, 36.1_

  - [ ] 28.5 Write widget tests for reviews UI
    - Test review form validation
    - Test rating display
    - Test helpful vote interaction
    - _Requirements: 79.2_

- [ ] 29. Implement Jobs feature in Flutter
  - [ ] 29.1 Create jobs domain layer
    - Define Job, JobApplication, JobContract entities with freezed
    - Create JobsRepository interface
    - Define use cases: GetJobs, SearchJobs, ApplyForJob, GetApplications
    - _Requirements: 38.1, 39.1, 40.1_

  - [ ] 29.2 Create jobs data layer
    - Implement JobsRepositoryImpl with Dio
    - Create JobsRemoteDataSource for API calls
    - Implement job search and filtering
    - _Requirements: 38.1, 41.10_

  - [ ] 29.3 Create jobs presentation layer with Riverpod
    - Create JobsViewModel with filtering
    - Create JobApplicationsViewModel
    - Create RecommendedJobsViewModel
    - _Requirements: 38.1, 39.1, 41.1_

  - [ ] 29.4 Build jobs UI screens
    - Create JobsListScreen with category filtering
    - Create JobDetailsScreen with application button
    - Create JobApplicationFormScreen
    - Create MyApplicationsScreen
    - Create JobContractDetailsScreen
    - _Requirements: 38.1, 39.1, 40.1_

  - [ ] 29.5 Write widget tests for jobs UI
    - Test job search and filtering
    - Test application form validation
    - Test contract display
    - _Requirements: 79.2_


- [ ] 30. Implement Vehicles feature in Flutter
  - [ ] 30.1 Create vehicles domain layer
    - Define Vehicle, VehicleRental entities with freezed
    - Create VehiclesRepository interface
    - Define use cases: GetVehicles, SearchVehicles, RentVehicle, GetRentals
    - _Requirements: 42.1, 43.1, 44.1_

  - [ ] 30.2 Create vehicles data layer
    - Implement VehiclesRepositoryImpl with Dio
    - Create VehiclesRemoteDataSource for API calls
    - Implement availability checking
    - _Requirements: 42.1, 43.4_

  - [ ] 30.3 Create vehicles presentation layer with Riverpod
    - Create VehiclesViewModel with filtering
    - Create VehicleRentalsViewModel
    - Implement rental cost calculation display
    - _Requirements: 42.1, 43.1, 43.6_

  - [ ] 30.4 Build vehicles UI screens
    - Create VehiclesListScreen with type and date filtering
    - Create VehicleDetailsScreen with image gallery and features
    - Create RentalBookingScreen with date picker and cost breakdown
    - Create MyRentalsScreen
    - Create RentalDetailsScreen with odometer and fuel tracking
    - _Requirements: 42.1, 43.1, 44.1_

  - [ ] 30.5 Write widget tests for vehicles UI
    - Test vehicle filtering
    - Test rental booking form
    - Test cost calculation display
    - _Requirements: 79.2_

- [ ] 31. Implement Loyalty feature in Flutter
  - [ ] 31.1 Create loyalty domain layer
    - Define LoyaltyPoints, Badge, Streak, Referral, Reward entities with freezed
    - Create LoyaltyRepository interface
    - Define use cases: GetPoints, GetBadges, GetStreak, RedeemReward
    - _Requirements: 46.1, 48.1, 47.1, 50.1_

  - [ ] 31.2 Create loyalty data layer
    - Implement LoyaltyRepositoryImpl with Dio
    - Create LoyaltyRemoteDataSource for API calls
    - _Requirements: 46.1_

  - [ ] 31.3 Create loyalty presentation layer with Riverpod
    - Create LoyaltyViewModel with points and badges
    - Create RewardsViewModel for catalog
    - Create ReferralViewModel
    - _Requirements: 46.1, 49.1, 50.1_

  - [ ] 31.4 Build loyalty UI screens
    - Create LoyaltyHomeScreen with points balance and streak
    - Create BadgesScreen with earned badges display
    - Create RewardsCatalogScreen
    - Create MyVouchersScreen
    - Create ReferralScreen with code sharing
    - _Requirements: 46.1, 48.10, 49.9, 50.12_

  - [ ] 31.5 Write widget tests for loyalty UI
    - Test points display
    - Test badge rendering
    - Test reward redemption flow
    - _Requirements: 79.2_

- [ ] 32. Implement Maps & Location services in Flutter
  - [ ] 32.1 Create maps service wrapper
    - Integrate google_maps_flutter package
    - Create MapsViewModel with map controller
    - Implement getCurrentLocation with permission handling
    - Implement marker and polyline management
    - _Requirements: 55.1, 56.1_

  - [ ] 32.2 Implement geocoding and directions
    - Create backend endpoints for geocoding and reverse geocoding
    - Create backend endpoint for directions with Google Maps API
    - Implement route drawing on map with polyline
    - Display distance and duration
    - Cache route calculations in Redis (TTL: 10 minutes)
    - _Requirements: 55.1, 55.2, 55.3, 55.5, 55.8_

  - [ ] 32.3 Implement real-time location tracking
    - Create driverLocationStream provider
    - Update driver marker position on location updates
    - Animate marker movement smoothly
    - Recalculate ETA on location changes
    - _Requirements: 56.2, 56.4, 56.5, 56.7_

  - [ ] 32.4 Write widget tests for maps integration
    - Test map initialization
    - Test marker placement
    - Test route drawing
    - _Requirements: 79.2_


- [ ] 33. Implement Provider Dashboard in Flutter
  - [ ] 33.1 Create provider domain layer
    - Define ProviderEarnings, PayoutRequest, ProviderDashboard entities with freezed
    - Create ProviderRepository interface
    - Define use cases: GetDashboard, GetEarnings, RequestPayout, UpdateAvailability
    - _Requirements: 57.1, 58.1, 60.1_

  - [ ] 33.2 Create provider data layer
    - Implement ProviderRepositoryImpl with Dio
    - Create ProviderRemoteDataSource for API calls
    - _Requirements: 57.1_

  - [ ] 33.3 Create provider presentation layer with Riverpod
    - Create ProviderDashboardViewModel
    - Create ProviderEarningsViewModel
    - Create ProviderOrdersViewModel
    - _Requirements: 57.1, 59.1_

  - [ ] 33.4 Build provider dashboard UI screens
    - Create ProviderDashboardScreen with earnings summary
    - Create EarningsDetailsScreen with period filtering
    - Create PayoutRequestScreen with bank account form
    - Create ProviderOrdersScreen with status filtering
    - Create AvailabilitySettingsScreen with online/offline toggle
    - _Requirements: 57.1, 58.1, 59.1, 60.1_

  - [ ] 33.5 Write widget tests for provider dashboard UI
    - Test earnings display
    - Test payout request form
    - Test availability toggle
    - _Requirements: 79.2_

- [ ] 34. Implement core UI components and theme
  - [ ] 34.1 Create reusable UI components
    - Create CustomButton, CustomTextField, CustomCard widgets
    - Create LoadingIndicator, ErrorWidget, EmptyStateWidget
    - Create RatingStars, PriceDisplay, StatusBadge components
    - Create ImagePicker, DateTimePicker wrappers
    - _Requirements: 73.4, 73.5_

  - [ ] 34.2 Implement app theme and styling
    - Create AppTheme with light and dark themes
    - Define color palette matching brand colors
    - Configure text styles and typography
    - Set up spacing and sizing constants
    - _Requirements: 73.1, 73.2, 73.8_

  - [ ] 34.3 Implement localization support
    - Set up intl package with ARB files
    - Create translations for English, Sinhala, Tamil
    - Implement language selection in settings
    - Format numbers, currency, and dates according to locale
    - _Requirements: 75.1, 75.2, 75.4, 75.6, 75.7_

  - [ ] 34.4 Create navigation structure with go_router
    - Define all app routes with deep linking support
    - Implement route guards for authentication
    - Set up nested navigation for bottom navigation bar
    - Handle notification tap navigation
    - _Requirements: 73.3, 33.9_

  - [ ] 34.5 Write widget tests for core components
    - Test custom button interactions
    - Test form field validation
    - Test theme switching
    - _Requirements: 79.2_

- [ ] 35. Checkpoint - Verify Flutter implementation
  - Test all Flutter features end-to-end
  - Verify state management and data flow
  - Test navigation and deep linking
  - Test localization in all three languages
  - Ensure all tests pass, ask the user if questions arise.


### Phase 8: Security Hardening & OWASP Compliance

- [ ] 36. Implement backend security measures
  - [ ] 36.1 Add security middleware and headers
    - Install and configure helmet for security headers
    - Implement CORS with whitelist of allowed origins
    - Add express-rate-limit for API rate limiting
    - Implement request size limits
    - _Requirements: 66.6, 68.7_

  - [ ] 36.2 Implement input validation and sanitization
    - Add express-validator for request validation
    - Sanitize all user inputs to prevent XSS
    - Use parameterized queries for SQL injection prevention
    - Validate file uploads (type, size, content)
    - _Requirements: 67.6, 67.7_

  - [ ] 36.3 Implement authentication security enhancements
    - Add rate limiting on auth endpoints (5 attempts per 15 minutes)
    - Implement token blacklisting in Redis for logout
    - Add refresh token rotation on use
    - Implement JWT signature verification on all protected routes
    - _Requirements: 5.5, 5.6, 6.1, 6.6, 66.5_

  - [ ] 36.4 Implement wallet security measures
    - Add transaction PIN requirement for payments over 50,000 LKR
    - Implement daily and monthly spending limits
    - Add fraud detection for unusual patterns
    - Implement two-factor authentication for large transactions
    - _Requirements: 23.12, 68.4, 68.6_

  - [ ] 36.5 Add audit logging for sensitive operations
    - Log all authentication attempts
    - Log all financial transactions
    - Log all admin actions
    - Mask sensitive data in logs
    - _Requirements: 68.8, 67.9_

  - [ ] 36.6 Perform security testing
    - Run OWASP ZAP security scan
    - Test SQL injection vulnerabilities
    - Test XSS vulnerabilities
    - Test authentication bypass attempts
    - _Requirements: 79.8_

- [ ] 37. Implement Flutter security measures
  - [ ] 37.1 Configure secure storage and certificate pinning
    - Implement certificate pinning in Dio interceptor
    - Store tokens only in flutter_secure_storage
    - Clear sensitive data on logout
    - _Requirements: 67.3, 67.4, 67.5, 69.1_

  - [ ] 37.2 Implement code obfuscation and app signing
    - Configure ProGuard/R8 for Android release builds
    - Enable code obfuscation in Flutter build
    - Remove debug logs in production builds
    - Configure app signing with proper certificates
    - _Requirements: 69.3, 69.4, 69.7_

  - [ ] 37.3 Add root/jailbreak detection
    - Integrate flutter_jailbreak_detection package
    - Display warning for rooted/jailbroken devices
    - Restrict sensitive operations on compromised devices
    - _Requirements: 69.5_

  - [ ] 37.4 Implement SSL/TLS validation
    - Validate all SSL certificates
    - Implement certificate pinning verification
    - Handle certificate validation errors
    - _Requirements: 69.6_

  - [ ] 37.5 Perform mobile security testing
    - Test certificate pinning
    - Test secure storage
    - Test code obfuscation effectiveness
    - _Requirements: 79.8_

- [ ] 38. Checkpoint - Verify security implementation
  - Review all security measures against OWASP Mobile Top 10
  - Test authentication and authorization flows
  - Verify data encryption at rest and in transit
  - Test rate limiting and input validation
  - Ensure all tests pass, ask the user if questions arise.


### Phase 9: Performance Optimization & Caching

- [ ] 39. Implement backend caching strategy
  - [ ] 39.1 Add Redis caching for frequently accessed data
    - Cache shop listings by category and city (TTL: 5 minutes)
    - Cache product search results (TTL: 2 minutes)
    - Cache provider rankings by category and city (TTL: 10 minutes)
    - Cache route calculations (TTL: 10 minutes)
    - Cache user preferences (TTL: 5 minutes)
    - _Requirements: 61.7, 63.4_

  - [ ] 39.2 Implement cache invalidation strategy
    - Invalidate shop cache on shop/product updates
    - Invalidate provider cache on provider updates
    - Invalidate user cache on preference updates
    - Implement cache warming for popular data
    - _Requirements: 63.4_

  - [ ] 39.3 Optimize database queries
    - Add indexes on all foreign keys and frequently queried columns
    - Use EXPLAIN to analyze slow queries
    - Implement query result caching
    - Add database connection pooling optimization
    - _Requirements: 61.9, 63.6, 65.3, 65.4_

  - [ ] 39.4 Implement API response compression
    - Add gzip compression middleware
    - Compress responses over 1KB
    - _Requirements: 63.1_

  - [ ] 39.5 Perform load testing
    - Use k6 or Artillery for load testing
    - Test with 1000 concurrent users
    - Measure response times under load
    - Identify and optimize bottlenecks
    - _Requirements: 62.2, 62.4, 79.7_

- [ ] 40. Implement Flutter performance optimizations
  - [ ] 40.1 Add image caching and optimization
    - Use cached_network_image for all remote images
    - Implement progressive image loading
    - Compress images before upload
    - Implement lazy loading for image lists
    - _Requirements: 63.2, 76.1, 76.2_

  - [ ] 40.2 Optimize list rendering with pagination
    - Implement infinite scroll for all lists
    - Use ListView.builder for efficient rendering
    - Add pull-to-refresh functionality
    - Implement skeleton loading states
    - _Requirements: 63.3, 73.6_

  - [ ] 40.3 Implement offline caching
    - Cache API responses locally with Hive or SharedPreferences
    - Implement offline mode for viewing cached content
    - Queue actions when offline and sync when online
    - Display network status indicator
    - _Requirements: 76.4, 76.6, 76.7, 76.8_

  - [ ] 40.4 Optimize build configuration
    - Enable code splitting and tree shaking
    - Configure AOT compilation for release builds
    - Minimize app bundle size
    - _Requirements: 63.8, 63.9_

  - [ ] 40.5 Perform Flutter performance profiling
    - Use Flutter DevTools for performance analysis
    - Identify and fix widget rebuild issues
    - Optimize memory usage
    - _Requirements: 63.10_

- [ ] 41. Checkpoint - Verify performance optimizations
  - Measure API response times (target: <200ms for 95% of requests)
  - Test app performance on low-end devices
  - Verify caching behavior
  - Test offline mode functionality
  - Ensure all tests pass, ask the user if questions arise.


### Phase 10: Integration & Third-Party Services

- [ ] 42. Integrate Google Maps API
  - [ ] 42.1 Set up Google Maps API credentials
    - Create Google Cloud project and enable Maps APIs
    - Generate API keys for Android, iOS, and backend
    - Configure API key restrictions and quotas
    - Add API keys to environment configuration
    - _Requirements: 87.1_

  - [ ] 42.2 Implement geocoding service
    - Create geocodeAddress function using Google Geocoding API
    - Create reverseGeocode function for lat/lng to address
    - Add error handling for geocoding failures
    - _Requirements: 55.1_

  - [ ] 42.3 Implement directions service
    - Create getDirections function using Google Directions API
    - Parse distance, duration, and polyline from response
    - Implement route caching in Redis
    - _Requirements: 55.1, 55.2, 55.3, 55.8_

  - [ ] 42.4 Write integration tests for Maps API
    - Test geocoding with various addresses
    - Test directions calculation
    - Test error handling for API failures
    - _Requirements: 79.3_

- [ ] 43. Integrate Payment Gateway
  - [ ] 43.1 Set up payment gateway integration
    - Choose and configure payment gateway (Stripe, PayHere, or local provider)
    - Set up API credentials and webhook endpoints
    - Implement payment initiation flow
    - _Requirements: 87.3_

  - [ ] 43.2 Implement payment webhook handler
    - Create webhook endpoint for payment confirmation
    - Verify webhook signatures for security
    - Update transaction status on payment success/failure
    - Handle payment refunds
    - _Requirements: 22.2, 22.3, 22.8_

  - [ ] 43.3 Implement PCI DSS compliance measures
    - Never store card numbers or CVV
    - Use payment gateway tokenization
    - Encrypt payment data in transit
    - _Requirements: 68.1, 68.2, 68.3, 68.9_

  - [ ] 43.4 Test payment integration
    - Test successful payment flow
    - Test failed payment handling
    - Test refund processing
    - Test webhook security
    - _Requirements: 79.3_

- [ ] 44. Integrate Firebase services
  - [ ] 44.1 Configure Firebase project
    - Create Firebase project for Android and iOS
    - Download and add configuration files
    - Enable Cloud Messaging, Analytics, and Crashlytics
    - _Requirements: 87.2_

  - [ ] 44.2 Implement Firebase Analytics
    - Track screen views
    - Track user events (ride_requested, order_placed, etc.)
    - Set user properties for segmentation
    - _Requirements: 89.1, 89.2_

  - [ ] 44.3 Implement Firebase Crashlytics
    - Initialize Crashlytics in Flutter
    - Capture and report crashes
    - Add custom logs for debugging
    - _Requirements: 80.1, 80.3_

  - [ ] 44.4 Verify Firebase integration
    - Test analytics event tracking
    - Test crash reporting
    - Test push notification delivery
    - _Requirements: 79.3_

- [ ] 45. Integrate AWS services
  - [ ] 45.1 Configure AWS S3 for file storage
    - Create S3 buckets for user uploads (images, documents)
    - Configure bucket policies and CORS
    - Implement signed URL generation for secure uploads
    - Set up CloudFront CDN for asset delivery
    - _Requirements: 87.5, 63.5_

  - [ ] 45.2 Set up AWS infrastructure
    - Provision EC2 instances for API servers
    - Set up RDS for PostgreSQL database with PostGIS extension
    - Configure ElastiCache for Redis
    - Set up Application Load Balancer
    - _Requirements: 88.1, 88.2, 88.3, 88.6_

  - [ ] 45.3 Test AWS integration
    - Test file upload to S3
    - Test CDN asset delivery
    - Test database connectivity
    - _Requirements: 79.3_

- [ ] 46. Checkpoint - Verify third-party integrations
  - Test Google Maps functionality (geocoding, directions, display)
  - Test payment gateway integration end-to-end
  - Test Firebase notifications and analytics
  - Test AWS S3 file uploads and CDN delivery
  - Ensure all tests pass, ask the user if questions arise.


### Phase 11: Testing & Quality Assurance

- [ ] 47. Implement comprehensive backend testing
  - [ ] 47.1 Write unit tests for all services
    - Test authentication service (login, register, token refresh)
    - Test rides service (fare calculation, driver matching)
    - Test shops service (search, inventory management)
    - Test wallet service (payment processing, balance checks)
    - Achieve 80% code coverage
    - _Requirements: 79.1, 79.5_

  - [ ] 47.2 Write API integration tests
    - Test all REST endpoints with supertest
    - Test authentication flows
    - Test error responses and status codes
    - Test request validation
    - _Requirements: 79.4_

  - [ ] 47.3 Write Socket.IO integration tests
    - Test WebSocket connection and authentication
    - Test real-time event delivery
    - Test room management
    - Test error handling
    - _Requirements: 79.4_

  - [ ] 47.4 Set up test database and fixtures
    - Create test database configuration
    - Implement database seeding for tests
    - Create test data factories
    - Implement database cleanup between tests
    - _Requirements: 79.1_

  - [ ] 47.5 Set up code coverage reporting
    - Configure Jest or Mocha with coverage
    - Generate coverage reports
    - Set up coverage thresholds in CI
    - _Requirements: 79.5_

- [ ] 48. Implement comprehensive Flutter testing
  - [ ] 48.1 Write unit tests for domain layer
    - Test all entities and value objects
    - Test use cases and business logic
    - Test repository interfaces with mocks
    - _Requirements: 79.1_

  - [ ] 48.2 Write unit tests for data layer
    - Test repository implementations
    - Test data source implementations
    - Test JSON serialization/deserialization
    - Test error handling and mapping
    - _Requirements: 79.1_

  - [ ] 48.3 Write unit tests for presentation layer
    - Test all ViewModels and state management
    - Test state transitions
    - Test error handling
    - _Requirements: 79.1_

  - [ ] 48.4 Write widget tests for all screens
    - Test all major screens and user interactions
    - Test form validation
    - Test navigation
    - Test loading and error states
    - _Requirements: 79.2_

  - [ ] 48.5 Write integration tests for critical flows
    - Test user registration and login flow
    - Test ride request and tracking flow
    - Test product search and checkout flow
    - Test wallet payment flow
    - Test chat messaging flow
    - _Requirements: 79.3_

  - [ ] 48.6 Set up Flutter test coverage
    - Configure test coverage reporting
    - Generate coverage reports
    - Achieve 80% coverage target
    - _Requirements: 79.5_

- [ ] 49. Implement end-to-end testing
  - [ ] 49.1 Set up E2E testing framework
    - Configure integration_test package for Flutter
    - Set up test environment with mock backend
    - Create test user accounts and data
    - _Requirements: 79.3_

  - [ ] 49.2 Write E2E tests for critical user journeys
    - Test complete ride booking journey
    - Test complete shopping and checkout journey
    - Test complete service booking journey
    - Test wallet top-up and payment journey
    - _Requirements: 79.3, 79.10_

  - [ ] 49.3 Perform manual testing
    - Test on physical Android devices
    - Test on physical iOS devices
    - Test on various screen sizes
    - Test with different network conditions
    - _Requirements: 79.9, 82.7_

- [ ] 50. Checkpoint - Verify testing coverage
  - Review test coverage reports (target: 80%)
  - Fix any failing tests
  - Document test cases and scenarios
  - Ensure all critical flows are tested
  - Ensure all tests pass, ask the user if questions arise.


### Phase 12: DevOps, Monitoring & Documentation

- [ ] 51. Set up CI/CD pipeline
  - [ ] 51.1 Create GitHub Actions workflow for backend
    - Set up Node.js CI workflow
    - Run linting and type checking
    - Run unit and integration tests
    - Build Docker image
    - Deploy to staging environment
    - _Requirements: 81.10_

  - [ ] 51.2 Create GitHub Actions workflow for Flutter
    - Set up Flutter CI workflow
    - Run flutter analyze
    - Run flutter test
    - Build APK and IPA
    - Upload artifacts
    - _Requirements: 81.10_

  - [ ] 51.3 Configure deployment automation
    - Set up staging and production environments
    - Implement blue-green deployment strategy
    - Configure environment-specific variables
    - Set up database migration automation
    - _Requirements: 70.9_

  - [ ] 51.4 Set up automated testing in CI
    - Run unit tests on every commit
    - Run integration tests on pull requests
    - Block merges if tests fail
    - _Requirements: 79.6_

- [ ] 52. Implement monitoring and observability
  - [ ] 52.1 Set up error tracking with Sentry
    - Install and configure Sentry for Node.js backend
    - Install and configure Sentry for Flutter app
    - Capture and report errors with context
    - Set up error alerting
    - _Requirements: 80.1, 71.8_

  - [ ] 52.2 Implement application logging
    - Set up structured logging with Winston or Pino
    - Log all API requests and responses
    - Log errors with stack traces
    - Implement log rotation and retention (30 days)
    - _Requirements: 80.3, 80.4, 80.11_

  - [ ] 52.3 Set up performance monitoring
    - Implement APM with New Relic or Datadog
    - Monitor API response times
    - Monitor database query performance
    - Monitor server resource usage
    - _Requirements: 80.2, 80.5, 80.6, 80.7_

  - [ ] 52.4 Create monitoring dashboards
    - Set up CloudWatch or Grafana dashboards
    - Display key metrics (requests/sec, error rate, response time)
    - Display business metrics (GMV, transactions, active users)
    - Set up alerts for critical thresholds
    - _Requirements: 80.9, 80.10_

  - [ ] 52.5 Implement health check endpoints
    - Create /health endpoint for basic health check
    - Create /health/detailed with database and Redis status
    - Implement readiness and liveness probes
    - _Requirements: 70.2_

  - [ ] 52.6 Set up uptime monitoring
    - Configure Pingdom or UptimeRobot
    - Monitor API availability
    - Set up alerts for downtime
    - _Requirements: 70.8_


- [ ] 53. Create comprehensive documentation
  - [ ] 53.1 Document API with OpenAPI/Swagger
    - Install and configure swagger-jsdoc and swagger-ui-express
    - Document all REST endpoints with request/response schemas
    - Add authentication requirements to documentation
    - Generate interactive API documentation
    - _Requirements: 78.1, 78.2_

  - [ ] 53.2 Create architecture documentation
    - Document system architecture with diagrams
    - Document database schema with ER diagrams
    - Document data flow and state management
    - Document security architecture
    - _Requirements: 78.3, 78.4_

  - [ ] 53.3 Write deployment documentation
    - Document environment setup instructions
    - Document deployment procedures for staging and production
    - Document database migration process
    - Document rollback procedures
    - _Requirements: 78.6, 78.7_

  - [ ] 53.4 Create developer onboarding guide
    - Write README with project overview
    - Document local development setup
    - Document coding standards and conventions
    - Document testing procedures
    - _Requirements: 78.5, 78.7_

  - [ ] 53.5 Maintain changelog and release notes
    - Create CHANGELOG.md with version history
    - Document breaking changes
    - Document known issues and workarounds
    - _Requirements: 78.8, 78.9_

- [ ] 54. Implement backup and disaster recovery
  - [ ] 54.1 Set up automated database backups
    - Configure daily automated backups at 2 AM
    - Implement 30-day backup retention
    - Store backups in separate AWS region
    - _Requirements: 72.8, 83.2_

  - [ ] 54.2 Implement backup restoration procedures
    - Document backup restoration steps
    - Test restoration process regularly
    - Implement point-in-time recovery
    - _Requirements: 72.9, 70.10_

  - [ ] 54.3 Create disaster recovery plan
    - Document RTO (4 hours) and RPO (1 hour) targets
    - Set up multi-region failover
    - Document incident response procedures
    - _Requirements: 70.10, 83.4_

  - [ ] 54.4 Perform disaster recovery drill
    - Simulate database failure and recovery
    - Test failover procedures
    - Measure actual RTO and RPO
    - _Requirements: 70.10_

- [ ] 55. Checkpoint - Verify DevOps and monitoring
  - Test CI/CD pipeline end-to-end
  - Verify error tracking and alerting
  - Review monitoring dashboards
  - Test backup and restoration procedures
  - Ensure all tests pass, ask the user if questions arise.


### Phase 13: Pre-Launch Preparation

- [ ] 56. Implement admin panel and moderation tools
  - [ ] 56.1 Create admin authentication and authorization
    - Implement admin role verification middleware
    - Create admin login endpoint
    - Implement admin-specific routes
    - _Requirements: 7.3, 7.4_

  - [ ] 56.2 Build admin dashboard for user management
    - Create endpoint to list all users with filtering
    - Implement user account suspension/activation
    - Implement user role management
    - Display user statistics and activity
    - _Requirements: 83.6_

  - [ ] 56.3 Build admin tools for content moderation
    - Create endpoint to review flagged content
    - Implement review moderation (hide/show reviews)
    - Implement product moderation
    - Implement chat message moderation
    - _Requirements: 83.5_

  - [ ] 56.4 Build admin tools for provider verification
    - Create endpoint to review provider applications
    - Verify driver licenses and vehicle documents
    - Verify service provider certifications
    - Approve/reject provider registrations
    - _Requirements: 83.3, 83.4_

  - [ ] 56.5 Write tests for admin functionality
    - Test admin authorization
    - Test user management operations
    - Test content moderation
    - _Requirements: 79.1, 79.4_

- [ ] 57. Implement analytics and reporting
  - [ ] 57.1 Create analytics tracking system
    - Track daily active users (DAU) and monthly active users (MAU)
    - Track new user registrations
    - Track user retention (Day 1, 7, 30)
    - Track conversion rates (install → registration → transaction)
    - _Requirements: 89.1, 89.2, 89.3, 89.7, 89.8_

  - [ ] 57.2 Implement business metrics tracking
    - Track gross merchandise value (GMV) per day/week/month
    - Track total revenue and commission by service type
    - Track average order value (AOV)
    - Track transaction volume
    - _Requirements: 90.1, 90.2, 90.3, 90.4, 90.5_

  - [ ] 57.3 Create analytics API endpoints
    - Implement GET /api/v1/admin/analytics/users
    - Implement GET /api/v1/admin/analytics/revenue
    - Implement GET /api/v1/admin/analytics/transactions
    - Support date range filtering
    - _Requirements: 89.9, 90.11_

  - [ ] 57.4 Build analytics dashboard UI
    - Create charts for user growth
    - Create charts for revenue trends
    - Create charts for transaction volume
    - Display key KPIs prominently
    - _Requirements: 89.9, 90.11_

  - [ ] 57.5 Write tests for analytics
    - Test metric calculations
    - Test date range filtering
    - Test chart data generation
    - _Requirements: 79.1_


- [ ] 58. Perform accessibility compliance
  - [ ] 58.1 Implement screen reader support
    - Add semantic labels to all interactive widgets
    - Provide text alternatives for images and icons
    - Test with TalkBack (Android) and VoiceOver (iOS)
    - _Requirements: 74.1, 74.2_

  - [ ] 58.2 Ensure touch target sizes and contrast
    - Verify all touch targets are at least 48x48 dp
    - Check color contrast ratios (WCAG AA)
    - Provide focus indicators for interactive elements
    - _Requirements: 74.4, 74.5, 74.9_

  - [ ] 58.3 Support font scaling and keyboard navigation
    - Test app with large font sizes
    - Ensure layouts adapt to font scaling
    - Support keyboard navigation where applicable
    - _Requirements: 74.3, 74.6_

  - [ ] 58.4 Perform accessibility audit
    - Use automated accessibility testing tools
    - Conduct manual accessibility testing
    - Fix identified issues
    - _Requirements: 74.10_

- [ ] 59. Optimize for low bandwidth and offline support
  - [ ] 59.1 Implement image optimization
    - Compress images before upload (max 1MB)
    - Use progressive JPEG format
    - Implement thumbnail generation
    - _Requirements: 76.1, 76.2_

  - [ ] 59.2 Implement offline mode
    - Cache essential data locally
    - Queue actions when offline
    - Sync queued actions when connection restored
    - Display offline indicator
    - _Requirements: 76.4, 76.6, 76.7, 76.8_

  - [ ] 59.3 Add low-data mode option
    - Implement settings toggle for low-data mode
    - Reduce image quality in low-data mode
    - Minimize API payload sizes
    - Disable auto-play videos
    - _Requirements: 76.9_

  - [ ] 59.4 Test on slow network conditions
    - Test with 2G/3G network simulation
    - Measure load times and optimize
    - Verify offline mode functionality
    - _Requirements: 76.1_

- [ ] 60. Implement compliance and legal requirements
  - [ ] 60.1 Create privacy policy and terms of service
    - Draft privacy policy compliant with local laws
    - Draft terms of service
    - Create in-app screens to display policies
    - Require acceptance on first launch
    - _Requirements: 83.10_

  - [ ] 60.2 Implement data export and deletion
    - Create endpoint for user data export
    - Implement GDPR-compliant data deletion
    - Allow users to download their data
    - _Requirements: 67.10_

  - [ ] 60.3 Implement KYC for providers
    - Create provider verification workflow
    - Collect and verify identity documents
    - Verify licenses and certifications
    - _Requirements: 83.3, 83.4_

  - [ ] 60.4 Implement tax calculation and reporting
    - Calculate applicable taxes on transactions
    - Generate tax reports for providers
    - Maintain transaction records for audit
    - _Requirements: 83.6, 83.5_

- [ ] 61. Checkpoint - Verify pre-launch readiness
  - Complete accessibility audit
  - Verify compliance with regulations
  - Test offline and low-bandwidth scenarios
  - Review all legal documents
  - Ensure all tests pass, ask the user if questions arise.


### Phase 14: Launch Preparation & Production Deployment

- [ ] 62. Prepare production environment
  - [ ] 62.1 Set up production infrastructure on AWS
    - Provision production EC2 instances with auto-scaling
    - Set up production RDS with Multi-AZ deployment
    - Configure production ElastiCache cluster
    - Set up production S3 buckets with versioning
    - Configure CloudFront CDN
    - _Requirements: 88.1, 88.2, 88.3, 88.4, 88.5_

  - [ ] 62.2 Configure production security
    - Set up SSL certificates with Let's Encrypt or ACM
    - Configure security groups and network ACLs
    - Enable AWS WAF for DDoS protection
    - Set up VPC with private subnets
    - _Requirements: 66.6, 88.7_

  - [ ] 62.3 Configure production database
    - Create production database with proper sizing
    - Set up read replicas for scaling
    - Configure automated backups
    - Enable encryption at rest
    - _Requirements: 65.8, 67.1, 72.8_

  - [ ] 62.4 Set up load balancer and auto-scaling
    - Configure Application Load Balancer
    - Set up auto-scaling policies based on CPU/memory
    - Configure health checks
    - Test failover scenarios
    - _Requirements: 64.3, 64.8, 70.3_

  - [ ] 62.5 Perform infrastructure testing
    - Test auto-scaling behavior
    - Test load balancer distribution
    - Test database failover
    - _Requirements: 70.4_

- [ ] 63. Perform pre-launch testing
  - [ ] 63.1 Conduct load testing
    - Test with 10,000 concurrent users
    - Test with 1,000 requests per second
    - Test with 5,000 concurrent WebSocket connections
    - Identify and fix performance bottlenecks
    - _Requirements: 62.1, 62.2, 62.3, 79.7_

  - [ ] 63.2 Conduct security penetration testing
    - Perform OWASP Top 10 vulnerability testing
    - Test authentication and authorization
    - Test SQL injection and XSS vulnerabilities
    - Test API rate limiting
    - _Requirements: 79.8_

  - [ ] 63.3 Perform user acceptance testing
    - Test all critical user flows
    - Test on various devices and OS versions
    - Gather feedback from beta testers
    - Fix critical bugs and issues
    - _Requirements: 79.9, 82.7_

  - [ ] 63.4 Conduct compatibility testing
    - Test on Android 6.0+ devices
    - Test on iOS 12.0+ devices
    - Test on various screen sizes
    - Test with different network conditions
    - _Requirements: 82.1, 82.2, 82.3, 82.4_


- [ ] 64. Prepare app store releases
  - [ ] 64.1 Prepare Android release
    - Configure app signing with release keystore
    - Update app version and build number
    - Generate signed APK and App Bundle
    - Create Play Store listing (screenshots, description, privacy policy)
    - _Requirements: 69.7, 82.1_

  - [ ] 64.2 Prepare iOS release
    - Configure app signing with distribution certificate
    - Update app version and build number
    - Generate IPA for App Store
    - Create App Store listing (screenshots, description, privacy policy)
    - _Requirements: 69.7, 82.2_

  - [ ] 64.3 Create app store assets
    - Design app icon for all sizes
    - Create screenshots for various device sizes
    - Write app description in English, Sinhala, Tamil
    - Create promotional graphics
    - _Requirements: 75.1, 82.1, 82.2_

  - [ ] 64.4 Submit apps for review
    - Submit Android app to Google Play Store
    - Submit iOS app to Apple App Store
    - Respond to review feedback if needed
    - _Requirements: 82.1, 82.2_

- [ ] 65. Launch and post-launch monitoring
  - [ ] 65.1 Deploy backend to production
    - Deploy API servers to production EC2
    - Run database migrations on production database
    - Configure environment variables
    - Verify all services are running
    - _Requirements: 70.1_

  - [ ] 65.2 Configure production monitoring
    - Enable all monitoring and alerting
    - Set up on-call rotation
    - Verify error tracking is working
    - Monitor initial traffic and performance
    - _Requirements: 80.8, 80.10_

  - [ ] 65.3 Perform smoke testing in production
    - Test user registration and login
    - Test ride request flow
    - Test product purchase flow
    - Test wallet operations
    - Test push notifications
    - _Requirements: 70.1_

  - [ ] 65.4 Monitor launch metrics
    - Track app downloads and installations
    - Track user registrations
    - Track first transactions
    - Monitor error rates and crashes
    - Track API performance and uptime
    - _Requirements: 89.1, 89.2, 89.3, 70.1_

  - [ ] 65.5 Implement gradual rollout
    - Release to 10% of users initially
    - Monitor metrics and stability
    - Gradually increase to 50%, then 100%
    - Roll back if critical issues detected
    - _Requirements: 70.1, 70.9_

- [ ] 66. Final checkpoint - Production launch complete
  - Verify all systems operational in production
  - Confirm monitoring and alerting working
  - Verify app store listings live
  - Monitor user feedback and crash reports
  - Ensure all tests pass, ask the user if questions arise.


## Notes

### Task Execution Guidelines

- Tasks marked with `*` are optional and can be skipped for faster MVP delivery
- Each task references specific requirements from the requirements document for traceability
- Checkpoints ensure incremental validation and provide opportunities to address issues
- All code should follow clean architecture principles with clear separation of concerns
- Security and performance should be considered at every step

### Technology Stack Summary

**Backend:**
- Node.js with Express.js and TypeScript
- PostgreSQL with node-postgres (pg) for database
- PostGIS extension for geospatial queries
- Redis with ioredis for caching
- Socket.IO for real-time communication
- JWT for authentication
- AWS SDK for S3 file storage
- Firebase Admin SDK for push notifications

**Frontend:**
- Flutter with Dart
- Riverpod for state management
- Dio for HTTP client
- socket_io_client for real-time features
- google_maps_flutter for maps
- firebase_messaging for push notifications
- flutter_secure_storage for secure data
- freezed and json_serializable for code generation

**Infrastructure:**
- AWS EC2 for API servers
- AWS RDS for PostgreSQL with PostGIS
- AWS ElastiCache for Redis
- AWS S3 for file storage
- AWS CloudFront for CDN
- GitHub Actions for CI/CD

### Implementation Priorities

**Critical (Must have for MVP):**
- Authentication (already implemented)
- Rides module (core value proposition)
- Wallet system (payment infrastructure)
- Basic notifications
- Maps integration

**High (Important for launch):**
- Shops module (e-commerce)
- Services module (on-demand services)
- Chat (user-provider communication)
- Reviews (trust and quality)

**Medium (Can be added post-launch):**
- Jobs marketplace
- Vehicles rentals
- Loyalty program
- AI recommendations
- Provider dashboard enhancements

**Low (Future enhancements):**
- Advanced analytics
- Admin panel features
- Gamification features
- Social features

### Testing Strategy

- Unit tests for all business logic (target: 80% coverage)
- Widget tests for all UI components
- Integration tests for critical user flows
- API tests for all endpoints
- Load testing before production launch
- Security testing with OWASP tools
- Manual testing on physical devices

### Deployment Strategy

- Staging environment for testing
- Blue-green deployment for zero downtime
- Gradual rollout (10% → 50% → 100%)
- Automated rollback on critical errors
- Database migrations with rollback capability

### Success Criteria

- 99.9% uptime (maximum 43 minutes downtime per month)
- API response time <200ms for 95% of requests
- Support 10,000 concurrent users
- 80% code coverage for tests
- OWASP Mobile Top 10 compliance
- App store approval on first submission
- Positive user feedback (4+ stars)


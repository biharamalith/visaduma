# Requirements Document: VisaDuma Super App

## Introduction

VisaDuma is a comprehensive super app for Sri Lanka that provides an all-in-one platform for ride-hailing, e-commerce, on-demand services, job marketplace, vehicle rentals, real-time chat, and integrated payments. This requirements document derives from the approved technical design and specifies what the system must do to meet business objectives and user needs.

The system targets the Sri Lankan market with multilingual support (English, Sinhala, Tamil), low-bandwidth optimization, and localized payment methods while maintaining global best practices for security, performance, and maintainability.

## Glossary

- **System**: The VisaDuma super app platform including mobile applications and backend services
- **User**: A customer who uses VisaDuma services (rides, shopping, bookings, etc.)
- **Provider**: A service provider, driver, shop owner, or vehicle owner offering services through the platform
- **Admin**: A system administrator with elevated privileges for platform management
- **Wallet**: The VisaPay digital wallet system integrated into the platform
- **Transaction**: Any financial exchange within the system (payment, top-up, withdrawal, transfer)
- **Ride**: A ride-hailing service request from pickup to dropoff location
- **Order**: An e-commerce purchase from a shop
- **Booking**: A scheduled service appointment with a service provider
- **Rental**: A vehicle rental agreement between renter and owner
- **Job**: A job posting or gig opportunity in the marketplace
- **Review**: User feedback with rating and optional text/images
- **Notification**: A push or in-app message sent to users
- **Session**: An authenticated user connection with valid access token
- **JWT**: JSON Web Token used for authentication
- **FCM**: Firebase Cloud Messaging for push notifications
- **Socket**: WebSocket connection for real-time communication
- **API**: Application Programming Interface for client-server communication
- **Database**: PostgreSQL relational database with PostGIS extension for geospatial data
- **Cache**: Redis in-memory data store for performance optimization
- **CDN**: Content Delivery Network for static asset distribution


## Business Requirements

### Requirement 1: Platform Vision and Market Position

**User Story:** As a business stakeholder, I want VisaDuma to be the leading super app in Sri Lanka, so that we can capture significant market share across multiple service verticals.

#### Acceptance Criteria

1. THE System SHALL provide ride-hailing services comparable to Uber and Grab
2. THE System SHALL provide e-commerce marketplace functionality for multi-vendor sales
3. THE System SHALL provide on-demand service booking for home and professional services
4. THE System SHALL provide job and gig marketplace functionality
5. THE System SHALL provide vehicle rental marketplace functionality
6. THE System SHALL integrate all services with a unified digital wallet (VisaPay)
7. THE System SHALL support English, Sinhala, and Tamil languages throughout the platform
8. THE System SHALL optimize for low-bandwidth conditions common in Sri Lanka

### Requirement 2: Revenue Generation and Monetization

**User Story:** As a business owner, I want multiple revenue streams, so that the platform can achieve profitability and sustainable growth.

#### Acceptance Criteria

1. WHEN a ride is completed, THE System SHALL collect 15-20% commission from the driver
2. WHEN an order is completed, THE System SHALL collect 10-15% commission from the shop owner
3. WHEN a service booking is completed, THE System SHALL collect 15% commission from the service provider
4. WHEN a vehicle rental is completed, THE System SHALL collect 10% commission from the vehicle owner
5. WHEN a user tops up their wallet, THE System SHALL charge a 2% transaction fee
6. WHEN a provider requests instant payout, THE System SHALL charge a 1% processing fee
7. THE System SHALL support premium subscription plans for users and providers
8. THE System SHALL support advertising revenue through banner ads and sponsored listings

### Requirement 3: User Acquisition and Growth

**User Story:** As a growth manager, I want viral growth features, so that we can acquire users cost-effectively and achieve rapid market penetration.

#### Acceptance Criteria

1. THE System SHALL provide a referral program with rewards for both referrer and referee
2. WHEN a user refers a new user who completes their first transaction, THE System SHALL award 100 loyalty points to the referrer
3. WHEN a new user signs up with a referral code, THE System SHALL award 50 loyalty points to the referee
4. THE System SHALL provide social sharing functionality for deals, offers, and transactions
5. THE System SHALL implement gamification features including badges, streaks, and leaderboards
6. THE System SHALL send personalized push notifications for re-engagement campaigns
7. THE System SHALL track user acquisition channels and conversion funnels


## Functional Requirements

### Module 1: Authentication & Authorization

### Requirement 4: User Registration and Account Creation

**User Story:** As a new user, I want to create an account, so that I can access VisaDuma services.

#### Acceptance Criteria

1. WHEN a user provides full name, email, phone, and password, THE System SHALL create a new user account
2. WHEN a user registers, THE System SHALL hash the password using bcrypt with cost factor 10
3. WHEN a user registers, THE System SHALL generate a unique user ID
4. WHEN a user registers with an existing email, THE System SHALL return an error message
5. WHEN a user registers, THE System SHALL assign the default role of "user"
6. WHEN a user registers, THE System SHALL generate JWT access token with 15-minute expiry
7. WHEN a user registers, THE System SHALL generate refresh token with 7-day expiry
8. WHEN a user registers, THE System SHALL store the refresh token in the database
9. THE System SHALL support registration as user, provider, or shop owner roles

### Requirement 5: User Authentication and Login

**User Story:** As a registered user, I want to log in securely, so that I can access my account and use services.

#### Acceptance Criteria

1. WHEN a user provides valid email and password, THE System SHALL authenticate the user
2. WHEN a user provides invalid credentials, THE System SHALL return an authentication error
3. WHEN a user logs in successfully, THE System SHALL return JWT access token and refresh token
4. WHEN a user logs in, THE System SHALL verify password using bcrypt comparison
5. THE System SHALL implement rate limiting of 5 login attempts per 15 minutes per IP address
6. WHEN a user exceeds rate limit, THE System SHALL block further login attempts for 15 minutes
7. THE System SHALL support biometric authentication on supported devices
8. THE System SHALL enforce HTTPS for all authentication requests

### Requirement 6: Token Management and Session Handling

**User Story:** As a user, I want my session to remain secure and automatically refresh, so that I don't have to log in repeatedly while maintaining security.

#### Acceptance Criteria

1. WHEN an access token expires, THE System SHALL accept a valid refresh token to issue a new access token
2. WHEN a refresh token is used, THE System SHALL rotate the refresh token and invalidate the old one
3. WHEN a user logs out, THE System SHALL invalidate all refresh tokens for that user
4. WHEN a user logs out, THE System SHALL add the access token to a blacklist in Redis
5. WHEN an API request includes a blacklisted token, THE System SHALL reject the request
6. THE System SHALL verify JWT signature on every protected API request
7. THE System SHALL extract user ID and role from JWT payload for authorization
8. WHEN a token is invalid or expired, THE System SHALL return 401 Unauthorized status

### Requirement 7: Role-Based Access Control

**User Story:** As a system administrator, I want role-based access control, so that users can only access features appropriate to their role.

#### Acceptance Criteria

1. THE System SHALL support four user roles: user, provider, shop_owner, and admin
2. WHEN a user attempts to access a provider-only endpoint, THE System SHALL verify the user has provider role
3. WHEN a user attempts to access a shop-owner-only endpoint, THE System SHALL verify the user has shop_owner role
4. WHEN a user attempts to access an admin-only endpoint, THE System SHALL verify the user has admin role
5. WHEN a user lacks required role, THE System SHALL return 403 Forbidden status
6. THE System SHALL enforce role checks on the server side for all protected endpoints
7. THE System SHALL allow users to have multiple roles simultaneously


### Module 2: Rides (Ride-Hailing)

### Requirement 8: Ride Request and Booking

**User Story:** As a user, I want to request a ride from my current location to a destination, so that I can travel conveniently.

#### Acceptance Criteria

1. WHEN a user provides pickup location, dropoff location, and vehicle type, THE System SHALL create a ride request
2. WHEN a ride request is created, THE System SHALL calculate estimated fare based on distance and vehicle type
3. WHEN a ride request is created, THE System SHALL calculate estimated duration using Google Maps API
4. WHEN a ride request is created, THE System SHALL set the ride status to "pending"
5. WHEN a ride request is created, THE System SHALL broadcast the request to nearby available drivers
6. THE System SHALL support four vehicle types: bike, tuk_tuk, car, and van
7. THE System SHALL support three payment methods: cash, wallet, and card
8. WHEN calculating fare, THE System SHALL apply base fare, per-kilometer rate, per-minute rate, and surge multiplier
9. WHEN calculating fare, THE System SHALL round the total to the nearest 10 LKR

### Requirement 9: Driver Matching and Assignment

**User Story:** As a user, I want to be matched with a nearby available driver quickly, so that I can start my ride without long wait times.

#### Acceptance Criteria

1. WHEN a ride request is created, THE System SHALL find drivers within 5 km radius of pickup location
2. WHEN finding drivers, THE System SHALL filter by vehicle type matching the request
3. WHEN finding drivers, THE System SHALL filter by drivers with is_available status set to true
4. WHEN multiple drivers are found, THE System SHALL rank them by distance, rating, and total rides
5. WHEN a driver accepts a ride, THE System SHALL update the ride status to "accepted"
6. WHEN a driver accepts a ride, THE System SHALL assign the driver_id to the ride record
7. WHEN a driver accepts a ride, THE System SHALL notify the user via Socket.IO
8. WHEN a driver accepts a ride, THE System SHALL set the driver's is_available status to false
9. WHEN no drivers are found within 5 km, THE System SHALL expand the search radius to 10 km
10. THE System SHALL use Haversine formula for distance calculation between coordinates

### Requirement 10: Real-Time Ride Tracking

**User Story:** As a user, I want to track my driver's location in real-time, so that I know when they will arrive and can follow the ride progress.

#### Acceptance Criteria

1. WHEN a ride is accepted, THE System SHALL establish a WebSocket connection for real-time updates
2. WHEN a driver's location changes, THE System SHALL emit location updates via Socket.IO
3. WHEN a driver's location changes, THE System SHALL throttle updates to 5-second intervals
4. WHEN a user is tracking a ride, THE System SHALL display driver location on a map
5. WHEN a user is tracking a ride, THE System SHALL display estimated time of arrival
6. WHEN a user is tracking a ride, THE System SHALL draw the route from driver to pickup location
7. WHEN a ride is in progress, THE System SHALL draw the route from current location to dropoff
8. THE System SHALL store location history in the ride_locations table
9. THE System SHALL encrypt location data in transit using WSS protocol

### Requirement 11: Ride Lifecycle Management

**User Story:** As a driver, I want to manage the ride lifecycle from acceptance to completion, so that I can provide service and receive payment.

#### Acceptance Criteria

1. WHEN a driver starts a ride, THE System SHALL update the ride status to "in_progress"
2. WHEN a driver starts a ride, THE System SHALL record the started_at timestamp
3. WHEN a driver completes a ride, THE System SHALL update the ride status to "completed"
4. WHEN a driver completes a ride, THE System SHALL record the completed_at timestamp
5. WHEN a driver completes a ride, THE System SHALL calculate the final fare based on actual distance and duration
6. WHEN a ride is completed, THE System SHALL process payment according to the selected payment method
7. WHEN a ride is cancelled by user, THE System SHALL update the ride status to "cancelled"
8. WHEN a ride is cancelled by user, THE System SHALL record the cancelled_at timestamp
9. WHEN a ride is cancelled, THE System SHALL set the driver's is_available status back to true
10. WHEN a ride is completed, THE System SHALL prompt the user to rate the driver


### Module 3: Shops (E-commerce)

### Requirement 12: Shop Management and Listings

**User Story:** As a shop owner, I want to create and manage my shop profile, so that I can sell products on the platform.

#### Acceptance Criteria

1. WHEN a shop owner creates a shop, THE System SHALL require name, description, category, address, city, and phone
2. WHEN a shop is created, THE System SHALL assign a unique shop ID
3. WHEN a shop is created, THE System SHALL set is_verified status to false pending admin verification
4. WHEN a shop is created, THE System SHALL set is_active status to true
5. WHEN a shop is created, THE System SHALL initialize rating to 5.00 and total_orders to 0
6. THE System SHALL support shop logo and banner image uploads
7. THE System SHALL allow shop owners to update their shop information
8. THE System SHALL allow shop owners to deactivate their shop
9. THE System SHALL support full-text search on shop name and description

### Requirement 13: Product Catalog Management

**User Story:** As a shop owner, I want to add and manage products in my catalog, so that customers can browse and purchase my items.

#### Acceptance Criteria

1. WHEN a shop owner adds a product, THE System SHALL require name, description, category, price, and at least one image
2. WHEN a product is added, THE System SHALL assign a unique product ID
3. WHEN a product is added, THE System SHALL set is_active status to true
4. WHEN a product is added, THE System SHALL initialize rating to 5.00 and total_sold to 0
5. THE System SHALL support multiple product images stored as JSON array
6. THE System SHALL support product specifications stored as JSON key-value pairs
7. THE System SHALL support optional discount_price for sale pricing
8. THE System SHALL track stock_quantity for inventory management
9. THE System SHALL support SKU for product identification
10. THE System SHALL allow shop owners to update product information
11. THE System SHALL allow shop owners to deactivate products
12. THE System SHALL support full-text search on product name and description

### Requirement 14: Shopping Cart and Checkout

**User Story:** As a user, I want to add products to a cart and checkout, so that I can purchase multiple items in a single transaction.

#### Acceptance Criteria

1. WHEN a user adds a product to cart, THE System SHALL create or update a cart_items record
2. WHEN a user adds a product to cart, THE System SHALL verify the product is active and in stock
3. WHEN a user updates cart quantity, THE System SHALL verify sufficient stock is available
4. WHEN a user removes a product from cart, THE System SHALL delete the cart_items record
5. WHEN a user clears their cart, THE System SHALL delete all cart_items for that user
6. WHEN a user checks out, THE System SHALL create an order with status "pending"
7. WHEN a user checks out, THE System SHALL reserve inventory for all order items
8. WHEN a user checks out, THE System SHALL calculate subtotal, delivery fee, discount, and total amount
9. WHEN a user checks out, THE System SHALL require delivery address and phone number
10. THE System SHALL support cash_on_delivery, wallet, card, and bank_transfer payment methods

### Requirement 15: Order Processing and Fulfillment

**User Story:** As a shop owner, I want to manage incoming orders and update their status, so that I can fulfill customer purchases.

#### Acceptance Criteria

1. WHEN an order payment is completed, THE System SHALL update order status to "confirmed"
2. WHEN an order is confirmed, THE System SHALL deduct inventory from stock_quantity
3. WHEN an order is confirmed, THE System SHALL record the confirmed_at timestamp
4. WHEN a shop owner marks order as shipped, THE System SHALL update status to "shipped"
5. WHEN a shop owner marks order as shipped, THE System SHALL record the shipped_at timestamp
6. WHEN a shop owner marks order as delivered, THE System SHALL update status to "delivered"
7. WHEN a shop owner marks order as delivered, THE System SHALL record the delivered_at timestamp
8. WHEN an order is delivered, THE System SHALL prompt the user to rate the shop and products
9. WHEN an order is cancelled, THE System SHALL restore inventory to stock_quantity
10. WHEN an order is cancelled, THE System SHALL process refund if payment was completed
11. THE System SHALL generate a unique order_number for each order
12. THE System SHALL support order filtering by status for both users and shop owners

### Requirement 16: Product Search and Discovery

**User Story:** As a user, I want to search for products and filter results, so that I can find items I want to purchase.

#### Acceptance Criteria

1. WHEN a user searches for products, THE System SHALL use full-text search on name and description
2. WHEN a user searches for products, THE System SHALL calculate relevance score using MATCH AGAINST
3. WHEN a user filters by category, THE System SHALL return only products in that category
4. WHEN a user filters by price range, THE System SHALL return only products within min_price and max_price
5. WHEN a user filters by shop, THE System SHALL return only products from that shop_id
6. THE System SHALL support sorting by relevance, price ascending, price descending, rating, and popularity
7. WHEN sorting by popularity, THE System SHALL order by total_sold descending
8. WHEN sorting by rating, THE System SHALL order by rating descending then total_reviews descending
9. THE System SHALL paginate search results with configurable page size
10. THE System SHALL cache search results in Redis with 2-minute TTL


### Module 4: Services (On-Demand Services)

### Requirement 17: Service Provider Registration and Profiles

**User Story:** As a service provider, I want to create a professional profile, so that customers can find and book my services.

#### Acceptance Criteria

1. WHEN a provider registers, THE System SHALL require business_name, description, category_id, and service_area
2. WHEN a provider registers, THE System SHALL set is_verified status to false pending verification
3. WHEN a provider registers, THE System SHALL set is_available status to true
4. WHEN a provider registers, THE System SHALL initialize rating to 5.00 and completion_rate to 100.00
5. THE System SHALL support hourly_rate and fixed_rates pricing models
6. THE System SHALL store service_area as JSON array of cities/districts
7. THE System SHALL store availability as JSON weekly schedule
8. THE System SHALL support provider certifications with document uploads
9. THE System SHALL allow providers to update their profile information
10. THE System SHALL track response_time as average minutes to respond to bookings

### Requirement 18: Service Booking and Scheduling

**User Story:** As a user, I want to book a service provider for a specific date and time, so that I can get professional services at my convenience.

#### Acceptance Criteria

1. WHEN a user creates a booking, THE System SHALL require provider_id, service_date, service_time, and duration_hours
2. WHEN a user creates a booking, THE System SHALL require service_address, service_city, and contact_phone
3. WHEN a user creates a booking, THE System SHALL check for scheduling conflicts with existing bookings
4. WHEN a scheduling conflict exists, THE System SHALL reject the booking request
5. WHEN a booking is created, THE System SHALL set status to "pending"
6. WHEN a booking is created, THE System SHALL calculate estimated_cost based on provider rates
7. WHEN a booking is created, THE System SHALL generate a unique booking_number
8. WHEN a booking is created, THE System SHALL send notification to the provider
9. THE System SHALL support cash, wallet, and card payment methods
10. THE System SHALL allow users to add optional description and notes to bookings

### Requirement 19: Booking Lifecycle Management

**User Story:** As a service provider, I want to manage bookings from acceptance to completion, so that I can deliver services and receive payment.

#### Acceptance Criteria

1. WHEN a provider accepts a booking, THE System SHALL update status to "confirmed"
2. WHEN a provider accepts a booking, THE System SHALL record the confirmed_at timestamp
3. WHEN a provider accepts a booking, THE System SHALL send notification to the user
4. WHEN a provider starts a booking, THE System SHALL update status to "in_progress"
5. WHEN a provider starts a booking, THE System SHALL record the started_at timestamp
6. WHEN a provider completes a booking, THE System SHALL update status to "completed"
7. WHEN a provider completes a booking, THE System SHALL record the completed_at timestamp
8. WHEN a booking is completed, THE System SHALL process payment according to payment_method
9. WHEN a booking is completed, THE System SHALL prompt user to rate the provider
10. WHEN a booking is cancelled, THE System SHALL update status to "cancelled"
11. WHEN a booking is cancelled within 24 hours of service_date, THE System SHALL apply cancellation fee
12. THE System SHALL allow users to reschedule bookings with provider approval

### Requirement 20: Provider Ranking and Discovery

**User Story:** As a user, I want to find the best service providers for my needs, so that I can book quality services.

#### Acceptance Criteria

1. WHEN a user searches for providers, THE System SHALL filter by category_id and service_area
2. WHEN a user searches for providers, THE System SHALL filter by minimum rating if specified
3. WHEN ranking providers, THE System SHALL calculate score using rating (40%), completion_rate (30%), verification status (15%), response_time (10%), and experience (5%)
4. WHEN ranking providers, THE System SHALL order results by rank_score descending
5. WHEN a provider is verified, THE System SHALL add 0.15 to their rank_score
6. WHEN a provider has response_time under 30 minutes, THE System SHALL add 0.10 to their rank_score
7. WHEN a provider has response_time over 30 minutes, THE System SHALL add 0.05 to their rank_score
8. THE System SHALL filter providers by availability on requested service_date
9. THE System SHALL cache provider rankings by category and city with 10-minute TTL
10. THE System SHALL display provider certifications and recent reviews in search results


### Module 5: Wallet System (VisaPay)

### Requirement 21: Wallet Creation and Management

**User Story:** As a user, I want a digital wallet, so that I can make seamless payments across all VisaDuma services.

#### Acceptance Criteria

1. WHEN a user registers, THE System SHALL automatically create a wallet with zero balance
2. WHEN a wallet is created, THE System SHALL set currency to LKR
3. WHEN a wallet is created, THE System SHALL set daily_limit to 100,000 LKR
4. WHEN a wallet is created, THE System SHALL set monthly_limit to 500,000 LKR
5. WHEN a wallet is created, THE System SHALL set is_active status to true
6. THE System SHALL enforce that wallet balance cannot be negative
7. THE System SHALL allow users to view their current balance and transaction history
8. THE System SHALL calculate daily_spent and monthly_spent for limit enforcement

### Requirement 22: Wallet Top-Up and Funding

**User Story:** As a user, I want to add money to my wallet, so that I can use it for payments.

#### Acceptance Criteria

1. WHEN a user initiates a top-up, THE System SHALL create a transaction with status "pending"
2. WHEN a user initiates a top-up, THE System SHALL integrate with payment gateway for card/bank payment
3. WHEN payment gateway confirms payment, THE System SHALL update transaction status to "completed"
4. WHEN payment is completed, THE System SHALL credit the wallet balance
5. WHEN payment is completed, THE System SHALL record balance_before and balance_after
6. WHEN payment is completed, THE System SHALL record the completed_at timestamp
7. THE System SHALL support card, bank_transfer, and mobile_money payment methods
8. WHEN a top-up fails, THE System SHALL update transaction status to "failed"
9. THE System SHALL charge 2% transaction fee on wallet top-ups
10. THE System SHALL store payment_ref from payment gateway for reconciliation

### Requirement 23: Wallet Payments and Transfers

**User Story:** As a user, I want to pay for services using my wallet, so that I can have fast and convenient transactions.

#### Acceptance Criteria

1. WHEN a user pays with wallet, THE System SHALL verify sufficient balance exists
2. WHEN a user pays with wallet, THE System SHALL verify daily limit is not exceeded
3. WHEN a user pays with wallet, THE System SHALL verify monthly limit is not exceeded
4. WHEN balance is insufficient, THE System SHALL reject the payment
5. WHEN daily limit is exceeded, THE System SHALL reject the payment
6. WHEN a payment is processed, THE System SHALL use database transaction with row-level locking
7. WHEN a payment is processed, THE System SHALL debit the payer wallet
8. WHEN a payment is processed, THE System SHALL credit the payee wallet
9. WHEN a payment is processed, THE System SHALL create transaction records for both parties
10. WHEN a payment is processed, THE System SHALL record reference_type and reference_id
11. THE System SHALL support peer-to-peer transfers between user wallets
12. THE System SHALL require transaction PIN for payments over 50,000 LKR

### Requirement 24: Wallet Withdrawals and Payouts

**User Story:** As a provider, I want to withdraw earnings from my wallet to my bank account, so that I can access my money.

#### Acceptance Criteria

1. WHEN a provider requests withdrawal, THE System SHALL verify sufficient balance exists
2. WHEN a provider requests withdrawal, THE System SHALL require bank account details
3. WHEN a provider requests withdrawal, THE System SHALL create a transaction with status "pending"
4. WHEN a provider requests withdrawal, THE System SHALL debit the wallet balance
5. WHEN withdrawal is processed, THE System SHALL update transaction status to "completed"
6. WHEN withdrawal is processed, THE System SHALL record the completed_at timestamp
7. THE System SHALL charge 1% fee for instant withdrawals
8. THE System SHALL process standard withdrawals within 1-3 business days with no fee
9. THE System SHALL maintain audit trail of all withdrawal transactions
10. THE System SHALL support withdrawal cancellation before processing

### Requirement 25: Transaction History and Reporting

**User Story:** As a user, I want to view my wallet transaction history, so that I can track my spending and earnings.

#### Acceptance Criteria

1. THE System SHALL display all wallet transactions ordered by created_at descending
2. THE System SHALL support filtering transactions by type (topup, payment, refund, withdrawal, transfer)
3. THE System SHALL support filtering transactions by date range
4. THE System SHALL support filtering transactions by status
5. THE System SHALL paginate transaction history with configurable page size
6. WHEN displaying a transaction, THE System SHALL show amount, type, status, balance_before, balance_after, and timestamp
7. WHEN displaying a transaction, THE System SHALL show reference information if available
8. THE System SHALL allow users to download transaction history as PDF or CSV
9. THE System SHALL calculate and display total spent, total earned, and net balance
10. THE System SHALL highlight transactions expiring soon (within 30 days)


### Module 6: Chat (Real-Time Messaging)

### Requirement 26: Real-Time Chat Infrastructure

**User Story:** As a user, I want to chat with providers in real-time, so that I can communicate about services and resolve issues quickly.

#### Acceptance Criteria

1. THE System SHALL use Socket.IO for real-time bidirectional communication
2. WHEN a user connects to chat, THE System SHALL authenticate using JWT token
3. WHEN authentication fails, THE System SHALL reject the Socket.IO connection
4. WHEN a user connects, THE System SHALL join them to their personal room identified by user_id
5. THE System SHALL maintain WebSocket connections with automatic reconnection
6. THE System SHALL support text messages, images, and file attachments
7. THE System SHALL encrypt all WebSocket connections using WSS protocol
8. THE System SHALL implement connection pooling for scalability
9. THE System SHALL handle connection timeouts and disconnections gracefully

### Requirement 27: Conversation Management

**User Story:** As a user, I want to see my conversation history, so that I can reference past communications.

#### Acceptance Criteria

1. WHEN two users first message each other, THE System SHALL create a conversations record
2. WHEN a conversation is created, THE System SHALL set participant_1 and participant_2
3. WHEN a conversation is created, THE System SHALL initialize unread_count to 0 for both participants
4. THE System SHALL support conversation types: user_provider, user_driver, user_shop, and user_user
5. WHEN a message is sent, THE System SHALL update last_message and last_message_at in conversations
6. WHEN a message is sent, THE System SHALL increment unread_count for the recipient
7. WHEN a user opens a conversation, THE System SHALL load the last 50 messages
8. WHEN a user scrolls up, THE System SHALL load older messages with pagination
9. WHEN a user marks messages as read, THE System SHALL decrement unread_count
10. THE System SHALL order conversations by last_message_at descending

### Requirement 28: Message Sending and Delivery

**User Story:** As a user, I want to send messages and know when they are delivered, so that I can communicate effectively.

#### Acceptance Criteria

1. WHEN a user sends a message, THE System SHALL validate conversation access
2. WHEN a user sends a message, THE System SHALL save the message to the database
3. WHEN a message is saved, THE System SHALL emit message:received event to the recipient
4. WHEN a message is saved, THE System SHALL emit message:sent confirmation to the sender
5. WHEN a message is sent, THE System SHALL include message_id and timestamp in confirmation
6. WHEN the recipient is offline, THE System SHALL send push notification via FCM
7. THE System SHALL support message_type of text, image, file, and system
8. WHEN sending an image, THE System SHALL require media_url to be provided
9. THE System SHALL implement rate limiting of 10 messages per minute per user
10. WHEN rate limit is exceeded, THE System SHALL reject the message with error

### Requirement 29: Typing Indicators and Presence

**User Story:** As a user, I want to see when someone is typing, so that I know they are actively responding.

#### Acceptance Criteria

1. WHEN a user starts typing, THE System SHALL emit typing:start event
2. WHEN a user stops typing, THE System SHALL emit typing:stop event
3. WHEN a typing event is received, THE System SHALL broadcast typing:indicator to the other participant
4. WHEN displaying typing indicator, THE System SHALL show "User is typing..." message
5. THE System SHALL automatically stop typing indicator after 5 seconds of inactivity
6. THE System SHALL track online/offline presence using Socket.IO connection status
7. WHEN a user connects, THE System SHALL mark them as online in Redis
8. WHEN a user disconnects, THE System SHALL mark them as offline in Redis
9. THE System SHALL display online/offline status in conversation list
10. THE System SHALL cache presence status in Redis with 5-minute TTL


### Module 7: Notifications

### Requirement 30: Push Notification Infrastructure

**User Story:** As a user, I want to receive push notifications for important events, so that I stay informed about my transactions and activities.

#### Acceptance Criteria

1. THE System SHALL use Firebase Cloud Messaging (FCM) for push notifications
2. WHEN a user installs the app, THE System SHALL request notification permissions
3. WHEN permissions are granted, THE System SHALL obtain FCM token from the device
4. WHEN FCM token is obtained, THE System SHALL register it in the fcm_tokens table
5. THE System SHALL support Android, iOS, and web device types
6. WHEN FCM token is refreshed, THE System SHALL update the token in the database
7. WHEN sending notifications, THE System SHALL use multicast messaging for efficiency
8. WHEN a notification fails to deliver, THE System SHALL deactivate the failed FCM token
9. THE System SHALL support notification channels for Android (ride, order, booking, payment, chat, system, promotion)
10. THE System SHALL include badge count in iOS notifications

### Requirement 31: Notification Preferences and Consent

**User Story:** As a user, I want to control which notifications I receive, so that I only get alerts that matter to me.

#### Acceptance Criteria

1. WHEN a user registers, THE System SHALL create notification_preferences with all types enabled by default
2. THE System SHALL support preferences for ride_updates, order_updates, booking_updates, payment_updates, chat_messages, promotions, and system_alerts
3. THE System SHALL support email_enabled and sms_enabled preferences
4. WHEN a user disables a notification type, THE System SHALL not send notifications of that type
5. WHEN sending a notification, THE System SHALL check user preferences before delivery
6. THE System SHALL allow users to update their notification preferences at any time
7. THE System SHALL respect user preferences for both push and in-app notifications
8. THE System SHALL always send critical system_alerts regardless of preferences
9. THE System SHALL cache notification preferences in Redis for performance

### Requirement 32: In-App Notification Center

**User Story:** As a user, I want to view all my notifications in one place, so that I don't miss important updates.

#### Acceptance Criteria

1. WHEN a notification is sent, THE System SHALL save it to the notifications table
2. WHEN a notification is created, THE System SHALL set is_read to false
3. THE System SHALL support notification types: ride, order, booking, payment, chat, system, and promotion
4. THE System SHALL store notification title, body, and optional data payload
5. THE System SHALL support reference_type and reference_id for linking to related entities
6. WHEN a user opens the notification center, THE System SHALL display unread notifications first
7. WHEN a user taps a notification, THE System SHALL mark it as read
8. WHEN a user taps a notification, THE System SHALL navigate to the relevant screen
9. THE System SHALL display unread count badge on the notification icon
10. THE System SHALL support "mark all as read" functionality
11. THE System SHALL paginate notifications with configurable page size
12. THE System SHALL auto-delete notifications older than 30 days

### Requirement 33: Notification Templates and Delivery

**User Story:** As a system, I want to send consistent, well-formatted notifications, so that users receive clear and actionable information.

#### Acceptance Criteria

1. WHEN a driver is assigned to a ride, THE System SHALL send "Driver Assigned" notification with driver name
2. WHEN a ride is completed, THE System SHALL send "Ride Completed" notification with fare amount
3. WHEN an order is confirmed, THE System SHALL send "Order Confirmed" notification with order number
4. WHEN an order is shipped, THE System SHALL send "Order Shipped" notification with order number
5. WHEN a booking is confirmed, THE System SHALL send "Booking Confirmed" notification with service name and date
6. WHEN a payment succeeds, THE System SHALL send "Payment Successful" notification with amount
7. WHEN a new message arrives, THE System SHALL send notification with sender name and message preview
8. WHEN a user is offline, THE System SHALL queue notifications for delivery when they come online
9. THE System SHALL include deep link data in notifications for navigation
10. THE System SHALL support notification localization based on user language preference


### Module 8: Reviews & Ratings

### Requirement 34: Review Submission and Validation

**User Story:** As a user, I want to rate and review services I've used, so that I can share my experience and help others make informed decisions.

#### Acceptance Criteria

1. WHEN a user submits a review, THE System SHALL require reviewable_type and reviewable_id
2. WHEN a user submits a review, THE System SHALL require rating between 1 and 5 stars
3. WHEN a user submits a review, THE System SHALL verify the user has completed a transaction for the reviewable entity
4. WHEN a user has not completed a transaction, THE System SHALL reject the review
5. WHEN a user submits a review, THE System SHALL set is_verified to true if transaction is verified
6. THE System SHALL support optional title, comment, and images in reviews
7. THE System SHALL support reviewable types: ride, order, booking, vehicle, and shop
8. THE System SHALL allow only one review per user per reviewable entity
9. WHEN a duplicate review is submitted, THE System SHALL update the existing review
10. THE System SHALL set is_visible to true by default for all reviews
11. THE System SHALL implement rate limiting of 5 reviews per day per user

### Requirement 35: Rating Calculation and Aggregation

**User Story:** As a provider, I want my rating to accurately reflect customer feedback, so that my reputation is fairly represented.

#### Acceptance Criteria

1. WHEN a review is submitted, THE System SHALL recalculate the average rating for the reviewable entity
2. WHEN calculating average rating, THE System SHALL include only visible reviews
3. WHEN calculating average rating, THE System SHALL round to 2 decimal places
4. WHEN calculating average rating, THE System SHALL update the rating field in the entity table
5. WHEN a review is submitted for a ride, THE System SHALL update the driver rating
6. WHEN a review is submitted for an order, THE System SHALL update the shop rating
7. WHEN a review is submitted for a booking, THE System SHALL update the service provider rating
8. WHEN a review is submitted for a vehicle, THE System SHALL update the vehicle rating
9. THE System SHALL update total_reviews count for the reviewable entity
10. THE System SHALL calculate rating distribution (5-star, 4-star, 3-star, 2-star, 1-star counts)

### Requirement 36: Review Display and Sorting

**User Story:** As a user, I want to read reviews from other customers, so that I can make informed decisions about services and products.

#### Acceptance Criteria

1. WHEN displaying reviews, THE System SHALL show only reviews with is_visible set to true
2. THE System SHALL support sorting by recent, helpful, rating_high, and rating_low
3. WHEN sorting by recent, THE System SHALL order by created_at descending
4. WHEN sorting by helpful, THE System SHALL order by helpful_count descending then created_at descending
5. WHEN sorting by rating_high, THE System SHALL order by rating descending then created_at descending
6. WHEN sorting by rating_low, THE System SHALL order by rating ascending then created_at descending
7. WHEN displaying a review, THE System SHALL show user name, avatar, rating, title, comment, images, and timestamp
8. WHEN displaying a review, THE System SHALL show provider response if available
9. THE System SHALL paginate reviews with configurable page size
10. THE System SHALL cache review lists by reviewable entity with 5-minute TTL

### Requirement 37: Review Interactions and Moderation

**User Story:** As a user, I want to mark reviews as helpful and report inappropriate content, so that the community can identify quality feedback.

#### Acceptance Criteria

1. WHEN a user marks a review as helpful, THE System SHALL create a review_helpful_votes record
2. WHEN a user marks a review as helpful, THE System SHALL increment helpful_count
3. WHEN a user unmarks a review as helpful, THE System SHALL delete the review_helpful_votes record
4. WHEN a user unmarks a review as helpful, THE System SHALL decrement helpful_count
5. THE System SHALL allow only one helpful vote per user per review
6. THE System SHALL allow providers to respond to reviews about their services
7. WHEN a provider responds to a review, THE System SHALL create a review_responses record
8. WHEN a provider responds to a review, THE System SHALL notify the review author
9. THE System SHALL allow review authors to edit their reviews within 7 days
10. THE System SHALL allow review authors to delete their reviews
11. THE System SHALL support review reporting for spam, abuse, or inappropriate content
12. WHEN a review is reported, THE System SHALL flag it for admin moderation


### Module 9: Jobs & Gig Marketplace

### Requirement 38: Job Posting and Management

**User Story:** As an employer, I want to post job opportunities, so that I can find qualified workers for my projects.

#### Acceptance Criteria

1. WHEN an employer posts a job, THE System SHALL require title, description, category_id, and job_type
2. WHEN an employer posts a job, THE System SHALL require budget_type (hourly, fixed, or monthly)
3. WHEN an employer posts a job, THE System SHALL support optional budget_min and budget_max
4. WHEN an employer posts a job, THE System SHALL support optional location and is_remote flag
5. WHEN an employer posts a job, THE System SHALL support required_skills as JSON array
6. WHEN an employer posts a job, THE System SHALL require experience_level (entry, intermediate, or expert)
7. WHEN a job is posted, THE System SHALL set status to "open"
8. WHEN a job is posted, THE System SHALL initialize applications_count and views_count to 0
9. THE System SHALL support optional expires_at date for job listings
10. THE System SHALL allow employers to edit their job postings
11. THE System SHALL allow employers to close job postings
12. THE System SHALL implement rate limiting of 10 job posts per day per employer

### Requirement 39: Job Application and Proposal Submission

**User Story:** As a freelancer, I want to apply for jobs with my proposal, so that I can win projects and earn income.

#### Acceptance Criteria

1. WHEN a worker applies for a job, THE System SHALL require cover_letter
2. WHEN a worker applies for a job, THE System SHALL support optional proposed_rate and proposed_duration
3. WHEN a worker applies for a job, THE System SHALL support optional portfolio_links as JSON array
4. WHEN a worker applies for a job, THE System SHALL support optional attachments as JSON array
5. WHEN an application is submitted, THE System SHALL set status to "pending"
6. WHEN an application is submitted, THE System SHALL increment applications_count for the job
7. THE System SHALL allow only one application per worker per job
8. WHEN a duplicate application is submitted, THE System SHALL update the existing application
9. THE System SHALL allow workers to withdraw their applications
10. WHEN an application is withdrawn, THE System SHALL update status to "withdrawn"
11. THE System SHALL notify the employer when a new application is received

### Requirement 40: Application Review and Hiring

**User Story:** As an employer, I want to review applications and hire workers, so that I can start my projects with qualified talent.

#### Acceptance Criteria

1. WHEN an employer views applications, THE System SHALL display all applications for their jobs
2. THE System SHALL allow employers to filter applications by status
3. THE System SHALL allow employers to update application status to shortlisted, accepted, or rejected
4. WHEN an application is accepted, THE System SHALL create a job_contracts record
5. WHEN a contract is created, THE System SHALL set status to "active"
6. WHEN a contract is created, THE System SHALL record agreed_rate, rate_type, and start_date
7. WHEN a contract is created, THE System SHALL update job status to "in_progress"
8. WHEN a contract is created, THE System SHALL notify the worker
9. THE System SHALL allow employers to create milestones for fixed-price contracts
10. THE System SHALL reject other applications when a job is filled

### Requirement 41: Job Matching and Recommendations

**User Story:** As a freelancer, I want to see jobs that match my skills, so that I can find relevant opportunities quickly.

#### Acceptance Criteria

1. WHEN generating job recommendations, THE System SHALL match user skills with required_skills
2. WHEN generating job recommendations, THE System SHALL calculate skill match score (40% weight)
3. WHEN generating job recommendations, THE System SHALL match experience_level (20% weight)
4. WHEN generating job recommendations, THE System SHALL match job_type preferences (20% weight)
5. WHEN generating job recommendations, THE System SHALL match location preferences (10% weight)
6. WHEN generating job recommendations, THE System SHALL match budget requirements (10% weight)
7. WHEN calculating match score, THE System SHALL require minimum score of 0.3
8. WHEN displaying recommendations, THE System SHALL order by match_score descending
9. THE System SHALL cache job recommendations per user with 10-minute TTL
10. THE System SHALL support full-text search on job title and description


### Module 10: Vehicles (Rentals & Listings)

### Requirement 42: Vehicle Listing and Management

**User Story:** As a vehicle owner, I want to list my vehicle for rent, so that I can earn income from my asset.

#### Acceptance Criteria

1. WHEN an owner lists a vehicle, THE System SHALL require vehicle_type, make, model, year, and license_plate
2. WHEN an owner lists a vehicle, THE System SHALL require transmission type (manual or automatic)
3. WHEN an owner lists a vehicle, THE System SHALL require fuel_type (petrol, diesel, electric, or hybrid)
4. WHEN an owner lists a vehicle, THE System SHALL require at least one image
5. WHEN an owner lists a vehicle, THE System SHALL require daily_rate and security_deposit
6. WHEN an owner lists a vehicle, THE System SHALL support optional hourly_rate, weekly_rate, and monthly_rate
7. WHEN an owner lists a vehicle, THE System SHALL support optional mileage_limit and extra_km_charge
8. WHEN a vehicle is listed, THE System SHALL set is_available to true
9. WHEN a vehicle is listed, THE System SHALL set is_verified to false pending verification
10. WHEN a vehicle is listed, THE System SHALL initialize rating to 5.00 and total_rentals to 0
11. THE System SHALL verify license_plate is unique
12. THE System SHALL support vehicle features stored as JSON array

### Requirement 43: Vehicle Rental Booking

**User Story:** As a user, I want to rent a vehicle for specific dates, so that I can have transportation for my needs.

#### Acceptance Criteria

1. WHEN a user books a rental, THE System SHALL require vehicle_id, start_date, and end_date
2. WHEN a user books a rental, THE System SHALL require pickup_location
3. WHEN a user books a rental, THE System SHALL require rental_type (hourly, daily, weekly, or monthly)
4. WHEN a user books a rental, THE System SHALL check vehicle availability for the requested dates
5. WHEN the vehicle is not available, THE System SHALL reject the booking
6. WHEN a rental is booked, THE System SHALL calculate base_amount based on rental_type and duration
7. WHEN a rental is booked, THE System SHALL calculate insurance_amount if requested
8. WHEN a rental is booked, THE System SHALL add security_deposit to total_amount
9. WHEN a rental is booked, THE System SHALL set status to "pending"
10. WHEN a rental is booked, THE System SHALL generate a unique rental_number
11. WHEN a rental is booked, THE System SHALL create vehicle_availability record to block the dates
12. THE System SHALL support optional dropoff_location different from pickup_location

### Requirement 44: Rental Lifecycle Management

**User Story:** As a vehicle owner, I want to manage rentals from confirmation to completion, so that I can provide service and receive payment.

#### Acceptance Criteria

1. WHEN an owner confirms a rental, THE System SHALL update status to "confirmed"
2. WHEN an owner confirms a rental, THE System SHALL record confirmed_at timestamp
3. WHEN an owner confirms a rental, THE System SHALL charge security_deposit to user wallet
4. WHEN a rental starts, THE System SHALL update status to "active"
5. WHEN a rental starts, THE System SHALL record odometer_start and fuel_level_start
6. WHEN a rental starts, THE System SHALL record started_at timestamp
7. WHEN a rental completes, THE System SHALL update status to "completed"
8. WHEN a rental completes, THE System SHALL record odometer_end and fuel_level_end
9. WHEN a rental completes, THE System SHALL calculate extra_charges for excess mileage
10. WHEN a rental completes, THE System SHALL process final payment
11. WHEN a rental completes, THE System SHALL refund security_deposit minus any damages
12. WHEN a rental is cancelled, THE System SHALL release the vehicle_availability block
13. THE System SHALL prompt user to rate the vehicle after rental completion

### Requirement 45: Vehicle Availability Management

**User Story:** As a vehicle owner, I want to manage my vehicle's availability, so that I can control when it's available for rent.

#### Acceptance Criteria

1. WHEN a rental is confirmed, THE System SHALL create vehicle_availability record with reason "rental"
2. WHEN an owner blocks dates for maintenance, THE System SHALL create vehicle_availability record with reason "maintenance"
3. WHEN an owner manually blocks dates, THE System SHALL create vehicle_availability record with reason "owner_blocked"
4. WHEN checking availability, THE System SHALL query vehicle_availability for overlapping date ranges
5. WHEN date ranges overlap, THE System SHALL consider the vehicle unavailable
6. WHEN a rental is cancelled, THE System SHALL delete the corresponding vehicle_availability record
7. THE System SHALL allow owners to view their vehicle's availability calendar
8. THE System SHALL prevent double-booking by checking availability before confirming rentals
9. THE System SHALL use database transactions with row-level locking for availability checks


### Module 11: Loyalty & Rewards

### Requirement 46: Loyalty Points System

**User Story:** As a user, I want to earn loyalty points for my activities, so that I can redeem them for rewards and benefits.

#### Acceptance Criteria

1. WHEN a user completes a ride, THE System SHALL award 10 base points plus 1 point per 100 LKR spent
2. WHEN a user completes an order, THE System SHALL award 20 base points plus 5 points per 1000 LKR spent
3. WHEN a user completes a booking, THE System SHALL award 15 base points plus 2 points per 500 LKR spent
4. WHEN a user submits a review, THE System SHALL award 5 points
5. WHEN a user submits a review with photo, THE System SHALL award 10 points
6. WHEN a referee completes their first transaction, THE System SHALL award 100 points to the referrer
7. WHEN points are awarded, THE System SHALL set expiry date to 1 year from award date
8. WHEN points are awarded, THE System SHALL calculate and store the new balance
9. THE System SHALL support action types: ride, order, booking, referral, review, streak, and bonus
10. THE System SHALL store reference_type and reference_id for traceability

### Requirement 47: Streak Tracking and Bonuses

**User Story:** As a user, I want to maintain activity streaks, so that I can earn bonus points for consistent usage.

#### Acceptance Criteria

1. WHEN a user completes any transaction, THE System SHALL update their streak
2. WHEN a user's last activity was yesterday, THE System SHALL increment current_streak by 1
3. WHEN a user's last activity was today, THE System SHALL not change current_streak
4. WHEN a user's last activity was more than 1 day ago, THE System SHALL reset current_streak to 1
5. WHEN current_streak exceeds longest_streak, THE System SHALL update longest_streak
6. WHEN a user reaches 7-day streak, THE System SHALL award 50 bonus points
7. WHEN a user reaches 30-day streak, THE System SHALL award 200 bonus points
8. WHEN a user reaches 100-day streak, THE System SHALL award 1000 bonus points
9. THE System SHALL display current streak and longest streak in user profile
10. THE System SHALL send notification when user is about to break their streak

### Requirement 48: Badges and Achievements

**User Story:** As a user, I want to earn badges for milestones, so that I can showcase my achievements and status.

#### Acceptance Criteria

1. WHEN a user completes their first ride, THE System SHALL award "first_ride" badge
2. WHEN a user completes 50 rides, THE System SHALL award "frequent_rider" badge level 1
3. WHEN a user completes 100 rides, THE System SHALL upgrade "frequent_rider" badge to level 2
4. WHEN a user completes 50 orders, THE System SHALL award "top_shopper" badge level 1
5. WHEN a user completes 50 bookings, THE System SHALL award "service_pro" badge level 1
6. WHEN a user submits 20 reviews, THE System SHALL award "reviewer" badge level 1
7. WHEN a user refers 10 users, THE System SHALL award "referrer" badge level 1
8. WHEN a user reaches 30-day streak, THE System SHALL award "streak_master" badge level 1
9. THE System SHALL allow only one badge per type per user with level progression
10. THE System SHALL display earned badges in user profile
11. THE System SHALL send notification when a new badge is earned

### Requirement 49: Referral Program

**User Story:** As a user, I want to refer friends and earn rewards, so that I can benefit from growing the platform.

#### Acceptance Criteria

1. WHEN a user registers, THE System SHALL generate a unique referral_code
2. WHEN a new user signs up with a referral code, THE System SHALL create a referrals record
3. WHEN a referral is created, THE System SHALL set status to "pending"
4. WHEN a referral is created, THE System SHALL link referrer_id and referee_id
5. WHEN a referee completes their first transaction, THE System SHALL update referral status to "completed"
6. WHEN a referral is completed, THE System SHALL award 100 points to referrer
7. WHEN a referral is completed, THE System SHALL award 50 points to referee
8. WHEN a referral is completed, THE System SHALL record completed_at timestamp
9. THE System SHALL display referral code in user profile
10. THE System SHALL display referral statistics (total referrals, completed referrals, pending rewards)
11. THE System SHALL support social sharing of referral codes

### Requirement 50: Rewards Catalog and Redemption

**User Story:** As a user, I want to redeem my loyalty points for rewards, so that I can get value from my accumulated points.

#### Acceptance Criteria

1. THE System SHALL maintain a rewards_catalog with available rewards
2. WHEN displaying rewards, THE System SHALL show only rewards with is_active set to true
3. WHEN displaying rewards, THE System SHALL show only rewards that have not expired
4. WHEN a user redeems a reward, THE System SHALL verify sufficient points balance
5. WHEN points are insufficient, THE System SHALL reject the redemption
6. WHEN a reward is redeemed, THE System SHALL deduct points_required from user balance
7. WHEN a reward is redeemed, THE System SHALL create a reward_redemptions record
8. WHEN a reward is redeemed, THE System SHALL generate a unique voucher_code if applicable
9. WHEN a reward is redeemed, THE System SHALL set expiry date for the voucher
10. WHEN a reward is redeemed, THE System SHALL set status to "active"
11. THE System SHALL support reward types: discount, voucher, cashback, and free_service
12. THE System SHALL allow users to view their active vouchers
13. WHEN a voucher is used, THE System SHALL update status to "used"
14. WHEN a voucher expires, THE System SHALL update status to "expired"


### Module 12: AI Recommendations

### Requirement 51: User Interaction Tracking

**User Story:** As the system, I want to track user interactions, so that I can learn preferences and provide personalized recommendations.

#### Acceptance Criteria

1. WHEN a user views an entity, THE System SHALL create a user_interactions record with type "view"
2. WHEN a user clicks an entity, THE System SHALL create a user_interactions record with type "click"
3. WHEN a user searches, THE System SHALL create a user_interactions record with type "search"
4. WHEN a user books a service, THE System SHALL create a user_interactions record with type "book"
5. WHEN a user purchases a product, THE System SHALL create a user_interactions record with type "purchase"
6. WHEN a user submits a review, THE System SHALL create a user_interactions record with type "review"
7. THE System SHALL store entity_type and entity_id for all interactions
8. THE System SHALL support optional metadata as JSON for additional context
9. THE System SHALL index interactions by user_id and created_at for efficient querying
10. THE System SHALL retain interaction history for 90 days

### Requirement 52: Personalized Recommendations

**User Story:** As a user, I want to see personalized recommendations, so that I can discover services and products relevant to my interests.

#### Acceptance Criteria

1. THE System SHALL generate recommendations using hybrid approach combining collaborative and content-based filtering
2. WHEN generating recommendations, THE System SHALL check cache first
3. WHEN cache miss occurs, THE System SHALL calculate recommendations and cache for 1 hour
4. WHEN calculating recommendations, THE System SHALL find similar users based on common interactions
5. WHEN calculating recommendations, THE System SHALL use Jaccard similarity for user matching
6. WHEN calculating recommendations, THE System SHALL require minimum 3 common interactions for similarity
7. WHEN calculating recommendations, THE System SHALL combine collaborative filtering (60% weight) and content-based filtering (40% weight)
8. WHEN calculating content-based scores, THE System SHALL match user preferences with entity attributes
9. WHEN calculating content-based scores, THE System SHALL weight rating (40%), popularity (30%), and category match (30%)
10. THE System SHALL return top 50 recommendations ordered by combined score
11. THE System SHALL support recommendation types: services, products, vehicles, and jobs

### Requirement 53: User Preference Learning

**User Story:** As the system, I want to learn user preferences over time, so that recommendations become more accurate.

#### Acceptance Criteria

1. THE System SHALL maintain user_preferences for each user
2. WHEN a user interacts with entities, THE System SHALL update preferred_categories
3. WHEN a user interacts with entities, THE System SHALL update preferred_locations
4. WHEN a user makes purchases, THE System SHALL infer price_sensitivity (low, medium, high)
5. WHEN a user has multiple low-price purchases, THE System SHALL set price_sensitivity to "high"
6. WHEN a user has multiple high-price purchases, THE System SHALL set price_sensitivity to "low"
7. THE System SHALL track service_frequency as JSON for usage patterns
8. THE System SHALL update user_preferences automatically based on interaction history
9. THE System SHALL use preferences to filter and rank recommendations
10. THE System SHALL update last_updated timestamp when preferences change


### Module 13: Maps & Live Tracking

### Requirement 54: Location Services and Geocoding

**User Story:** As a user, I want to search for addresses and see them on a map, so that I can easily specify pickup and dropoff locations.

#### Acceptance Criteria

1. THE System SHALL integrate with Google Maps API for geocoding services
2. WHEN a user enters an address, THE System SHALL convert it to latitude and longitude coordinates
3. WHEN geocoding succeeds, THE System SHALL return formatted_address, lat, and lng
4. WHEN geocoding fails, THE System SHALL return an error message
5. THE System SHALL support reverse geocoding to convert coordinates to addresses
6. WHEN reverse geocoding, THE System SHALL return the formatted address for given coordinates
7. THE System SHALL cache geocoding results in Redis with 24-hour TTL
8. THE System SHALL display locations on Google Maps with markers
9. THE System SHALL support map interactions (zoom, pan, marker placement)
10. THE System SHALL request location permissions from the user

### Requirement 55: Route Calculation and Display

**User Story:** As a user, I want to see the route between two locations, so that I can understand the journey before booking.

#### Acceptance Criteria

1. WHEN a user selects pickup and dropoff locations, THE System SHALL calculate the route using Google Directions API
2. WHEN calculating route, THE System SHALL return distance in kilometers
3. WHEN calculating route, THE System SHALL return duration in minutes
4. WHEN calculating route, THE System SHALL return encoded polyline for route visualization
5. WHEN route is calculated, THE System SHALL draw the polyline on the map
6. WHEN route is calculated, THE System SHALL display distance and duration to the user
7. THE System SHALL use the route distance and duration for fare calculation
8. THE System SHALL cache route calculations in Redis with 10-minute TTL
9. WHEN route calculation fails, THE System SHALL display an error message
10. THE System SHALL support route recalculation when locations change

### Requirement 56: Real-Time Location Tracking

**User Story:** As a user, I want to track my driver's location in real-time, so that I can see their progress and estimated arrival time.

#### Acceptance Criteria

1. WHEN a ride is accepted, THE System SHALL start tracking driver location
2. WHEN driver location changes, THE System SHALL emit location updates via Socket.IO
3. WHEN location updates are emitted, THE System SHALL include lat, lng, and timestamp
4. WHEN location updates are received, THE System SHALL update the driver marker on the map
5. WHEN location updates are received, THE System SHALL recalculate ETA to pickup/dropoff
6. THE System SHALL throttle location updates to maximum 1 update per 5 seconds
7. THE System SHALL animate marker movement smoothly between location updates
8. THE System SHALL store location history in ride_locations table
9. THE System SHALL display route from driver's current location to destination
10. WHEN ride is completed, THE System SHALL stop tracking driver location


### Module 14: Provider Dashboard

### Requirement 57: Earnings Dashboard and Analytics

**User Story:** As a provider, I want to view my earnings and analytics, so that I can track my business performance.

#### Acceptance Criteria

1. THE System SHALL display today's earnings for the provider
2. THE System SHALL display this week's earnings for the provider
3. THE System SHALL display this month's earnings for the provider
4. THE System SHALL display available balance for withdrawal
5. THE System SHALL display pending orders/bookings count
6. THE System SHALL display active orders/bookings count
7. THE System SHALL display provider rating and completion rate
8. THE System SHALL support filtering earnings by period (day, week, month, year)
9. THE System SHALL display earnings breakdown by service type
10. THE System SHALL display commission deductions separately from gross earnings
11. THE System SHALL support exporting earnings reports as PDF or CSV

### Requirement 58: Payout Management

**User Story:** As a provider, I want to request payouts of my earnings, so that I can access my money.

#### Acceptance Criteria

1. WHEN a provider requests payout, THE System SHALL verify sufficient available balance
2. WHEN a provider requests payout, THE System SHALL require bank account details
3. WHEN a provider requests payout, THE System SHALL create a payout_requests record with status "pending"
4. WHEN a payout is requested, THE System SHALL deduct the amount from available balance
5. WHEN a payout is processed, THE System SHALL update status to "completed"
6. WHEN a payout is processed, THE System SHALL record processed_at timestamp
7. THE System SHALL charge 1% fee for instant payouts (processed within 24 hours)
8. THE System SHALL process standard payouts within 1-3 business days with no fee
9. THE System SHALL allow providers to view payout history
10. THE System SHALL support payout cancellation before processing
11. WHEN a payout is rejected, THE System SHALL restore the amount to available balance

### Requirement 59: Order and Booking Management

**User Story:** As a provider, I want to manage incoming orders and bookings, so that I can fulfill customer requests efficiently.

#### Acceptance Criteria

1. THE System SHALL display all pending orders/bookings for the provider
2. THE System SHALL display all active orders/bookings for the provider
3. THE System SHALL display completed orders/bookings history
4. THE System SHALL support filtering by status (pending, confirmed, in_progress, completed, cancelled)
5. THE System SHALL support sorting by date (newest first, oldest first)
6. THE System SHALL send real-time notifications for new orders/bookings
7. THE System SHALL allow providers to accept or reject pending requests
8. THE System SHALL allow providers to update order/booking status
9. THE System SHALL display customer contact information for confirmed orders/bookings
10. THE System SHALL display order/booking details including items, amounts, and delivery information

### Requirement 60: Availability Management

**User Story:** As a provider, I want to control my availability, so that I only receive requests when I'm ready to work.

#### Acceptance Criteria

1. THE System SHALL provide an online/offline toggle for providers
2. WHEN a provider goes online, THE System SHALL set is_available to true
3. WHEN a provider goes offline, THE System SHALL set is_available to false
4. WHEN a provider is offline, THE System SHALL not send them new requests
5. THE System SHALL allow providers to set their working schedule
6. THE System SHALL store working schedule as JSON weekly schedule
7. THE System SHALL allow providers to block specific dates for breaks or maintenance
8. THE System SHALL display current availability status prominently in the dashboard
9. THE System SHALL track total online hours for analytics
10. THE System SHALL send reminder notifications if provider has been offline for extended periods


## Non-Functional Requirements

### Performance Requirements

### Requirement 61: Response Time and Latency

**User Story:** As a user, I want the app to respond quickly, so that I can complete tasks efficiently without frustration.

#### Acceptance Criteria

1. WHEN a user makes an API request, THE System SHALL respond within 200 milliseconds for 95% of requests
2. WHEN a user makes an API request, THE System SHALL respond within 500 milliseconds for 99% of requests
3. WHEN a user loads a screen, THE System SHALL display content within 1 second
4. WHEN a user searches for products or services, THE System SHALL return results within 300 milliseconds
5. WHEN a user sends a chat message, THE System SHALL deliver it within 100 milliseconds
6. WHEN a user receives a real-time update, THE System SHALL display it within 200 milliseconds
7. THE System SHALL use Redis caching to reduce database query latency
8. THE System SHALL use CDN for static assets to reduce load times
9. THE System SHALL implement database query optimization with proper indexes
10. THE System SHALL use connection pooling to reduce database connection overhead

### Requirement 62: Throughput and Concurrency

**User Story:** As a business stakeholder, I want the system to handle many concurrent users, so that we can scale to meet demand.

#### Acceptance Criteria

1. THE System SHALL support at least 10,000 concurrent users
2. THE System SHALL support at least 1,000 requests per second
3. THE System SHALL support at least 5,000 concurrent WebSocket connections
4. WHEN load increases, THE System SHALL maintain response times within acceptable limits
5. THE System SHALL use horizontal scaling to handle increased load
6. THE System SHALL use load balancing to distribute traffic across multiple servers
7. THE System SHALL use database read replicas to distribute read queries
8. THE System SHALL implement rate limiting to prevent abuse and ensure fair resource allocation
9. THE System SHALL monitor throughput and alert when thresholds are exceeded
10. THE System SHALL perform load testing regularly to validate capacity

### Requirement 63: Resource Optimization

**User Story:** As a developer, I want the system to use resources efficiently, so that we can minimize infrastructure costs.

#### Acceptance Criteria

1. THE System SHALL compress API responses using gzip
2. THE System SHALL implement lazy loading for images and lists
3. THE System SHALL use pagination to limit data transfer
4. THE System SHALL cache frequently accessed data in Redis
5. THE System SHALL use CDN for static assets to reduce server load
6. THE System SHALL implement database query optimization to reduce CPU usage
7. THE System SHALL use connection pooling to reduce memory overhead
8. THE System SHALL implement code splitting and tree shaking in Flutter builds
9. THE System SHALL use AOT compilation for release builds to improve performance
10. THE System SHALL monitor resource usage and optimize bottlenecks

### Scalability Requirements

### Requirement 64: Horizontal Scalability

**User Story:** As a system architect, I want the system to scale horizontally, so that we can handle growth without major architectural changes.

#### Acceptance Criteria

1. THE System SHALL use stateless API servers that can be scaled horizontally
2. THE System SHALL store session data in Redis, not in server memory
3. THE System SHALL use load balancer to distribute traffic across multiple API servers
4. THE System SHALL support adding new API servers without downtime
5. THE System SHALL use database read replicas to scale read operations
6. THE System SHALL use database sharding if needed for write scalability
7. THE System SHALL use message queues for asynchronous processing
8. THE System SHALL implement auto-scaling based on CPU and memory metrics
9. THE System SHALL use containerization (Docker) for easy deployment
10. THE System SHALL support deployment across multiple availability zones

### Requirement 65: Data Scalability

**User Story:** As a database administrator, I want the database to handle growing data volumes, so that performance remains consistent.

#### Acceptance Criteria

1. THE System SHALL use database partitioning for large tables
2. THE System SHALL implement data archiving for old records
3. THE System SHALL use proper indexing on all frequently queried columns
4. THE System SHALL implement database query optimization with EXPLAIN analysis
5. THE System SHALL use database connection pooling to manage connections efficiently
6. THE System SHALL monitor database performance and optimize slow queries
7. THE System SHALL implement database backup and recovery procedures
8. THE System SHALL use database replication for high availability
9. THE System SHALL implement data retention policies to manage storage growth
10. THE System SHALL support database migration to larger instances if needed


### Security Requirements

### Requirement 66: Authentication and Authorization Security

**User Story:** As a security engineer, I want robust authentication and authorization, so that user accounts and data are protected.

#### Acceptance Criteria

1. THE System SHALL hash all passwords using bcrypt with cost factor 10
2. THE System SHALL never store passwords in plain text
3. THE System SHALL use JWT tokens with 15-minute expiry for access tokens
4. THE System SHALL use refresh tokens with 7-day expiry and rotation
5. THE System SHALL implement rate limiting of 5 login attempts per 15 minutes
6. THE System SHALL enforce HTTPS for all API communications
7. THE System SHALL validate JWT signatures on every protected request
8. THE System SHALL implement role-based access control (RBAC)
9. THE System SHALL verify user roles on the server side for all protected endpoints
10. THE System SHALL implement token blacklisting for logout functionality
11. THE System SHALL support biometric authentication on supported devices

### Requirement 67: Data Protection and Privacy

**User Story:** As a user, I want my personal data to be protected, so that my privacy is maintained.

#### Acceptance Criteria

1. THE System SHALL encrypt sensitive data at rest using AES-256
2. THE System SHALL encrypt all data in transit using TLS 1.2 or higher
3. THE System SHALL use flutter_secure_storage for storing sensitive data on mobile devices
4. THE System SHALL never store passwords or tokens in SharedPreferences
5. THE System SHALL implement certificate pinning for API calls
6. THE System SHALL sanitize all user inputs to prevent XSS attacks
7. THE System SHALL use parameterized queries to prevent SQL injection
8. THE System SHALL implement CORS policies to restrict API access
9. THE System SHALL mask sensitive data in logs and error messages
10. THE System SHALL comply with data protection regulations (GDPR, local laws)
11. THE System SHALL provide data export and deletion functionality for users

### Requirement 68: Payment Security

**User Story:** As a user, I want my payment information to be secure, so that I can transact with confidence.

#### Acceptance Criteria

1. THE System SHALL comply with PCI DSS standards for payment processing
2. THE System SHALL never store credit card numbers or CVV codes
3. THE System SHALL use payment gateway tokenization for card payments
4. THE System SHALL implement two-factor authentication for large transactions (>50,000 LKR)
5. THE System SHALL require transaction PIN for wallet payments
6. THE System SHALL implement fraud detection for unusual transaction patterns
7. THE System SHALL use database transactions with row-level locking for wallet operations
8. THE System SHALL maintain audit trail for all financial transactions
9. THE System SHALL encrypt payment data in transit and at rest
10. THE System SHALL implement velocity checks to detect suspicious activity

### Requirement 69: Application Security (OWASP Mobile Top 10)

**User Story:** As a security engineer, I want the mobile app to follow security best practices, so that it's protected against common vulnerabilities.

#### Acceptance Criteria

1. THE System SHALL implement certificate pinning to prevent man-in-the-middle attacks
2. THE System SHALL use platform security features (Keychain on iOS, Keystore on Android)
3. THE System SHALL implement code obfuscation in release builds
4. THE System SHALL remove debug logs and endpoints in production builds
5. THE System SHALL implement root/jailbreak detection
6. THE System SHALL validate all SSL/TLS certificates
7. THE System SHALL implement app signing with proper certificates
8. THE System SHALL use secure random number generation for cryptographic operations
9. THE System SHALL implement integrity checks to detect tampering
10. THE System SHALL never include hardcoded credentials or API keys in the app
11. THE System SHALL implement anti-debugging measures

### Reliability Requirements

### Requirement 70: Availability and Uptime

**User Story:** As a user, I want the system to be available when I need it, so that I can access services reliably.

#### Acceptance Criteria

1. THE System SHALL maintain 99.9% uptime (maximum 43 minutes downtime per month)
2. THE System SHALL implement health checks for all critical services
3. THE System SHALL use load balancing to distribute traffic and provide redundancy
4. THE System SHALL implement automatic failover for database failures
5. THE System SHALL use multiple availability zones for high availability
6. THE System SHALL implement circuit breakers to prevent cascade failures
7. THE System SHALL monitor system health and alert on anomalies
8. THE System SHALL implement graceful degradation when services are unavailable
9. THE System SHALL maintain service during deployments using blue-green deployment
10. THE System SHALL have disaster recovery plan with RTO of 4 hours and RPO of 1 hour

### Requirement 71: Error Handling and Recovery

**User Story:** As a user, I want the system to handle errors gracefully, so that I can recover from issues without losing data.

#### Acceptance Criteria

1. WHEN an error occurs, THE System SHALL display user-friendly error messages
2. WHEN an error occurs, THE System SHALL log detailed error information for debugging
3. WHEN a network error occurs, THE System SHALL retry the request with exponential backoff
4. WHEN a transaction fails, THE System SHALL rollback all changes to maintain data consistency
5. THE System SHALL implement timeout handling for all external API calls
6. THE System SHALL implement fallback mechanisms for critical features
7. THE System SHALL validate all inputs before processing to prevent errors
8. THE System SHALL implement error tracking with Sentry or similar tool
9. THE System SHALL send alerts for critical errors
10. THE System SHALL provide offline mode with local caching for essential features

### Requirement 72: Data Integrity and Consistency

**User Story:** As a system administrator, I want data to remain consistent and accurate, so that business operations are reliable.

#### Acceptance Criteria

1. THE System SHALL use database transactions for operations that modify multiple records
2. THE System SHALL implement row-level locking for concurrent updates
3. THE System SHALL validate data integrity constraints at the database level
4. THE System SHALL implement foreign key constraints to maintain referential integrity
5. THE System SHALL use optimistic locking to prevent lost updates
6. THE System SHALL implement data validation on both client and server sides
7. THE System SHALL maintain audit logs for critical data changes
8. THE System SHALL implement automated database backups daily
9. THE System SHALL test backup restoration procedures regularly
10. THE System SHALL implement point-in-time recovery for the database


### Usability Requirements

### Requirement 73: User Interface and Experience

**User Story:** As a user, I want an intuitive and pleasant interface, so that I can use the app easily without confusion.

#### Acceptance Criteria

1. THE System SHALL follow Material Design guidelines for Android
2. THE System SHALL follow Human Interface Guidelines for iOS
3. THE System SHALL provide consistent navigation patterns across all screens
4. THE System SHALL use clear and descriptive labels for all buttons and actions
5. THE System SHALL provide visual feedback for all user interactions
6. THE System SHALL display loading indicators for operations taking more than 300 milliseconds
7. THE System SHALL use appropriate color contrast for readability
8. THE System SHALL support both light and dark themes
9. THE System SHALL provide empty states with helpful guidance
10. THE System SHALL minimize the number of steps required to complete common tasks

### Requirement 74: Accessibility

**User Story:** As a user with disabilities, I want the app to be accessible, so that I can use all features independently.

#### Acceptance Criteria

1. THE System SHALL support screen readers (TalkBack on Android, VoiceOver on iOS)
2. THE System SHALL provide text alternatives for all images and icons
3. THE System SHALL support font scaling for users with visual impairments
4. THE System SHALL maintain minimum touch target size of 48x48 dp
5. THE System SHALL provide sufficient color contrast (WCAG AA standard)
6. THE System SHALL support keyboard navigation where applicable
7. THE System SHALL provide captions for audio content
8. THE System SHALL avoid relying solely on color to convey information
9. THE System SHALL provide clear focus indicators for interactive elements
10. THE System SHALL test accessibility with automated tools and manual testing

### Requirement 75: Localization and Internationalization

**User Story:** As a Sri Lankan user, I want the app in my preferred language, so that I can understand and use it comfortably.

#### Acceptance Criteria

1. THE System SHALL support English, Sinhala, and Tamil languages
2. THE System SHALL allow users to change language preference in settings
3. THE System SHALL persist language preference across sessions
4. THE System SHALL translate all UI text, labels, and messages
5. THE System SHALL format numbers according to Sri Lankan conventions (1,000.00)
6. THE System SHALL format currency as LKR with proper symbol placement
7. THE System SHALL format dates and times according to user locale
8. THE System SHALL use 12-hour time format as preferred in Sri Lanka
9. THE System SHALL support right-to-left (RTL) layout for Tamil where needed
10. THE System SHALL provide localized content for notifications and emails

### Requirement 76: Low Bandwidth Optimization

**User Story:** As a user in an area with poor connectivity, I want the app to work on slow networks, so that I can still access services.

#### Acceptance Criteria

1. THE System SHALL compress all images before upload
2. THE System SHALL use progressive image loading (low quality first, then high quality)
3. THE System SHALL implement lazy loading for lists and images
4. THE System SHALL cache frequently accessed data locally
5. THE System SHALL minimize API payload sizes
6. THE System SHALL support offline mode for viewing cached content
7. THE System SHALL queue actions when offline and sync when connection is restored
8. THE System SHALL display network status indicator
9. THE System SHALL provide low-data mode option to reduce bandwidth usage
10. THE System SHALL optimize API responses by removing unnecessary fields

### Maintainability Requirements

### Requirement 77: Code Quality and Standards

**User Story:** As a developer, I want clean and maintainable code, so that I can understand and modify it efficiently.

#### Acceptance Criteria

1. THE System SHALL follow Dart style guide for Flutter code
2. THE System SHALL follow JavaScript/TypeScript style guide for backend code
3. THE System SHALL maintain code coverage of at least 80% for unit tests
4. THE System SHALL use meaningful variable and function names
5. THE System SHALL include comments for complex logic
6. THE System SHALL use consistent code formatting with automated tools
7. THE System SHALL implement clean architecture with clear separation of concerns
8. THE System SHALL avoid code duplication through proper abstraction
9. THE System SHALL use dependency injection for testability
10. THE System SHALL conduct code reviews for all changes

### Requirement 78: Documentation

**User Story:** As a developer, I want comprehensive documentation, so that I can understand the system and contribute effectively.

#### Acceptance Criteria

1. THE System SHALL maintain API documentation using OpenAPI/Swagger
2. THE System SHALL document all public APIs with request/response examples
3. THE System SHALL maintain architecture documentation with diagrams
4. THE System SHALL document database schema with entity relationships
5. THE System SHALL maintain README files for all major components
6. THE System SHALL document deployment procedures
7. THE System SHALL document environment setup instructions
8. THE System SHALL maintain changelog for all releases
9. THE System SHALL document known issues and workarounds
10. THE System SHALL provide inline code documentation for complex functions

### Requirement 79: Testing and Quality Assurance

**User Story:** As a QA engineer, I want comprehensive testing, so that I can ensure the system works correctly.

#### Acceptance Criteria

1. THE System SHALL implement unit tests for all business logic
2. THE System SHALL implement widget tests for all UI components
3. THE System SHALL implement integration tests for critical user flows
4. THE System SHALL implement API tests for all endpoints
5. THE System SHALL achieve at least 80% code coverage
6. THE System SHALL run automated tests in CI/CD pipeline
7. THE System SHALL perform load testing before major releases
8. THE System SHALL perform security testing using OWASP ZAP or similar tools
9. THE System SHALL conduct manual testing for user experience
10. THE System SHALL maintain test documentation with test cases and scenarios

### Requirement 80: Monitoring and Observability

**User Story:** As a DevOps engineer, I want comprehensive monitoring, so that I can detect and resolve issues quickly.

#### Acceptance Criteria

1. THE System SHALL implement error tracking with Sentry
2. THE System SHALL implement application performance monitoring (APM)
3. THE System SHALL log all errors with stack traces and context
4. THE System SHALL implement structured logging with log levels
5. THE System SHALL monitor API response times and error rates
6. THE System SHALL monitor database query performance
7. THE System SHALL monitor server resource usage (CPU, memory, disk)
8. THE System SHALL implement uptime monitoring with alerts
9. THE System SHALL create dashboards for key metrics
10. THE System SHALL send alerts for critical issues via email and SMS
11. THE System SHALL retain logs for at least 30 days


## Constraints and Assumptions

### Technical Constraints

### Requirement 81: Technology Stack Constraints

**User Story:** As a technical lead, I want to use proven technologies, so that we can build reliably and find skilled developers.

#### Acceptance Criteria

1. THE System SHALL use Flutter for mobile app development
2. THE System SHALL use Node.js with Express for backend API
3. THE System SHALL use PostgreSQL with PostGIS extension as the primary database
4. THE System SHALL use Redis for caching and session storage
5. THE System SHALL use Socket.IO for real-time communication
6. THE System SHALL use Firebase Cloud Messaging for push notifications
7. THE System SHALL use Google Maps API for location services
8. THE System SHALL use AWS for cloud infrastructure
9. THE System SHALL use GitHub for version control
10. THE System SHALL use GitHub Actions for CI/CD

### Requirement 82: Platform Support

**User Story:** As a product manager, I want to support major mobile platforms, so that we can reach the widest audience.

#### Acceptance Criteria

1. THE System SHALL support Android 6.0 (API level 23) and above
2. THE System SHALL support iOS 12.0 and above
3. THE System SHALL optimize for devices with at least 2GB RAM
4. THE System SHALL support screen sizes from 4.7 inches to 6.7 inches
5. THE System SHALL support both portrait and landscape orientations
6. THE System SHALL support devices with varying screen densities
7. THE System SHALL test on popular device models in Sri Lankan market
8. THE System SHALL provide web admin dashboard for desktop browsers
9. THE System SHALL support Chrome, Firefox, Safari, and Edge browsers
10. THE System SHALL ensure responsive design for different screen sizes

### Business Constraints

### Requirement 83: Regulatory Compliance

**User Story:** As a compliance officer, I want the system to comply with regulations, so that we can operate legally in Sri Lanka.

#### Acceptance Criteria

1. THE System SHALL comply with Sri Lankan data protection laws
2. THE System SHALL comply with payment regulations from Central Bank of Sri Lanka
3. THE System SHALL implement KYC (Know Your Customer) for providers
4. THE System SHALL verify driver licenses and vehicle registrations
5. THE System SHALL maintain transaction records for audit purposes
6. THE System SHALL implement tax calculation and reporting as required
7. THE System SHALL provide data export functionality for regulatory requests
8. THE System SHALL implement age verification for certain services
9. THE System SHALL comply with consumer protection regulations
10. THE System SHALL maintain privacy policy and terms of service

### Requirement 84: Operational Constraints

**User Story:** As an operations manager, I want clear operational procedures, so that we can run the platform smoothly.

#### Acceptance Criteria

1. THE System SHALL support 24/7 operation with minimal downtime
2. THE System SHALL implement automated backups at 2 AM daily
3. THE System SHALL maintain backup retention for 30 days
4. THE System SHALL implement disaster recovery procedures
5. THE System SHALL provide admin tools for content moderation
6. THE System SHALL provide admin tools for user management
7. THE System SHALL provide admin tools for dispute resolution
8. THE System SHALL implement fraud detection and prevention
9. THE System SHALL provide customer support ticketing system
10. THE System SHALL maintain incident response procedures

### Assumptions

### Requirement 85: User Behavior Assumptions

**User Story:** As a product designer, I want to understand user behavior assumptions, so that I can design appropriate features.

#### Acceptance Criteria

1. THE System SHALL assume users have basic smartphone literacy
2. THE System SHALL assume users have access to mobile data or WiFi
3. THE System SHALL assume users have valid phone numbers for verification
4. THE System SHALL assume users can read in at least one supported language
5. THE System SHALL assume providers have necessary licenses and permits
6. THE System SHALL assume users will provide accurate location information
7. THE System SHALL assume users will provide valid payment information
8. THE System SHALL assume users understand digital wallet concepts
9. THE System SHALL assume users will rate services honestly
10. THE System SHALL provide onboarding tutorials for first-time users

### Requirement 86: Market Assumptions

**User Story:** As a business analyst, I want to document market assumptions, so that we can validate them and adjust strategy.

#### Acceptance Criteria

1. THE System SHALL assume demand for ride-hailing services in Sri Lankan cities
2. THE System SHALL assume demand for e-commerce marketplace
3. THE System SHALL assume demand for on-demand home services
4. THE System SHALL assume demand for gig economy jobs
5. THE System SHALL assume demand for vehicle rentals
6. THE System SHALL assume users prefer integrated super app over multiple apps
7. THE System SHALL assume users will adopt digital wallet for convenience
8. THE System SHALL assume competitive pricing will attract users
9. THE System SHALL assume quality service will drive retention
10. THE System SHALL validate assumptions through user research and analytics

## Dependencies

### Requirement 87: External Service Dependencies

**User Story:** As a system architect, I want to document external dependencies, so that we can manage risks and plan for failures.

#### Acceptance Criteria

1. THE System SHALL depend on Google Maps API for geocoding and directions
2. THE System SHALL depend on Firebase Cloud Messaging for push notifications
3. THE System SHALL depend on payment gateway for card and bank payments
4. THE System SHALL depend on SMS provider for OTP verification
5. THE System SHALL depend on AWS for cloud infrastructure
6. THE System SHALL depend on CDN for static asset delivery
7. THE System SHALL implement fallback mechanisms for non-critical dependencies
8. THE System SHALL monitor external service availability
9. THE System SHALL implement circuit breakers for external service calls
10. THE System SHALL document SLAs for all external dependencies

### Requirement 88: Infrastructure Dependencies

**User Story:** As a DevOps engineer, I want to document infrastructure requirements, so that I can provision resources appropriately.

#### Acceptance Criteria

1. THE System SHALL require AWS EC2 instances for API servers
2. THE System SHALL require AWS RDS for PostgreSQL database with PostGIS extension
3. THE System SHALL require AWS ElastiCache for Redis
4. THE System SHALL require AWS S3 for file storage
5. THE System SHALL require AWS CloudFront for CDN
6. THE System SHALL require load balancer for traffic distribution
7. THE System SHALL require SSL certificates for HTTPS
8. THE System SHALL require domain name and DNS configuration
9. THE System SHALL require monitoring and alerting infrastructure
10. THE System SHALL document minimum resource requirements for each component

## Success Metrics and KPIs

### Requirement 89: User Acquisition and Growth Metrics

**User Story:** As a growth manager, I want to track user acquisition, so that I can measure marketing effectiveness.

#### Acceptance Criteria

1. THE System SHALL track daily active users (DAU)
2. THE System SHALL track monthly active users (MAU)
3. THE System SHALL track new user registrations per day
4. THE System SHALL track user acquisition channels (organic, referral, paid)
5. THE System SHALL track user retention rate (Day 1, Day 7, Day 30)
6. THE System SHALL track referral conversion rate
7. THE System SHALL track app install to registration conversion rate
8. THE System SHALL track registration to first transaction conversion rate
9. THE System SHALL provide analytics dashboard for growth metrics
10. THE System SHALL export metrics for external analysis

### Requirement 90: Business Performance Metrics

**User Story:** As a business owner, I want to track business performance, so that I can measure success and make data-driven decisions.

#### Acceptance Criteria

1. THE System SHALL track gross merchandise value (GMV) per day/week/month
2. THE System SHALL track total revenue per day/week/month
3. THE System SHALL track revenue by service type (rides, orders, bookings, rentals)
4. THE System SHALL track average order value (AOV)
5. THE System SHALL track transaction volume per day
6. THE System SHALL track commission revenue per service type
7. THE System SHALL track wallet top-up volume
8. THE System SHALL track provider earnings and payouts
9. THE System SHALL track customer lifetime value (CLV)
10. THE System SHALL track customer acquisition cost (CAC)
11. THE System SHALL provide executive dashboard with key business metrics

## Conclusion

This requirements document provides a comprehensive specification for the VisaDuma super app, derived from the approved technical design. The requirements are organized into business requirements, functional requirements for 14 core modules, non-functional requirements covering performance, scalability, security, reliability, usability, and maintainability, as well as constraints, assumptions, dependencies, and success metrics.

All requirements follow the EARS (Easy Approach to Requirements Syntax) patterns for clarity and testability. Each requirement includes a user story for context and detailed acceptance criteria that can be validated through testing.

The system is designed to serve the Sri Lankan market with multilingual support, low-bandwidth optimization, and localized features while maintaining global best practices for security (OWASP compliance), performance, and scalability. The modular architecture allows for incremental development and future expansion into microservices as the platform grows.


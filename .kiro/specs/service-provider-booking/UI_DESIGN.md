# Service Provider Booking - UI Design Guide

## Design Principles

1. **Clean & Modern** - Inspired by Angi but adapted for VisaDuma's brand
2. **Easy Navigation** - Clear hierarchy from categories → providers → profile → booking
3. **Visual Hierarchy** - Important info stands out (ratings, prices, verified badges)
4. **Consistent** - Matches existing VisaDuma design system
5. **Accessible** - High contrast, readable fonts, semantic labels

## Color Palette

```dart
// Primary colors (existing VisaDuma)
primary: Color(0xFF2563EB)      // Blue
primaryDark: Color(0xFF1D4ED8)
primaryLight: Color(0xFFEFF6FF)

// Category colors (varied for visual interest)
carpenter: Color(0xFF2563EB)    // Blue
electrician: Color(0xFFD97706)  // Amber
plumber: Color(0xFF0891B2)      // Cyan
painter: Color(0xFFDB2777)      // Pink
acRepair: Color(0xFF7C3AED)     // Purple
cleaning: Color(0xFF059669)     // Green

// Status colors
pending: Color(0xFFD97706)      // Amber
confirmed: Color(0xFF059669)    // Green
inProgress: Color(0xFF2563EB)   // Blue
completed: Color(0xFF10B981)    // Green
cancelled: Color(0xFFEF4444)    // Red

// UI colors
background: Color(0xFFF8FAFF)
cardBackground: Color(0xFFFFFFFF)
textPrimary: Color(0xFF111827)
textSecondary: Color(0xFF6B7280)
border: Color(0xFFE5E7EB)
```

## Typography

```dart
// Using Google Fonts - DM Sans
heading1: 24px, weight: 700
heading2: 20px, weight: 700
heading3: 16px, weight: 700
body: 14px, weight: 400
bodyBold: 14px, weight: 600
caption: 12px, weight: 400
small: 11px, weight: 400
```

## Screen Layouts

### 1. Home Screen (Updated)

```
┌─────────────────────────────────────┐
│  [Header with gradient]             │
│  Welcome back, User!                │
│  [Search bar]                       │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  [Main service grid - 3x2]          │
│  Services | Rides    | Shops        │
│  Vehicles | Jobs     | Boarding     │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  [Promo banner]                     │
│  Special Offer - 20% off! 🎉        │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Popular Services        [See More] │
│  ┌────┐ ┌────┐ ┌────┐              │
│  │🔨  │ │⚡  │ │🔧  │              │
│  │Carp│ │Elec│ │Plum│              │
│  └────┘ └────┘ └────┘              │
│  ┌────┐ ┌────┐ ┌────┐              │
│  │🎨  │ │❄️  │ │🧹  │              │
│  │Pain│ │AC  │ │Clea│              │
│  └────┘ └────┘ └────┘              │
└─────────────────────────────────────┘
```

### 2. Service Categories Screen

```
┌─────────────────────────────────────┐
│  ← Service Categories               │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  🔍 Search categories...            │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  ┌──────────────┐ ┌──────────────┐ │
│  │   🔨         │ │   ⚡         │ │
│  │ Carpenter    │ │ Electrician  │ │
│  │ 24 providers │ │ 18 providers │ │
│  └──────────────┘ └──────────────┘ │
│  ┌──────────────┐ ┌──────────────┐ │
│  │   🔧         │ │   🎨         │ │
│  │ Plumber      │ │ Painter      │ │
│  │ 15 providers │ │ 12 providers │ │
│  └──────────────┘ └──────────────┘ │
│  ... (more categories)              │
└─────────────────────────────────────┘
```

### 3. Service Providers List

```
┌─────────────────────────────────────┐
│  ← Carpenters              [Filter] │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  🔍 Search providers...             │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  ┌─────────────────────────────────┐│
│  │ 👤  John's Carpentry      ✓     ││
│  │     ⭐ 4.8 (127)                ││
│  │     5 years experience          ││
│  │     From LKR 2,500/hr           ││
│  │     2.3 km away                 ││
│  │     Professional woodwork...    ││
│  │                  [View Profile] ││
│  └─────────────────────────────────┘│
│  ┌─────────────────────────────────┐│
│  │ 👤  Silva Furniture              ││
│  │     ⭐ 4.9 (89)                 ││
│  │     8 years experience          ││
│  │     From LKR 3,000/hr           ││
│  │     1.5 km away                 ││
│  │     Custom furniture maker...   ││
│  │                  [View Profile] ││
│  └─────────────────────────────────┘│
│  ... (more providers)               │
└─────────────────────────────────────┘
```

### 4. Provider Profile Screen

```
┌─────────────────────────────────────┐
│  ← John's Carpentry          [Share]│
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│         👤 (large avatar)           │
│      John's Carpentry         ✓     │
│      ⭐ 4.8 (127 reviews)           │
│      5 years in business            │
│      Responds in ~30 min            │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  [📞 Call]  [💬 Chat]  [📅 Book]   │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  About                              │
│  Professional carpentry services... │
│                                     │
│  Service Area                       │
│  Colombo, Gampaha, Kalutara         │
│                                     │
│  Availability                       │
│  Mon-Sat: 8:00 AM - 6:00 PM         │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Services & Pricing                 │
│  • Custom Furniture - LKR 3,500/hr  │
│  • Door Installation - LKR 2,500/hr │
│  • Cabinet Making - LKR 4,000/hr    │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Portfolio              [View All]  │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐       │
│  │img1│ │img2│ │img3│ │img4│ →     │
│  └────┘ └────┘ └────┘ └────┘       │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Certifications                     │
│  ✓ Certified Carpenter (2020)       │
│  ✓ Safety Training (2021)           │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Reviews (127)          [View All]  │
│  ⭐⭐⭐⭐⭐ 5.0  ████████████ 85%    │
│  ⭐⭐⭐⭐   4.0  ███          12%    │
│  ⭐⭐⭐     3.0  █            3%     │
│                                     │
│  ┌─────────────────────────────────┐│
│  │ 👤 Sarah P.        ⭐⭐⭐⭐⭐    ││
│  │ 2 days ago                      ││
│  │ Excellent work! Very professional││
│  │ [📷 📷]                         ││
│  └─────────────────────────────────┘│
│  ... (more reviews)                 │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Location                           │
│  [Map showing service area]         │
└─────────────────────────────────────┘
```

### 5. Booking Form Screen

```
┌─────────────────────────────────────┐
│  ← Book Service                     │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Provider: John's Carpentry         │
│  Service: Custom Furniture          │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Service Date *                     │
│  [📅 Select date]  Apr 15, 2026     │
│                                     │
│  Service Time *                     │
│  [🕐 Select time]  10:00 AM         │
│                                     │
│  Duration *                         │
│  [▼ Select]  3 hours                │
│                                     │
│  Service Address *                  │
│  [📍 Select on map]                 │
│  123 Main St, Colombo 03            │
│                                     │
│  Contact Phone *                    │
│  [+94 77 123 4567]                  │
│                                     │
│  Service Description *              │
│  [Text area]                        │
│  Need custom bookshelf...           │
│                                     │
│  Special Instructions (Optional)    │
│  [Text area]                        │
│                                     │
│  Payment Method *                   │
│  ○ Cash                             │
│  ● Wallet (Balance: LKR 15,000)     │
│  ○ Card                             │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Cost Breakdown                     │
│  Base rate (3 hrs)    LKR 10,500    │
│  Platform fee (5%)    LKR    525    │
│  ─────────────────────────────────  │
│  Total                LKR 11,025    │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│         [Confirm Booking]           │
└─────────────────────────────────────┘
```

### 6. Booking Confirmation Screen

```
┌─────────────────────────────────────┐
│                                     │
│           ✅ (large icon)           │
│                                     │
│       Booking Confirmed!            │
│                                     │
│  Booking #BK-2026-04-001234         │
│                                     │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Provider                           │
│  👤 John's Carpentry                │
│  📞 +94 77 987 6543                 │
│                                     │
│  Service Details                    │
│  📅 Apr 15, 2026 at 10:00 AM        │
│  ⏱️  3 hours                         │
│  📍 123 Main St, Colombo 03         │
│                                     │
│  Status                             │
│  🟡 Pending Provider Confirmation   │
│                                     │
│  Total Cost                         │
│  💰 LKR 11,025                      │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  The provider has been notified and │
│  will confirm your booking shortly. │
│  You'll receive a notification.     │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│      [View Booking Details]         │
│      [Back to Home]                 │
└─────────────────────────────────────┘
```

### 7. Bookings List Screen

```
┌─────────────────────────────────────┐
│  ← My Bookings                      │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  [Active]  [Past]                   │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  ┌─────────────────────────────────┐│
│  │ 👤 John's Carpentry             ││
│  │ Custom Furniture                ││
│  │ Apr 15, 2026 at 10:00 AM        ││
│  │ 🟢 Confirmed                    ││
│  │ LKR 11,025                      ││
│  └─────────────────────────────────┘│
│  ┌─────────────────────────────────┐│
│  │ 👤 Silva Furniture              ││
│  │ Cabinet Making                  ││
│  │ Apr 20, 2026 at 2:00 PM         ││
│  │ 🟡 Pending                      ││
│  │ LKR 8,500                       ││
│  └─────────────────────────────────┘│
│  ... (more bookings)                │
└─────────────────────────────────────┘
```

### 8. Booking Detail Screen

```
┌─────────────────────────────────────┐
│  ← Booking Details                  │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Booking #BK-2026-04-001234         │
│  🟢 Confirmed                       │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Status Timeline                    │
│  ✅ Pending      Apr 10, 10:30 AM   │
│  ✅ Confirmed    Apr 10, 11:15 AM   │
│  ⏳ In Progress  -                  │
│  ⏳ Completed    -                  │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Provider                           │
│  👤 John's Carpentry                │
│  ⭐ 4.8 (127)                       │
│  📞 +94 77 987 6543                 │
│  💬 [Chat]                          │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Service Details                    │
│  📅 Apr 15, 2026                    │
│  🕐 10:00 AM                        │
│  ⏱️  3 hours                         │
│  📍 123 Main St, Colombo 03         │
│  📝 Need custom bookshelf...        │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  Payment                            │
│  Method: Wallet                     │
│  Status: Pending                    │
│  Amount: LKR 11,025                 │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│         [Cancel Booking]            │
└─────────────────────────────────────┘
```

## Component Specifications

### Category Card
```dart
Container(
  width: (screenWidth - 48) / 2,
  height: 140,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF2563EB).withOpacity(0.08),
        blurRadius: 14,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: category.bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(category.icon, size: 32, color: category.color),
      ),
      SizedBox(height: 12),
      Text(category.name, style: heading3),
      SizedBox(height: 4),
      Text('${category.providerCount} providers', style: caption),
    ],
  ),
)
```

### Provider Card
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF2563EB).withOpacity(0.08),
        blurRadius: 14,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: Row(
    children: [
      CircleAvatar(radius: 32, backgroundImage: NetworkImage(provider.avatarUrl)),
      SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(provider.name, style: heading3),
                if (provider.isVerified) Icon(Icons.verified, size: 16, color: primary),
              ],
            ),
            Row(
              children: [
                Icon(Icons.star, size: 14, color: Colors.amber),
                Text('${provider.rating} (${provider.reviewCount})', style: caption),
              ],
            ),
            Text('${provider.yearsExperience} years experience', style: caption),
            Text('From LKR ${provider.hourlyRate}/hr', style: bodyBold),
            Text('${provider.distanceKm} km away', style: caption),
            Text(provider.description, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    ],
  ),
)
```

### Booking Status Badge
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: statusColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: statusColor,
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(width: 6),
      Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600)),
    ],
  ),
)
```

## Animations & Transitions

1. **Screen Transitions**
   - Use slide transition for forward navigation
   - Use fade transition for modal screens
   - Duration: 300ms with easeInOut curve

2. **Card Tap Animation**
   - Scale down to 0.98 on tap
   - Duration: 100ms

3. **Loading States**
   - Use shimmer effect for skeleton screens
   - Fade in content when loaded

4. **Status Updates**
   - Animate status badge color change
   - Show checkmark animation for completed steps

## Responsive Design

### Mobile (< 600px)
- Single column layouts
- Full-width cards
- Bottom sheets for filters

### Tablet (600px - 900px)
- 2-column grids where appropriate
- Side-by-side layouts for forms
- Modal dialogs for filters

### Desktop (> 900px)
- 3-column grids
- Side navigation
- Inline filters

## Accessibility

1. **Semantic Labels**
   - All interactive elements have labels
   - Images have alt text
   - Form fields have labels

2. **Contrast Ratios**
   - Text: minimum 4.5:1
   - Large text: minimum 3:1
   - Interactive elements: minimum 3:1

3. **Touch Targets**
   - Minimum 44x44 dp
   - Adequate spacing between elements

4. **Screen Reader Support**
   - Proper heading hierarchy
   - Descriptive button labels
   - Status announcements

## Design Assets Needed

1. **Icons**
   - Category icons (Material Icons)
   - Status icons
   - Action icons (call, chat, book)

2. **Illustrations**
   - Empty state illustrations
   - Success/error illustrations
   - Onboarding illustrations

3. **Images**
   - Placeholder avatars
   - Placeholder portfolio images
   - Category banners

## Implementation Notes

1. Use existing VisaDuma design system components where possible
2. Create reusable widgets for common patterns
3. Implement dark mode support (future)
4. Test on multiple screen sizes
5. Optimize images for performance
6. Use cached_network_image for all remote images
7. Implement proper error states
8. Add loading skeletons for better UX

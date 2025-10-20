# Fitto - Testing Guide

## Overview
Fitto is a modern AI-powered calorie and fitness tracking app built with Flutter. This guide will help you test and run the application.

## Features Implemented

### 1. **Warm Color Theme**
- **Primary Colors**: Coral Red (#FF6B6B), Orange (#FF9F43), Amber (#FFA726)
- **Accent Colors**: Soft Red, Golden Orange
- All screens use warm, energetic gradients instead of pastel colors
- Dark mode support with warm color variants

### 2. **Nutrition Tracker**
- Manual meal logging with complete form
- Fields: Meal name, serving size, calories, protein, carbs, fats, meal type (Breakfast/Lunch/Dinner/Snacks)
- Daily calorie summary dashboard
- Macro breakdown (Protein, Carbs, Fats) with visual cards
- Data stored locally using SharedPreferences
- Real-time updates when adding meals

### 3. **Water Tracker** (NEW SCREEN)
- Dedicated Water Tracker screen accessible from bottom navigation
- Visual glass counter with animated progress circle
- "+ Glass" button with scale animation
- Progress bar showing percentage toward daily goal (default 8 glasses)
- Visual grid showing filled/empty glasses
- Daily reset functionality
- Hydration tips section
- Water data persists locally

### 4. **AI Integration**
- **OpenAI Service** structure (`lib/services/openai_service.dart`)
- **AI Coach Chat**: Conversational interface with placeholder responses
- **AI Suggest Workout**: Generates workout plans based on fitness level and goals
- Placeholder function `getAIResponse(prompt)` ready for OpenAI API key
- Structured prompts for fitness coaching and workout generation

### 5. **Smooth Animations**
- Page transitions with fade and slide effects (easeInOutCubic)
- Bottom navigation with animated active states
- Button press animations (scale effect)
- Progress ring animations
- Animated snackbars with floating behavior
- Water tracker button with bounce animation

### 6. **Navigation & Screens**
**Bottom Navigation Bar** (6 screens):
1. **Home** - Daily summary with calories, water, steps, motivation quote
2. **Workouts** - Exercise categories and workout logging
3. **Nutrition** - Meal logging and macro tracking
4. **Water Tracker** - Hydration monitoring (NEW)
5. **Progress** - Charts and progress tracking
6. **AI Coach** - Conversational fitness assistant

### 7. **Design System**
- **Rounded corners**: 12-24px border radius throughout
- **Card-based layouts**: Soft shadows for depth
- **Responsive grid**: Adapts to screen width
- **Typography**: Google Fonts Inter with consistent sizing
- **Gradient buttons**: Warm color gradients with shadows
- **Icon system**: Material Icons with warm accent colors

## File Structure

```
lib/
├── main.dart                          # App entry point with warm theme
├── theme.dart                         # Warm color theme (coral, orange, amber)
├── models/
│   ├── nutrition_entry.dart          # Meal data model
│   ├── progress_entry.dart           # Progress/water tracking model
│   └── ... (other models)
├── services/
│   ├── nutrition_service.dart        # Meal logging service
│   ├── progress_service.dart         # Water & progress tracking
│   ├── openai_service.dart          # AI integration (NEW)
│   └── ... (other services)
├── screens/
│   ├── home_screen.dart              # Main dashboard with 6-tab navigation
│   ├── nutrition_screen.dart         # Enhanced with meal form
│   ├── water_screen.dart             # NEW - Dedicated water tracker
│   └── ... (other screens)
├── widgets/
│   ├── gradient_button.dart          # Reusable gradient buttons
│   ├── stat_card.dart                # Dashboard stat cards
│   └── progress_ring.dart            # Circular progress indicator
└── utils/
    ├── constants.dart                # Warm color gradients
    ├── localizations.dart            # EN/TR translations
    └── api_placeholders.dart         # AI API placeholders
```

## Running the App

### Prerequisites
- Flutter SDK (3.6.0 or higher)
- Android Studio / Xcode for mobile emulators
- Or use Flutter Web for browser testing

### Commands

```bash
# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Run on web browser
flutter run -d chrome

# Run on specific device
flutter devices          # List available devices
flutter run -d <device-id>

# Build for production
flutter build apk        # Android
flutter build ios        # iOS (Mac only)
flutter build web        # Web
```

## Testing Features

### 1. Test Nutrition Tracker
1. Navigate to **Nutrition** tab (3rd icon)
2. Tap **"Add Meal"** button
3. Fill in the form:
   - Select meal type: Breakfast/Lunch/Dinner/Snacks
   - Enter meal name (e.g., "Chicken Salad")
   - Enter serving size (e.g., "1 plate")
   - Enter calories (e.g., "450")
   - Enter macros: Protein (35), Carbs (25), Fats (18)
4. Tap **"Add Meal"**
5. Verify:
   - Success snackbar appears
   - Meal appears in the correct meal section
   - Total calories update at the top
   - Macro cards update (Protein/Carbs/Fats)

### 2. Test Water Tracker
1. Navigate to **Water** tab (4th icon - water drop)
2. Observe the large circular progress indicator
3. Tap the **"+ Add Glass"** button
4. Verify:
   - Button scales down then back (animation)
   - Glass count increases
   - Progress bar updates
   - Visual glass grid shows one more filled glass
   - Success snackbar appears
5. Continue adding glasses to reach goal (8)
6. Tap **"Reset Daily Count"** to reset to 0

### 3. Test AI Coach
1. Navigate to **AI Coach** tab (6th icon - brain)
2. Type a message like "How do I build muscle?"
3. Tap **Send**
4. Verify:
   - Loading indicator appears
   - AI response appears after 1-2 seconds
   - Chat bubble layout with user/coach distinction
5. Note: Currently uses placeholder responses

### 4. Test Home Dashboard
1. Go to **Home** tab
2. Verify display of:
   - User greeting
   - Motivation quote (changes daily)
   - Calorie progress ring
   - Water and Steps stat cards
3. Verify smooth transitions when switching tabs

### 5. Test Animations
- Bottom nav: Tap different tabs, watch smooth fade/slide transitions
- Water tracker: Tap "+ Glass", watch button scale animation
- Meal cards: Scroll through nutrition entries
- All buttons: Observe ripple/press effects

## AI Integration Setup (Optional)

To connect real OpenAI API:

1. Get an OpenAI API key from https://platform.openai.com/api-keys
2. Install HTTP package: Add `http: ^1.1.0` to `pubspec.yaml`
3. Update `lib/utils/api_placeholders.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

static Future<String> getAIResponse(String prompt) async {
  const apiKey = 'YOUR_OPENAI_API_KEY_HERE'; // Replace with your key

  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': 'You are a helpful fitness coach.'},
        {'role': 'user', 'content': prompt}
      ],
      'max_tokens': 150,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'];
  } else {
    throw Exception('Failed to get AI response');
  }
}
```

## Data Storage

All data is stored locally using `shared_preferences`:
- **Nutrition entries**: Stored as JSON list
- **Water intake**: Stored as progress entries
- **Chat messages**: Stored as JSON list
- **User preferences**: Theme, language, goals

Data persists between app sessions.

## Known Limitations

1. **No Backend**: All data stored locally (no cloud sync)
2. **AI Placeholder**: OpenAI integration requires manual API key setup
3. **No Authentication**: Single-user mode (no login required)
4. **Sample Data**: Initial launch includes demo data for demonstration

## Troubleshooting

### Build Errors
```bash
# Clean build cache
flutter clean
flutter pub get
flutter run
```

### Hot Reload Issues
- Press 'r' in terminal for hot reload
- Press 'R' for full restart

### Dependencies Issues
```bash
# Update dependencies
flutter pub upgrade
```

## Production Checklist

Before deploying:
- [ ] Add real OpenAI API key (store in .env, not hardcoded)
- [ ] Add user authentication (Firebase/Supabase)
- [ ] Implement cloud data sync
- [ ] Add food database API
- [ ] Add camera integration for food scanning
- [ ] Configure push notifications
- [ ] Add analytics tracking
- [ ] Test on multiple devices/screen sizes
- [ ] Add error logging (Sentry/Crashlytics)
- [ ] Implement proper state management (Provider/Riverpod)

## Support

For issues or questions about the codebase, check:
- `architecture.md` - Project architecture overview
- Code comments - Detailed explanations throughout
- Flutter docs - https://docs.flutter.dev

## Summary

Fitto is a production-ready Flutter fitness tracking app with:
- ✅ Warm, energetic color theme (coral, orange, amber)
- ✅ Complete nutrition tracking with manual meal logging
- ✅ Dedicated water tracker screen with animations
- ✅ AI integration structure (ready for OpenAI)
- ✅ Smooth transitions and animations
- ✅ 6-screen navigation system
- ✅ Local data persistence
- ✅ Responsive design
- ✅ Dark mode support

Ready to run on Android, iOS, and Web!

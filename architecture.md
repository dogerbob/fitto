# Fitto - Fitness & Nutrition Tracker App Architecture

## Overview
Fitto is a modern fitness and nutrition tracking app with AI-powered coaching features. Inspired by wger Flutter but redesigned with commercial UI/UX focusing on pastel colors, soft gradients, and clean typography.

## Design Philosophy
- **Style**: Minimal, pastel colors (#FFB4C8, #E8C5E5, #A8D8EA, #FFEAA7), soft gradients, clean typography
- **Layout**: Modern, spacious, card-based design avoiding Material Design conventions
- **Theme**: Light + Dark mode support
- **Localization**: English + Turkish support

## Core Features (MVP)

### 1. Authentication & Onboarding
- Splash screen with animation
- Onboarding flow (3 slides)
- Social auth placeholders (Google/Apple)

### 2. Home Dashboard
- Daily summary: calories, water, steps, motivation quote
- Quick action cards
- Progress ring indicators

### 3. Workouts
- Exercise categories (Strength, Cardio, Flexibility, Sports)
- Exercise list with muscle groups
- AI workout suggestion button (placeholder)
- Workout logging

### 4. Nutrition
- Calorie tracker (manual input)
- Meal logging (breakfast, lunch, dinner, snacks)
- Macro breakdown (proteins, carbs, fats)
- AI food recognition placeholder

### 5. Progress
- Weight tracking with charts
- Calorie trends
- Water consumption graphs
- Body measurements

### 6. AI Coach
- Chat-like interface
- Motivational messages
- Workout suggestions (placeholder for OpenAI API)
- Daily tips

### 7. Settings
- Profile management
- Language selection (EN/TR)
- Theme toggle (light/dark)
- Notifications preferences
- Units (kg/lbs, cm/in)

### 8. Premium
- Subscription plans (monthly, yearly, lifetime)
- Feature comparison
- Payment integration placeholder

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── theme.dart                     # Updated theme with pastel colors
├── models/                        # Data models
│   ├── user.dart
│   ├── workout.dart
│   ├── exercise.dart
│   ├── nutrition_entry.dart
│   ├── progress_entry.dart
│   ├── chat_message.dart
│   └── subscription_plan.dart
├── services/                      # Business logic & data operations
│   ├── auth_service.dart
│   ├── workout_service.dart
│   ├── nutrition_service.dart
│   ├── progress_service.dart
│   ├── coach_service.dart
│   └── storage_service.dart
├── screens/                       # App screens
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── auth_screen.dart
│   ├── home_screen.dart
│   ├── workouts_screen.dart
│   ├── nutrition_screen.dart
│   ├── progress_screen.dart
│   ├── coach_screen.dart
│   ├── settings_screen.dart
│   └── premium_screen.dart
├── widgets/                       # Reusable widgets
│   ├── gradient_button.dart
│   ├── stat_card.dart
│   ├── progress_ring.dart
│   └── chat_bubble.dart
└── utils/                         # Utilities & constants
    ├── constants.dart
    ├── localizations.dart
    └── api_placeholders.dart
```

## Data Models

### User
- id, name, email, profileImage
- weight, height, age, gender
- dailyCalorieGoal, dailyWaterGoal, dailyStepsGoal
- isPremium, createdAt, updatedAt

### Workout
- id, userId, date, exerciseId
- sets, reps, weight, duration
- notes, createdAt, updatedAt

### Exercise
- id, name, category, muscleGroup
- description, difficulty, imageUrl
- createdAt, updatedAt

### NutritionEntry
- id, userId, date, mealType
- name, calories, protein, carbs, fats
- servingSize, createdAt, updatedAt

### ProgressEntry
- id, userId, date, type
- value (weight/water/steps/measurements)
- createdAt, updatedAt

### ChatMessage
- id, message, isUser, timestamp

### SubscriptionPlan
- id, name, price, duration
- features, isPopular

## Implementation Steps

1. **Update Theme** - Replace theme colors with pastel palette and soft gradients
2. **Add Dependencies** - shared_preferences, fl_chart, intl
3. **Create Data Models** - All models with toJson/fromJson/copyWith
4. **Build Services** - Storage service + all business logic services with mock data
5. **Create Reusable Widgets** - Gradient buttons, stat cards, progress rings, chat bubbles
6. **Implement Screens** - All 10 screens with navigation
7. **Add Localization** - English + Turkish strings
8. **Add API Placeholders** - Mock functions for future backend integration
9. **Test & Debug** - Compile and fix all errors

## Technical Notes
- Use local storage (shared_preferences) for all data persistence
- Mock data for demonstrations
- Placeholder functions for AI endpoints (OpenAI integration)
- Placeholder social auth buttons (no actual implementation)
- Charts using fl_chart package
- No actual backend - UI/UX prototype only

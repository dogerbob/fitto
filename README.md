# Fitto - AI-Powered Fitness & Nutrition Tracker

<div align="center">
  <h3>🔥 Track Your Fitness Journey with Style 🔥</h3>
  <p>A modern Flutter mobile app for calorie tracking, workouts, hydration monitoring, and AI-powered coaching</p>
</div>

---

## ✨ Features

### 🍽️ Nutrition Tracker
- **Manual meal logging** with complete form (meal name, calories, macros, serving size)
- **Daily calorie dashboard** with progress visualization
- **Macro breakdown** (Protein, Carbs, Fats) with color-coded cards
- **Meal type organization** (Breakfast, Lunch, Dinner, Snacks)
- AI food recognition placeholder for future camera scanning

### 💧 Water Tracker (NEW)
- **Dedicated water tracking screen** with stunning circular progress indicator
- **Interactive glass counter** with smooth animations
- **Visual glass grid** showing filled/empty glasses
- **Daily goal tracking** with percentage progress bar
- **Hydration tips** and best practices
- Quick reset for daily count

### 🏋️ Workout Tracker
- **Exercise categories**: Strength, Cardio, Flexibility, Sports
- **Workout logging** with sets, reps, and duration
- **AI workout suggestions** based on fitness level and goals
- Exercise library with muscle group targeting

### 📈 Progress Tracking
- **Weight charts** over time
- **Calorie trends** visualization
- **Water consumption** history
- **Body measurements** tracking

### 🤖 AI Coach Chat
- **Conversational AI interface** for fitness guidance
- **Motivational messages** and daily tips
- **Workout recommendations** based on your goals
- OpenAI integration ready (placeholder responses included)

### ⚙️ Customization
- **Light & Dark mode** support
- **Multi-language**: English & Turkish
- **User profile** with goals and preferences
- **Notification settings**
- **Premium subscription** options

---

## 🎨 Design System

### Color Palette - Warm & Energetic
```
Primary:   #FF6B6B (Coral Red)
Secondary: #FF9F43 (Bright Orange)
Tertiary:  #FFA726 (Warm Amber)
Accent:    #FFB84D (Golden Orange)
Water:     #4FC3F7 (Sky Blue)
```

### Visual Style
- **Modern card-based layouts** with soft shadows
- **Smooth animations** on all interactions (350ms transitions)
- **Rounded corners** throughout (12-24px radius)
- **Gradient buttons** with warm color blends
- **Responsive design** adapting to all screen sizes

---

## 📱 App Structure

### Navigation - 6 Main Screens
1. **🏠 Home** - Daily summary with calories, water, steps, motivation quote
2. **💪 Workouts** - Exercise tracking and AI workout suggestions
3. **🍴 Nutrition** - Complete meal logging with macro tracking
4. **💧 Water** - Dedicated hydration tracker (NEW FEATURE)
5. **📊 Progress** - Charts and statistics over time
6. **🧠 AI Coach** - Conversational fitness assistant

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.6.0+
- Android Studio or Xcode
- Device/Emulator for testing

### Installation
```bash
# Clone the repository
cd fitto

# Install dependencies
flutter pub get

# Run the app
flutter run

# Or run on web
flutter run -d chrome
```

### Build for Production
```bash
# Android APK
flutter build apk

# iOS (requires Mac)
flutter build ios

# Web
flutter build web
```

---

## 📂 Project Structure

```
lib/
├── main.dart                  # App entry point
├── theme.dart                 # Warm color theme system
├── models/                    # Data models
│   ├── nutrition_entry.dart
│   ├── progress_entry.dart
│   ├── workout.dart
│   └── ...
├── screens/                   # UI screens
│   ├── home_screen.dart
│   ├── nutrition_screen.dart
│   ├── water_screen.dart      # NEW
│   ├── workouts_screen.dart
│   ├── progress_screen.dart
│   ├── coach_screen.dart
│   └── ...
├── services/                  # Business logic
│   ├── nutrition_service.dart
│   ├── progress_service.dart
│   ├── openai_service.dart    # NEW
│   └── ...
├── widgets/                   # Reusable components
│   ├── gradient_button.dart
│   ├── stat_card.dart
│   └── progress_ring.dart
└── utils/                     # Helpers & constants
    ├── constants.dart
    ├── localizations.dart
    └── api_placeholders.dart
```

---

## 🧪 Testing

See **`TESTING.md`** for comprehensive testing instructions including:
- Feature-by-feature testing guide
- OpenAI API integration setup
- Troubleshooting tips
- Production deployment checklist

### Quick Test
```bash
# Run the app
flutter run

# Test nutrition: Navigate to Nutrition → Add Meal → Fill form → Submit
# Test water: Navigate to Water → Tap "+ Add Glass" → Watch animation
# Test AI: Navigate to AI Coach → Type message → See response
```

---

## 🤖 AI Integration

### Current Status
The app includes a complete AI service layer with placeholder responses. To enable real AI features:

1. Get an OpenAI API key from https://platform.openai.com
2. Add the `http` package to dependencies
3. Update `lib/utils/api_placeholders.dart` with your API key
4. See `TESTING.md` for complete integration code

### AI Features Ready to Activate
- ✅ Fitness coaching conversations
- ✅ Personalized workout generation
- ✅ Nutrition advice
- 🔄 Food image recognition (future)

---

## 💾 Data Storage

All data is stored locally using `shared_preferences`:
- Nutrition entries
- Water intake logs
- Workout history
- Chat messages
- User preferences

**Note**: Currently local-only. Cloud sync can be added with Supabase/Firebase integration.

---

## 🎯 Key Highlights

### What Makes Fitto Special?
1. **🔥 Warm, Energetic Design** - Coral, orange, and amber colors inspire action
2. **💧 Dedicated Water Tracker** - Full-screen experience for hydration monitoring
3. **✍️ Complete Manual Entry** - No database lookup required, full control
4. **🤖 AI-Ready Architecture** - One API key away from live AI features
5. **✨ Smooth Animations** - Every interaction feels polished and responsive
6. **🌍 Multi-Language** - English and Turkish support built-in
7. **🌓 Dark Mode** - Beautiful dark theme with warm accent colors
8. **📱 Responsive** - Works perfectly on phones, tablets, and web

---

## 📚 Documentation

- **`IMPLEMENTATION_SUMMARY.md`** - Complete technical overview and implementation details
- **`TESTING.md`** - Detailed testing guide and setup instructions
- **`architecture.md`** - Original project architecture and design philosophy

---

## 🛠️ Built With

- **Flutter** 3.6.0+ - UI framework
- **Google Fonts** - Inter typography
- **fl_chart** - Beautiful charts and graphs
- **shared_preferences** - Local data persistence
- **flutter_local_notifications** - Push notifications

---

## 🔮 Roadmap

### Coming Soon
- [ ] Supabase integration for cloud sync
- [ ] Real OpenAI API connection
- [ ] Food image recognition with AI
- [ ] Social features (friends, challenges)
- [ ] Export data to CSV/PDF
- [ ] Apple Watch & Wear OS support
- [ ] Barcode scanner for packaged foods
- [ ] Recipe database integration

---

## 🤝 Contributing

This is a demonstration project built for Replit. Feel free to fork and customize for your own use!

### Local Development
```bash
# Hot reload during development
flutter run
# Press 'r' for hot reload
# Press 'R' for hot restart

# Format code
flutter format .

# Analyze code
flutter analyze
```

---

## 📜 License

This project is for demonstration purposes. Feel free to use as a learning resource or starting point for your own fitness app.

---

## 🙏 Acknowledgments

- Design inspired by modern fitness apps with a focus on warm, motivating aesthetics
- Architecture based on Flutter best practices and clean code principles
- Built with ❤️ for the Replit community

---

## 📞 Support

For questions about the codebase:
1. Check the inline code comments (detailed explanations provided)
2. Read `TESTING.md` for setup and troubleshooting
3. Review `IMPLEMENTATION_SUMMARY.md` for technical details

---

<div align="center">
  <p><strong>Ready to track your fitness journey? 🚀</strong></p>
  <p><code>flutter run</code> and start achieving your goals!</p>
</div>

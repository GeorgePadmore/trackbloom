# TrackBloom - Minimalist Habit & Task Tracker

## 🎯 Project Overview
**TrackBloom** is a privacy-focused, offline-first habit and task tracker designed for users who want simplicity without sacrificing functionality. Built with Flutter for cross-platform compatibility and SQLite for reliable local storage.

## ✨ Enhanced Core Features

### 🏁 Smart Task & Habit Management
- **Quick Add Interface**: Floating action button with smart form
- **Habit vs Task Detection**: Auto-suggests type based on keywords
- **Priority Levels**: High, Medium, Low with color coding
- **Categories**: Work, Personal, Health, Learning (customizable)
- **Due Dates**: Optional for tasks, recurring for habits
- **Subtasks**: Break down complex tasks into smaller steps

### 🗓️ Intelligent Daily View
- **Today's Focus**: Prioritized list with overdue items highlighted
- **Time-based Sorting**: Morning, afternoon, evening habits
- **Progress Indicators**: Visual completion bars and streaks
- **Quick Actions**: Swipe to complete, postpone, or edit
- **Batch Operations**: Mark multiple items as done

### 📊 Enhanced Progress Tracking
- **Streak Analytics**: Current streak, longest streak, success rate
- **Weekly Heatmap**: Visual representation of habit consistency
- **Monthly Summary**: Completion rates and trend analysis
- **Habit Difficulty**: Adaptive difficulty based on success rate
- **Achievement Badges**: Milestone rewards (7-day, 30-day, 100-day streaks)

### 📁 Robust Offline Storage
- **SQLite Database**: Optimized schema with indexing
- **Data Backup**: Export/import functionality
- **Storage Optimization**: Automatic cleanup of old completed tasks
- **Data Integrity**: Transaction-based operations

### ⚙️ Advanced Settings
- **Theme System**: Light, dark, auto (system), custom colors
- **Notification Manager**: Custom reminder times, snooze options
- **Data Management**: Export, import, selective reset
- **App Behavior**: Auto-archive completed tasks, default categories
- **Accessibility**: Font size, high contrast mode

## 🏗️ Improved Project Structure

```
/track-bloom
│
├── /lib
│   ├── /core
│   │   ├── /constants
│   │   │   ├── app_constants.dart      → App-wide constants
│   │   │   ├── database_constants.dart → DB table/column names
│   │   │   └── theme_constants.dart    → Colors, fonts, sizes
│   │   ├── /errors
│   │   │   ├── app_exceptions.dart     → Custom exceptions
│   │   │   └── error_handler.dart      → Global error handling
│   │   └── /utils
│   │       ├── date_utils.dart         → Date formatting & calculations
│   │       ├── notification_utils.dart → Local notification helpers
│   │       └── validation_utils.dart   → Input validation
│   │
│   ├── /data
│   │   ├── /models
│   │   │   ├── habit_model.dart        → Habit data structure
│   │   │   ├── task_model.dart         → Task data structure
│   │   │   ├── category_model.dart     → Category data structure
│   │   │   └── progress_model.dart     → Progress tracking data
│   │   ├── /repositories
│   │   │   ├── habit_repository.dart   → Habit CRUD operations
│   │   │   ├── task_repository.dart    → Task CRUD operations
│   │   │   └── settings_repository.dart → Settings management
│   │   └── /services
│   │       ├── database_service.dart   → SQLite initialization & management
│   │       ├── notification_service.dart → Local notification handling
│   │       └── backup_service.dart     → Data export/import
│   │
│   ├── /presentation
│   │   ├── /screens
│   │   │   ├── /home
│   │   │   │   ├── home_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── daily_overview.dart
│   │   │   │       ├── habit_card.dart
│   │   │   │       └── task_card.dart
│   │   │   ├── /add_item
│   │   │   │   ├── add_item_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── item_form.dart
│   │   │   │       └── category_selector.dart
│   │   │   ├── /progress
│   │   │   │   ├── progress_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── streak_display.dart
│   │   │   │       ├── weekly_heatmap.dart
│   │   │   │       └── achievement_badges.dart
│   │   │   └── /settings
│   │   │       ├── settings_screen.dart
│   │   │       └── widgets/
│   │   │           ├── theme_selector.dart
│   │   │           └── data_management.dart
│   │   ├── /widgets
│   │   │   ├── /common
│   │   │   │   ├── custom_button.dart
│   │   │   │   ├── custom_card.dart
│   │   │   │   └── loading_indicator.dart
│   │   │   └── /animated
│   │   │       ├── slide_animation.dart
│   │   │       └── fade_animation.dart
│   │   └── /providers
│   │       ├── habit_provider.dart     → Habit state management
│   │       ├── task_provider.dart      → Task state management
│   │       ├── theme_provider.dart     → Theme state management
│   │       └── settings_provider.dart  → Settings state management
│   │
│   └── main.dart                       → App entry point
│
├── /assets
│   ├── /images
│   │   ├── /icons                      → Custom app icons
│   │   └── /illustrations              → Empty state illustrations
│   ├── /sounds
│   │   └── completion_sound.wav        → Success notification sound
│   └── /fonts                          → Custom fonts (if needed)
│
├── /test
│   ├── /unit
│   │   ├── /models                     → Model tests
│   │   ├── /repositories               → Repository tests
│   │   └── /services                   → Service tests
│   ├── /widget                         → Widget tests
│   └── /integration                    → Integration tests
│
├── pubspec.yaml                        → Dependencies & assets
├── analysis_options.yaml               → Linting rules
└── README.md                           → Project documentation
```

## 🔧 Technology Stack

### Core Technologies
- **Flutter 3.x**: Cross-platform framework
- **Dart 3.x**: Programming language
- **SQLite**: Local database via `sqflite` package
- **Provider**: State management solution
- **Notifications**: Flutter Local notifications
<!-- 
### Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0              # SQLite database
  provider: ^6.0.5             # State management
  flutter_local_notifications: ^16.1.0  # Local notifications
  shared_preferences: ^2.2.2   # Simple key-value storage
  intl: ^0.19.0                # Date formatting
  path: ^1.8.3                 # File path utilities
  flutter_colorpicker: ^1.0.3  # Theme customization
  file_picker: ^6.1.1          # File import/export
  permission_handler: ^11.1.0  # Notification permissions

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0        # Linting rules
  mockito: ^5.4.2              # Testing mocks
  build_runner: ^2.4.7         # Code generation
``` -->

## 🎨 UI/UX Enhancements

### Design Principles
- **Minimalist Interface**: Clean, distraction-free design
- **Intuitive Navigation**: Bottom navigation with 4 main tabs
- **Consistent Theming**: Material Design 3 with custom color schemes
- **Accessibility**: Screen reader support, high contrast options
- **Performance**: Smooth animations, efficient list rendering

### Screen Flow
1. **Home Screen**: Today's tasks and habits overview
2. **Add Screen**: Quick item creation with smart defaults
3. **Progress Screen**: Analytics and achievement tracking
4. **Settings Screen**: Customization and data management

## 🚀 Advanced Features

### Smart Notifications
- **Intelligent Timing**: ML-based optimal reminder times
- **Contextual Reminders**: Location-based habit reminders
- **Streak Alerts**: Motivational messages for streaks
- **Achievement Notifications**: Celebration of milestones

### Analytics & Insights
- **Habit Correlation**: Identify patterns between habits
- **Productivity Metrics**: Task completion rates over time
- **Personal Insights**: Weekly summary with recommendations
- **Goal Setting**: SMART goal framework integration

### Data Management
- **Automatic Backup**: Daily local backups
- **Cloud Sync** (Optional): Encrypted cloud storage
- **Data Export**: JSON, CSV formats
- **Privacy First**: No telemetry, no tracking

## 📱 Platform Considerations

### Mobile Optimization
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Gesture Support**: Swipe actions, pull-to-refresh
- **Offline First**: Full functionality without internet
- **Battery Efficient**: Optimized background processing

### Future Enhancements
- **Widget Support**: Home screen widgets for quick access
- **Wear OS**: Companion app for smartwatches
- **Voice Commands**: Voice-to-text for quick adding
- **Collaboration**: Optional family/team habit tracking

## 🔒 Privacy & Security

### Data Protection
- **Local Storage**: All data stays on device
- **Encryption**: Sensitive data encrypted at rest
- **No Tracking**: Zero telemetry or analytics
- **Open Source**: Transparent codebase

### User Control
- **Data Ownership**: Complete control over personal data
- **Selective Sharing**: Choose what to backup/export
- **Privacy Settings**: Granular privacy controls
- **Audit Trail**: View all data operations

This enhanced structure provides a solid foundation for building a robust, user-friendly habit tracker that can scale with additional features while maintaining simplicity and privacy.

## Phases
### Phase 1 - MVP
Goal: Get users tracking habits and tasks immediately with zero friction.
Features

- ✅ Add Tasks/Habits: Simple form with title and type (task/habit)
- ✅ Today's List: View all items for today
- ✅ Mark Complete: Tap to complete tasks/habits
- ✅ Basic Storage: SQLite with minimal schema
- ✅ Simple UI: Material Design, light theme only

#### Project Structure (Minimal)
/lib
├── /models
│   ├── item_model.dart          → Single model for tasks/habits
│   └── item_type.dart           → Enum: task, habit
├── /services
│   └── database_service.dart    → Basic SQLite operations
├── /screens
│   ├── home_screen.dart         → Main list view
│   └── add_item_screen.dart     → Simple add form
├── /widgets
│   └── item_tile.dart           → List item widget
└── main.dart

#### Success Metrics
- Users can add items in under 10 seconds
- Daily completion rate tracking works
- App loads in under 2 seconds
- Zero crashes on basic operations


### 🔧 Phase 2: Polish & Usability
Goal: Make the app more pleasant to use and add essential quality-of-life features.

New Features

- ✅ Dark Theme: Theme toggle in settings
- ✅ Delete Items: Swipe to delete completed tasks
- ✅ Basic Streak: Show current streak for habits
- ✅ Settings Screen: Theme toggle, about info
- ✅ Better UX: Loading states, empty states, animations
- ✅ Data Persistence: Habits reset daily, tasks persist until deleted

#### Success Metrics

- Theme switching works smoothly
- Streak counting is accurate
- App feels responsive with animations
- Users can recover from accidental deletions


### 📊 Phase 3: Progress Tracking (Week 5-6)
Goal: Give users insights into their progress and motivation to continue.

New Features

- ✅ Progress Screen: New tab for analytics
- ✅ Weekly View: See completion patterns
- ✅ Habit Statistics: Success rate, longest streak
- ✅ Simple Charts: Basic completion visualization
- ✅ Habit History: View past completions

#### Success Metrics
- Progress screen loads under 3 seconds
- Charts are easy to understand
- Users can see their improvement over time
- Streak calculations are accurate


### 🎨 Phase 4: Enhanced UX (Week 7-8)
Goal: Make the app more engaging and customizable.

New Features

- ✅ Categories: Organize habits/tasks by type
- ✅ Priority Levels: High, medium, low priority
- ✅ Due Dates: Optional due dates for tasks
- ✅ Search & Filter: Find items quickly
- ✅ Bulk Actions: Multi-select and batch operations
- ✅ Better Animations: Smooth transitions and micro-interactions

#### Success Metrics

- Categories help organize items effectively
- Search returns results in under 1 second
- Bulk actions work smoothly
- UI feels polished and responsive


### 🔔 Phase 5: Smart Features (Week 9-10)
Goal: Add intelligent features that provide real value without complexity.

New Features

- ✅ Local Notifications: Habit reminders
- ✅ Smart Suggestions: Suggest optimal reminder times
- ✅ Habit Streaks: Advanced streak tracking with recovery
- ✅ Achievement Badges: Milestone celebrations
- ✅ Weekly Summary: Progress insights and recommendations

#### New Dependencies
yamldependencies:
  - flutter_local_notifications: ^16.1.0
  - permission_handler: ^11.1.0
  - timezone: ^0.9.2

#### Success Metrics

- Notifications arrive at correct times
- Achievement system motivates continued use
- Weekly summaries provide actionable insights
- No notification spam or annoyance


### 🚀 Phase 6: Data & Advanced Features (Week 11-12)
Goal: Add powerful features for advanced users while maintaining simplicity.

New Features

- ✅ Data Export/Import: Backup and restore functionality
- ✅ Subtasks: Break down complex tasks
- ✅ Habit Templates: Common habit presets
- ✅ Advanced Analytics: Trends, correlations, insights
- ✅ Customizable Widgets: Personalize the experience

#### Success Metrics

- Data export/import works reliably
- Subtasks improve task completion rates
- Templates speed up habit creation
- Advanced analytics provide valuable insights
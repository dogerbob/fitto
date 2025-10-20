import 'package:fitto/models/exercise.dart';
import 'package:fitto/models/workout.dart';
import 'package:fitto/services/storage_service.dart';

class WorkoutService {
  final StorageService _storage = StorageService();
  List<Exercise> _exercises = [];
  List<Workout> _workouts = [];

  Future<void> initialize() async {
    await _loadExercises();
    await _loadWorkouts();
    
    if (_exercises.isEmpty) {
      await _createSampleExercises();
    }
    if (_workouts.isEmpty) {
      await _createSampleWorkouts();
    }
  }

  Future<void> _loadExercises() async {
    final list = await _storage.getList(StorageService.exercisesKey);
    _exercises = list.map((json) => Exercise.fromJson(json)).toList();
  }

  Future<void> _loadWorkouts() async {
    final list = await _storage.getList(StorageService.workoutsKey);
    _workouts = list.map((json) => Workout.fromJson(json)).toList();
  }

  Future<void> _createSampleExercises() async {
    final now = DateTime.now();
    _exercises = [
      Exercise(id: '1', name: 'Push-ups', category: 'Strength', muscleGroup: 'Chest', description: 'Classic chest exercise', difficulty: 'Beginner', createdAt: now, updatedAt: now),
      Exercise(id: '2', name: 'Squats', category: 'Strength', muscleGroup: 'Legs', description: 'Lower body powerhouse', difficulty: 'Beginner', createdAt: now, updatedAt: now),
      Exercise(id: '3', name: 'Pull-ups', category: 'Strength', muscleGroup: 'Back', description: 'Upper body strength', difficulty: 'Intermediate', createdAt: now, updatedAt: now),
      Exercise(id: '4', name: 'Plank', category: 'Strength', muscleGroup: 'Core', description: 'Core stability exercise', difficulty: 'Beginner', createdAt: now, updatedAt: now),
      Exercise(id: '5', name: 'Running', category: 'Cardio', muscleGroup: 'Full Body', description: 'Cardiovascular endurance', difficulty: 'Beginner', createdAt: now, updatedAt: now),
      Exercise(id: '6', name: 'Cycling', category: 'Cardio', muscleGroup: 'Legs', description: 'Low impact cardio', difficulty: 'Beginner', createdAt: now, updatedAt: now),
      Exercise(id: '7', name: 'Yoga Flow', category: 'Flexibility', muscleGroup: 'Full Body', description: 'Mind-body connection', difficulty: 'Beginner', createdAt: now, updatedAt: now),
      Exercise(id: '8', name: 'Stretching', category: 'Flexibility', muscleGroup: 'Full Body', description: 'Improve flexibility', difficulty: 'Beginner', createdAt: now, updatedAt: now),
    ];
    await _saveExercises();
  }

  Future<void> _createSampleWorkouts() async {
    final now = DateTime.now();
    _workouts = [
      Workout(id: '1', userId: 'user_1', date: now.subtract(Duration(days: 1)), exerciseId: '1', sets: 3, reps: 15, weight: 0, duration: 10, notes: 'Felt great!', createdAt: now, updatedAt: now),
      Workout(id: '2', userId: 'user_1', date: now.subtract(Duration(days: 1)), exerciseId: '2', sets: 4, reps: 12, weight: 0, duration: 15, createdAt: now, updatedAt: now),
      Workout(id: '3', userId: 'user_1', date: now, exerciseId: '5', sets: 1, reps: 1, weight: 0, duration: 30, notes: '5km run', createdAt: now, updatedAt: now),
    ];
    await _saveWorkouts();
  }

  Future<void> _saveExercises() async {
    await _storage.saveList(StorageService.exercisesKey, _exercises.map((e) => e.toJson()).toList());
  }

  Future<void> _saveWorkouts() async {
    await _storage.saveList(StorageService.workoutsKey, _workouts.map((e) => e.toJson()).toList());
  }

  List<Exercise> get exercises => _exercises;
  List<Workout> get workouts => _workouts;

  List<Exercise> getExercisesByCategory(String category) => _exercises.where((e) => e.category == category).toList();

  Exercise? getExerciseById(String id) => _exercises.where((e) => e.id == id).firstOrNull;

  List<Workout> getWorkoutsByDate(DateTime date) => _workouts.where((w) => w.date.year == date.year && w.date.month == date.month && w.date.day == date.day).toList();

  Future<void> addWorkout(Workout workout) async {
    _workouts.add(workout);
    await _saveWorkouts();
  }

  Future<void> deleteWorkout(String id) async {
    _workouts.removeWhere((w) => w.id == id);
    await _saveWorkouts();
  }
}

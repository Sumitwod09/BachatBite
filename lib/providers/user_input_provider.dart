import 'package:flutter/material.dart';
import '../data/models/user_input.dart';
import '../data/services/storage_service.dart';
import '../core/constants/app_constants.dart';

/// Manages the setup wizard state and user input.
class UserInputProvider extends ChangeNotifier {
  // ── Wizard step tracking ──
  int _currentStep = 0;
  int get currentStep => _currentStep;

  // ── Input fields ──
  double _totalBudget = 3500;
  int _durationInDays = 7;
  int _numberOfPeople = 2;
  String _dietaryPreference = 'Veg';
  int _maxCookingTimeMinutes = 30;
  int _eatingOutMealsPerWeek = 2;
  bool _hasFridge = true;
  bool _hasSavedSession = false;

  // ── Getters ──
  double get totalBudget => _totalBudget;
  int get durationInDays => _durationInDays;
  int get numberOfPeople => _numberOfPeople;
  String get dietaryPreference => _dietaryPreference;
  int get maxCookingTimeMinutes => _maxCookingTimeMinutes;
  int get eatingOutMealsPerWeek => _eatingOutMealsPerWeek;
  bool get hasFridge => _hasFridge;
  bool get hasSavedSession => _hasSavedSession;

  /// Computed daily budget preview
  double get dailyBudgetPreview {
    if (_durationInDays <= 0 || _numberOfPeople <= 0) return 0;
    return _totalBudget / (_durationInDays * _numberOfPeople);
  }

  /// Check for existing session on init
  Future<void> init() async {
    _hasSavedSession = await StorageService.hasSavedSession();
    if (_hasSavedSession) {
      final saved = await StorageService.loadUserInput();
      if (saved != null) {
        _totalBudget = saved.totalBudget;
        _durationInDays = saved.durationInDays;
        _numberOfPeople = saved.numberOfPeople;
        _dietaryPreference = saved.dietaryPreference;
        _maxCookingTimeMinutes = saved.maxCookingTimeMinutes;
        _eatingOutMealsPerWeek = saved.eatingOutMealsPerWeek;
        _hasFridge = saved.hasFridge;
      }
    }
    notifyListeners();
  }

  // ── Setters ──

  void setBudget(double value) {
    _totalBudget = value.clamp(AppConstants.minBudget, AppConstants.maxBudget);
    notifyListeners();
  }

  void setDuration(int days) {
    _durationInDays = days;
    notifyListeners();
  }

  void setPeople(int count) {
    _numberOfPeople = count.clamp(AppConstants.minPeople, AppConstants.maxPeople);
    notifyListeners();
  }

  void setDietaryPreference(String pref) {
    _dietaryPreference = pref;
    notifyListeners();
  }

  void setMaxCookingTime(int minutes) {
    _maxCookingTimeMinutes = minutes.clamp(
        AppConstants.minCookingTime, AppConstants.maxCookingTime);
    notifyListeners();
  }

  void setEatingOutFrequency(int meals) {
    _eatingOutMealsPerWeek = meals.clamp(0, 7);
    notifyListeners();
  }

  void setHasFridge(bool value) {
    _hasFridge = value;
    notifyListeners();
  }

  // ── Wizard navigation ──

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void prevStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    _currentStep = step.clamp(0, 2);
    notifyListeners();
  }

  // ── Finalization ──

  /// Build the UserInput and save to localStorage.
  Future<UserInput> finalize() async {
    final input = UserInput(
      totalBudget: _totalBudget,
      durationInDays: _durationInDays,
      numberOfPeople: _numberOfPeople,
      dietaryPreference: _dietaryPreference,
      maxCookingTimeMinutes: _maxCookingTimeMinutes,
      eatingOutMealsPerWeek: _eatingOutMealsPerWeek,
      hasFridge: _hasFridge,
    );
    await StorageService.saveUserInput(input);
    _hasSavedSession = true;
    notifyListeners();
    return input;
  }

  /// Reset wizard state.
  void resetWizard() {
    _currentStep = 0;
    notifyListeners();
  }
}

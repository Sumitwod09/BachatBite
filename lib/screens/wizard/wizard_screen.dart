import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_input_provider.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/grocery_provider.dart';
import 'step_budget.dart';
import 'step_people.dart';
import 'step_preferences.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({super.key});

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onFinish() async {
    final userProvider = context.read<UserInputProvider>();
    final mealPlanProvider = context.read<MealPlanProvider>();
    final groceryProvider = context.read<GroceryProvider>();

    final input = await userProvider.finalize();
    mealPlanProvider.generatePlan(input);
    await groceryProvider.generateFromPlan(
        mealPlanProvider.currentPlan!, input.numberOfPeople);

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserInputProvider>();
    final currentStep = userProvider.currentStep;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () {
                        if (currentStep > 0) {
                          userProvider.prevStep();
                          _goToPage(currentStep - 1);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Setup Wizard',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // ── Progress indicator ──
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 8),
                child: _buildProgressBar(currentStep),
              ),

              // ── Step label ──
              Text(
                'Step ${currentStep + 1} of 3',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // ── Pages ──
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    StepBudget(),
                    StepPeople(),
                    StepPreferences(),
                  ],
                ),
              ),

              // ── Bottom button ──
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentStep < 2) {
                        userProvider.nextStep();
                        _goToPage(currentStep + 1);
                      } else {
                        _onFinish();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentStep == 2
                          ? AppColors.savingsGreen
                          : AppColors.saffron,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      currentStep == 2 ? '✨ GENERATE PLAN' : 'NEXT →',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(int currentStep) {
    return Row(
      children: List.generate(3, (i) {
        final isActive = i <= currentStep;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            height: 4,
            margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: isActive ? AppColors.saffron : AppColors.surfaceLight,
            ),
          ),
        );
      }),
    );
  }
}

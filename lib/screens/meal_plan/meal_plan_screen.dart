import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/budget_utils.dart';
import '../../providers/meal_plan_provider.dart';
import '../../data/models/recipe.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static const _slotColors = {
    'Breakfast': AppColors.mealBreakfast,
    'Lunch': AppColors.mealLunch,
    'Dinner': AppColors.mealDinner,
  };

  static const _slotIcons = {
    'Breakfast': Icons.wb_sunny_outlined,
    'Lunch': Icons.wb_cloudy_outlined,
    'Dinner': Icons.nights_stay_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final mp = context.watch<MealPlanProvider>();
    final plan = mp.currentPlan;
    if (plan == null) {
      return Scaffold(body: Center(child: Text('No plan generated', style: GoogleFonts.inter(color: AppColors.textMuted))));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
              child: Row(children: [
                IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => Navigator.pop(context)),
                Text('Your Weekly Plan', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ]),
            ),

            // Day tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppColors.saffron,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700),
                unselectedLabelStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500),
                indicatorColor: AppColors.saffron,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.transparent,
                tabs: AppConstants.daysOfWeek.map((d) => Tab(text: d.substring(0, 3))).toList(),
              ),
            ),

            // Meal cards
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: AppConstants.daysOfWeek.map((day) {
                  final dayMeals = plan.days[day] ?? {};
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: AppConstants.mealSlots.map((slot) {
                      final recipe = dayMeals[slot];
                      if (recipe == null) return const SizedBox.shrink();
                      return _mealCard(context, day, slot, recipe, mp);
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _mealCard(BuildContext context, String day, String slot, Recipe recipe, MealPlanProvider mp) {
    final color = _slotColors[slot] ?? AppColors.saffron;
    final icon = _slotIcons[slot] ?? Icons.restaurant;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), color: AppColors.surface,
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.of(context).pushNamed('/recipe/${recipe.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Slot header
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Text(slot.toUpperCase(), style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700, color: color, letterSpacing: 1)),
                const Spacer(),
                // Swap button
                GestureDetector(
                  onTap: () => mp.swapMeal(day, slot),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.surfaceLight, border: Border.all(color: AppColors.divider)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.swap_horiz, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text('Swap', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                    ]),
                  ),
                ),
              ]),
              const SizedBox(height: 12),

              // Recipe name
              Text(recipe.name, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),

              // Meta
              Row(children: [
                _metaChip(BudgetUtils.formatRupee(recipe.costPerPerson), Icons.monetization_on_outlined, AppColors.turmericGold),
                const SizedBox(width: 10),
                _metaChip('${recipe.timeMinutes} min', Icons.timer_outlined, AppColors.textMuted),
                const SizedBox(width: 10),
                _metaChip(recipe.type, Icons.eco_outlined, recipe.type == 'Veg' ? AppColors.savingsGreen : AppColors.warningAmber),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _metaChip(String text, IconData icon, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 4),
      Text(text, style: GoogleFonts.inter(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
    ]);
  }
}

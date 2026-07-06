import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/budget_utils.dart';
import '../../providers/user_input_provider.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/grocery_provider.dart';
import '../../data/services/storage_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = context.watch<MealPlanProvider>();
    final up = context.watch<UserInputProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Dashboard', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text('Your meal plan summary', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 24),

              // Metrics row
              Row(children: [
                _metricCard('Target', BudgetUtils.formatRupee(up.totalBudget), AppColors.saffron, Icons.flag_outlined),
                const SizedBox(width: 10),
                _metricCard('Est. Cost', BudgetUtils.formatRupee(mp.totalEstimatedCost), AppColors.mealLunch, Icons.receipt_long_outlined),
                const SizedBox(width: 10),
                _metricCard('Savings', BudgetUtils.formatRupee(mp.projectedSavings.abs()),
                    mp.projectedSavings >= 0 ? AppColors.savingsGreen : AppColors.errorRed,
                    mp.projectedSavings >= 0 ? Icons.trending_up : Icons.trending_down),
              ]),
              const SizedBox(height: 20),

              // Savings banner
              if (mp.projectedSavings > 0)
                Container(
                  width: double.infinity, padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppColors.savingsGreen.withValues(alpha: 0.08),
                    border: Border.all(color: AppColors.savingsGreen.withValues(alpha: 0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.celebration, color: AppColors.savingsGreen, size: 28),
                    const SizedBox(width: 12),
                    Expanded(child: Text('You\'re saving ${mp.savingsPercent.toStringAsFixed(0)}% of your budget!',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.savingsGreen))),
                  ]),
                ),
              const SizedBox(height: 24),

              // Recommendations
              Text('💡 Recommendations', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              ...mp.recommendations.map((tip) => _tipCard(tip)),
              const SizedBox(height: 28),

              // Nav cards
              _navCard(context, '📅', 'View Meal Plan', 'See your 7-day schedule', '/meal-plan', AppColors.mealBreakfast),
              const SizedBox(height: 10),
              _navCard(context, '🛒', 'View Grocery List', 'Your complete shopping checklist', '/grocery', AppColors.mealLunch),
              const SizedBox(height: 10),
              _resetCard(context),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _metricCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14), color: AppColors.surface,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 10),
          Text(value, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
        ]),
      ),
    );
  }

  Widget _tipCard(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity, padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.surface, border: Border.all(color: AppColors.divider)),
        child: Text(tip, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
      ),
    );
  }

  Widget _navCard(BuildContext context, String emoji, String title, String subtitle, String route, Color color) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(route),
      child: Container(
        width: double.infinity, padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14), color: AppColors.surface,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
          ])),
          Icon(Icons.chevron_right, color: color),
        ]),
      ),
    );
  }

  Widget _resetCard(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final confirm = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('Reset Plan?', style: GoogleFonts.outfit(color: AppColors.textPrimary)),
          content: Text('This will clear your current plan and settings.', style: GoogleFonts.inter(color: AppColors.textSecondary)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Reset', style: TextStyle(color: AppColors.errorRed))),
          ],
        ));
        if (confirm == true && context.mounted) {
          await StorageService.clearAll();
          context.read<MealPlanProvider>().resetPlan();
          context.read<GroceryProvider>().clear();
          context.read<UserInputProvider>().init();
          Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
        }
      },
      child: Container(
        width: double.infinity, padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: AppColors.errorRed.withValues(alpha: 0.06), border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.2))),
        child: Row(children: [
          Icon(Icons.refresh, color: AppColors.errorRed, size: 24),
          const SizedBox(width: 16),
          Text('Reset Plan', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.errorRed)),
        ]),
      ),
    );
  }
}

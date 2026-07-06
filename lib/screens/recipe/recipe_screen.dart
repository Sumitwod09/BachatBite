import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/budget_utils.dart';
import '../../data/models/recipe.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../providers/user_input_provider.dart';

class RecipeScreen extends StatelessWidget {
  final String recipeId;
  const RecipeScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    final recipe = RecipeRepository.getRecipeById(recipeId);
    if (recipe == null) {
      return Scaffold(body: Center(child: Text('Recipe not found', style: GoogleFonts.inter(color: AppColors.textMuted))));
    }
    final people = context.watch<UserInputProvider>().numberOfPeople;

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
                Expanded(child: Text('Recipe', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Title
                  Text(recipe.name, style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 16),

                  // Badges
                  Row(children: [
                    _badge(BudgetUtils.formatRupee(recipe.costPerPerson) + '/head', AppColors.turmericGold),
                    const SizedBox(width: 10),
                    _badge('${recipe.timeMinutes} min', AppColors.mealLunch),
                    const SizedBox(width: 10),
                    _badge(recipe.type, recipe.type == 'Veg' ? AppColors.savingsGreen : AppColors.warningAmber),
                  ]),
                  const SizedBox(height: 28),

                  // Ingredients
                  Text('Ingredients', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('Scaled for $people ${people == 1 ? 'person' : 'people'}',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 12),
                  ...recipe.ingredients.map((ing) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.surface, border: Border.all(color: AppColors.divider)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(children: [
                        Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _categoryColor(ing.category)),
                        ),
                        const SizedBox(width: 12),
                        Text(ing.name, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary)),
                      ]),
                      Text(ing.formattedQuantity(people), style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.turmericGold)),
                    ]),
                  )),
                  const SizedBox(height: 28),

                  // Steps
                  Text('Steps', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  ...recipe.steps.asMap().entries.map((entry) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.surface, border: Border.all(color: AppColors.divider)),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.saffron.withValues(alpha: 0.15)),
                        child: Center(child: Text('${entry.key + 1}', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.saffron))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(entry.value, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.5))),
                    ]),
                  )),

                  // Total cost
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: AppColors.cardGradient, border: Border.all(color: AppColors.divider)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Total cost for $people ${people == 1 ? 'person' : 'people'}',
                          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
                      Text(BudgetUtils.formatRupee(recipe.totalCost(people)),
                          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.turmericGold)),
                    ]),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: color.withValues(alpha: 0.12), border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Text(text, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Vegetables': return AppColors.savingsGreen;
      case 'Groceries': return AppColors.turmericGold;
      case 'Dairy/Eggs': return AppColors.mealBreakfast;
      default: return AppColors.textMuted;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/user_input_provider.dart';

class StepPreferences extends StatelessWidget {
  const StepPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserInputProvider>();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('🍽️ Your Preferences', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text('Help us personalize your meal plan.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
        const SizedBox(height: 32),

        // Diet
        _label('Dietary Preference'),
        const SizedBox(height: 10),
        Row(children: [
          _chip('🥬 Veg', 'Veg', p),
          const SizedBox(width: 8),
          _chip('🍗 Non-Veg', 'Non-Veg', p),
          const SizedBox(width: 8),
          _chip('🥚 Eggitarian', 'Eggitarian', p),
        ]),
        const SizedBox(height: 28),

        // Cooking time
        _label('Max Cooking Time'),
        const SizedBox(height: 6),
        Row(children: [
          Text('${p.maxCookingTimeMinutes} min', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.turmericGold)),
          const SizedBox(width: 8),
          Text('per meal', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
        ]),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.saffron,
            inactiveTrackColor: AppColors.surfaceLight,
            thumbColor: AppColors.saffron,
            overlayColor: AppColors.saffron.withValues(alpha: 0.15),
            trackHeight: 6,
          ),
          child: Slider(
            value: p.maxCookingTimeMinutes.toDouble(),
            min: AppConstants.minCookingTime.toDouble(),
            max: AppConstants.maxCookingTime.toDouble(),
            divisions: (AppConstants.maxCookingTime - AppConstants.minCookingTime) ~/ AppConstants.cookingTimeStep,
            onChanged: (v) => p.setMaxCookingTime(v.round()),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${AppConstants.minCookingTime} min', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
          Text('${AppConstants.maxCookingTime} min', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
        ]),
        const SizedBox(height: 28),

        // Eating out
        _label('Eating Out Frequency'),
        const SizedBox(height: 6),
        Text('${p.eatingOutMealsPerWeek} meals/week outside', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: List.generate(8, (i) {
          final sel = p.eatingOutMealsPerWeek == i;
          return GestureDetector(
            onTap: () => p.setEatingOutFrequency(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44, height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: sel ? AppColors.saffron.withValues(alpha: 0.2) : AppColors.surfaceLight,
                border: Border.all(color: sel ? AppColors.saffron : AppColors.divider, width: sel ? 2 : 1),
              ),
              child: Center(child: Text('$i', style: GoogleFonts.outfit(fontSize: 16, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, color: sel ? AppColors.saffron : AppColors.textSecondary))),
            ),
          );
        })),
        const SizedBox(height: 28),

        // Fridge
        _label('Do you have a Fridge?'),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => p.setHasFridge(!p.hasFridge),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: p.hasFridge ? AppColors.mealDinner.withValues(alpha: 0.1) : AppColors.warningAmber.withValues(alpha: 0.1),
              border: Border.all(color: p.hasFridge ? AppColors.mealDinner.withValues(alpha: 0.4) : AppColors.warningAmber.withValues(alpha: 0.4), width: 2),
            ),
            child: Row(children: [
              Text(p.hasFridge ? '❄️' : '🚫', style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.hasFridge ? 'Yes, I have a fridge' : 'No fridge available',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: p.hasFridge ? AppColors.mealDinner : AppColors.warningAmber)),
                const SizedBox(height: 2),
                Text(p.hasFridge ? 'Dairy & perishable recipes included' : 'Only non-perishable recipes will be shown',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
              ])),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  p.hasFridge ? Icons.toggle_on : Icons.toggle_off,
                  key: ValueKey(p.hasFridge),
                  size: 40, color: p.hasFridge ? AppColors.mealDinner : AppColors.textMuted,
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 32),

        // Summary
        Container(
          width: double.infinity, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: AppColors.cardGradient, border: Border.all(color: AppColors.divider)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Summary', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            _summaryRow('Diet', p.dietaryPreference),
            _summaryRow('Cooking time', '≤ ${p.maxCookingTimeMinutes} min'),
            _summaryRow('Outside meals', '${p.eatingOutMealsPerWeek}/week'),
            _summaryRow('Fridge', p.hasFridge ? 'Yes ❄️' : 'No'),
            _summaryRow('Budget', '₹${p.totalBudget.toInt()} / ${p.durationInDays} days'),
            _summaryRow('People', '${p.numberOfPeople}'),
          ]),
        ),
      ]),
    );
  }

  Widget _label(String text) => Text(text, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 0.5));

  Widget _chip(String label, String value, UserInputProvider p) {
    final sel = p.dietaryPreference == value;
    return Expanded(child: GestureDetector(
      onTap: () => p.setDietaryPreference(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: sel ? AppColors.saffron.withValues(alpha: 0.15) : AppColors.surfaceLight, border: Border.all(color: sel ? AppColors.saffron : AppColors.divider, width: sel ? 2 : 1)),
        child: Text(label, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, color: sel ? AppColors.saffron : AppColors.textSecondary)),
      ),
    ));
  }

  Widget _summaryRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
      Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
    ]),
  );
}

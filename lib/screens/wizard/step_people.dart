import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/budget_utils.dart';
import '../../providers/user_input_provider.dart';

class StepPeople extends StatelessWidget {
  const StepPeople({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserInputProvider>();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('👨‍👩‍👧‍👦 How Many People?', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('We\'ll scale recipes and groceries for your household.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 48),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _counterBtn(Icons.remove, () => p.setPeople(p.numberOfPeople - 1)),
                const SizedBox(width: 32),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                  child: Text('${p.numberOfPeople}', key: ValueKey(p.numberOfPeople),
                      style: GoogleFonts.outfit(fontSize: 64, fontWeight: FontWeight.w800, color: AppColors.turmericGold)),
                ),
                const SizedBox(width: 32),
                _counterBtn(Icons.add, () => p.setPeople(p.numberOfPeople + 1)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(child: Text('people', style: GoogleFonts.inter(fontSize: 16, color: AppColors.textMuted))),
          const SizedBox(height: 24),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(p.numberOfPeople, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.person, size: 32, color: AppColors.saffron.withValues(alpha: 0.7 + (i * 0.04).clamp(0, 0.3))),
              )),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: AppColors.cardGradient, border: Border.all(color: AppColors.divider)),
            child: Column(children: [
              Text('Per person daily budget', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
              const SizedBox(height: 8),
              Text(BudgetUtils.formatRupee(p.dailyBudgetPreview), style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.turmericGold)),
              const SizedBox(height: 4),
              Text('₹${p.totalBudget.toInt()} ÷ ${p.durationInDays} days ÷ ${p.numberOfPeople} people', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52, height: 52,
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.surfaceLight, border: Border.all(color: AppColors.divider)),
        child: Icon(icon, color: AppColors.saffron, size: 26),
      ),
    );
  }
}

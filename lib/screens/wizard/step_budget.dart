import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/budget_utils.dart';
import '../../providers/user_input_provider.dart';

class StepBudget extends StatelessWidget {
  const StepBudget({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserInputProvider>();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('💰 Set Your Budget',
              style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('How much do you want to spend on food?',
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 36),
          Text('Total Budget', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: AppColors.surfaceLight, border: Border.all(color: AppColors.divider)),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(color: AppColors.saffron.withValues(alpha: 0.15), borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14))),
                child: Text('₹', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.saffron)),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: p.totalBudget.toInt().toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  decoration: InputDecoration(border: InputBorder.none, filled: false, hintText: '3500', hintStyle: GoogleFonts.outfit(fontSize: 24, color: AppColors.textMuted), contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                  onChanged: (val) { final v = double.tryParse(val); if (v != null) p.setBudget(v); },
                ),
              ),
            ]),
          ),
          const SizedBox(height: 32),
          Text('Duration', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          const SizedBox(height: 10),
          Row(children: AppConstants.durationOptions.entries.map((e) {
            final sel = p.durationInDays == e.value;
            return Expanded(child: GestureDetector(
              onTap: () => p.setDuration(e.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250), margin: const EdgeInsets.symmetric(horizontal: 4), padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: sel ? AppColors.saffron.withValues(alpha: 0.15) : AppColors.surfaceLight, border: Border.all(color: sel ? AppColors.saffron : AppColors.divider, width: sel ? 2 : 1)),
                child: Text(e.key, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 13, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, color: sel ? AppColors.saffron : AppColors.textSecondary)),
              ),
            ));
          }).toList()),
          const SizedBox(height: 40),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: AppColors.cardGradient, border: Border.all(color: AppColors.divider)),
            child: Column(children: [
              Text('Daily budget per person', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
              const SizedBox(height: 8),
              Text(BudgetUtils.formatRupee(p.dailyBudgetPreview), style: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.turmericGold)),
              const SizedBox(height: 4),
              Text('for ${p.durationInDays} days', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
            ]),
          ),
        ],
      ),
    );
  }
}

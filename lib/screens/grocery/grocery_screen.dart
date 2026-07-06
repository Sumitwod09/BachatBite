import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/grocery_provider.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GroceryProvider>();
    final items = gp.items;

    // Group by category
    final Map<String, List<int>> grouped = {};
    for (int i = 0; i < items.length; i++) {
      grouped.putIfAbsent(items[i].category, () => []).add(i);
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
                Expanded(child: Text('Grocery Checklist', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
              ]),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('${gp.purchasedCount} of ${gp.totalItems} items',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  Text('${(gp.progressPercent * 100).toStringAsFixed(0)}%',
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.savingsGreen)),
                ]),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: gp.progressPercent, minHeight: 6,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: const AlwaysStoppedAnimation(AppColors.savingsGreen),
                  ),
                ),
              ]),
            ),

            // List
            Expanded(
              child: items.isEmpty
                  ? Center(child: Text('No items yet', style: GoogleFonts.inter(color: AppColors.textMuted)))
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: grouped.entries.map((entry) {
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
                            child: Row(children: [
                              Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: _catColor(entry.key))),
                              const SizedBox(width: 8),
                              Text(entry.key.toUpperCase(), style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1)),
                            ]),
                          ),
                          ...entry.value.map((idx) {
                            final item = items[idx];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: item.isPurchased ? AppColors.surfaceLight.withValues(alpha: 0.5) : AppColors.surface,
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => gp.togglePurchased(idx),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    child: Row(children: [
                                      Checkbox(
                                        value: item.isPurchased,
                                        onChanged: (_) => gp.togglePurchased(idx),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(item.name,
                                            style: GoogleFonts.inter(
                                              fontSize: 14, color: item.isPurchased ? AppColors.textMuted : AppColors.textPrimary,
                                              decoration: item.isPurchased ? TextDecoration.lineThrough : null,
                                            )),
                                      ),
                                      Text(item.formattedQuantity,
                                          style: GoogleFonts.outfit(
                                            fontSize: 13, fontWeight: FontWeight.w600,
                                            color: item.isPurchased ? AppColors.textMuted : AppColors.turmericGold,
                                          )),
                                    ]),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ]);
                      }).toList(),
                    ),
            ),
          ]),
        ),
      ),
      floatingActionButton: items.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => gp.uncheckAll(),
              backgroundColor: AppColors.surface,
              icon: const Icon(Icons.restart_alt, color: AppColors.saffron),
              label: Text('Uncheck All', style: GoogleFonts.inter(color: AppColors.saffron, fontWeight: FontWeight.w600)),
            )
          : null,
    );
  }

  Color _catColor(String cat) {
    switch (cat) {
      case 'Vegetables': return AppColors.savingsGreen;
      case 'Groceries': return AppColors.turmericGold;
      case 'Dairy/Eggs': return AppColors.mealBreakfast;
      default: return AppColors.textMuted;
    }
  }
}

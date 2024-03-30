import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/checklist_provider.dart';
import 'package:my_baby/providers/child_provider.dart';
import 'package:provider/provider.dart';

class ChecklistDetail {
  String key;
  String title;

  ChecklistDetail({required this.key, required this.title});
}

final Map<String, List<ChecklistDetail>> CHECKLIST = {
  "0-3": [
    ChecklistDetail(key: '01', title: "ตอบสนองต่อเสียง"),
    ChecklistDetail(key: '02', title: "เริ่มมีการยิ้มตอบสนองทางสังคม"),
    ChecklistDetail(key: '03', title: "มองตามวัตถุได้"),
    ChecklistDetail(key: '04', title: "จดจำใบหน้าได้"),
    ChecklistDetail(key: '05', title: "ได้รับวัคซีนแล้ว"),
  ],
  "4-6": [
    ChecklistDetail(key: '11', title: "Begins to babble and imitates sounds"),
    ChecklistDetail(
        key: '12', title: "Rolls over from stomach to back and vice versa."),
    ChecklistDetail(
        key: '13', title: "Can reach for objects and brings hands to mouth."),
    ChecklistDetail(key: '14', title: "Continue vaccination schedule."),
    ChecklistDetail(
        key: '15',
        title: "Engage with brightly colored toys to stimulate vision."),
  ],
};

class MyBabySection extends StatelessWidget {
  const MyBabySection({super.key});

  void _onCheck(BuildContext context, String key, bool isChecked) {
    context
        .read<ChecklistProvider>()
        .updateChecklist(key: key, isChecked: isChecked);
  }

  @override
  Widget build(BuildContext context) {
    final ageInMonth = context.watch<ChildProvider>().ageInMonths;

    final group = CHECKLIST.entries.firstWhereOrNull((e) {
      final range = e.key.split('-');
      final start = int.parse(range[0]);
      final end = int.parse(range[1]);
      return ageInMonth >= start && ageInMonth <= end;
    });

    final checklist = context.watch<ChecklistProvider>().checklist;
    return Container(
        margin: const EdgeInsets.only(top: AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppTheme.colorShade.background2,
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing28,
          vertical: AppTheme.spacing20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "my_baby.title".tr(),
              style: ThemeTextStyle.boldParagraph1(
                context,
                color: AppTheme.colorShade.text,
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              "${group?.key ?? ageInMonth} ${"month".tr()}",
              style: ThemeTextStyle.headline2(
                context,
                color: AppTheme.colorShade.success,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/newborn.png",
                  width: 251,
                  height: 251,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing40),
            if (group != null)
              ListView.separated(
                separatorBuilder: (ctx, index) =>
                    const SizedBox(height: AppTheme.spacing16),
                itemBuilder: (ctx, index) {
                  return CheckboxListTile(
                    title: group.value[index].title,
                    isChecked: checklist
                            .firstWhereOrNull(
                                (c) => c.key == group.value[index].key)
                            ?.isChecked ??
                        false,
                    onChanged: (value) {
                      _onCheck(context, group.value[index].key, value ?? false);
                    },
                  );
                },
                physics: const ClampingScrollPhysics(),
                itemCount: group.value.length,
                shrinkWrap: true,
              ),
          ],
        ));
  }
}

class CheckboxListTile extends StatelessWidget {
  final String title;
  final bool isChecked;
  final Function(bool?)? onChanged;

  const CheckboxListTile({
    super.key,
    required this.title,
    required this.onChanged,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            onChanged?.call(!isChecked);
          },
          child: isChecked
              ? Image.asset(
                  "assets/images/star-circle.png",
                  width: 35,
                  height: 35,
                )
              : Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppTheme.colorShade.placeholder, width: 1),
                  ),
                ),
        ),
        const SizedBox(width: AppTheme.spacing12),
        Text(
          title,
          style: ThemeTextStyle.paragraph1(context,
              color: AppTheme.colorShade.text),
        ),
      ],
    );
  }
}

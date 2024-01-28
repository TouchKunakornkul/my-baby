import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/providers/menu_provider.dart';

class NoteSection extends StatelessWidget {
  final List<Note> notes;
  const NoteSection({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: AppTheme.colorShade.background2,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "note.title".tr(),
            style: ThemeTextStyle.boldParagraph1(
              context,
              color: AppTheme.colorShade.text,
            ),
          ),
          const SizedBox(
            height: AppTheme.spacing6,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: notes.length,
            itemBuilder: (ctx, i) {
              final note = notes[i];
              String formattedDate =
                  DateFormat('dd MMM yyyy HH:mm').format(note.createdAt);
              return Container(
                padding: const EdgeInsets.all(AppTheme.spacing12),
                decoration: BoxDecoration(
                  color: AppTheme.colorShade.background,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.note,
                      style: ThemeTextStyle.paragraph1(context,
                          color: AppTheme.colorShade.text),
                    ),
                    Text(formattedDate,
                        style: ThemeTextStyle.paragraph4(context,
                            color: AppTheme.colorShade.placeholder)),
                  ],
                ),
              );
            },
            separatorBuilder: (ctx, i) {
              return const SizedBox(
                height: AppTheme.spacing8,
              );
            },
          )
        ],
      ),
    );
  }
}

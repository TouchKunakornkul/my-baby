import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/icons/custom_icons_icons.dart';
import 'package:my_baby/widgets/add_note_dialog.dart';
import 'package:my_baby/widgets/base_button.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:my_baby/widgets/note_section.dart';

const double CONTENT_HEIGHT = 472;

class BaseSection extends StatefulWidget {
  final IconData icon;
  final String title;
  final Widget subtitle;
  final VoidCallback onClickBook;
  final VoidCallback onAdd;
  final VoidCallback onEdit;
  final bool editable;
  final Widget content;
  final Widget header;
  final Function(String) onAddNote;
  final List<Note> notes;
  const BaseSection({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onClickBook,
    required this.content,
    required this.onAdd,
    required this.onEdit,
    this.editable = true,
    required this.header,
    required this.onAddNote,
    this.notes = const [],
  });

  @override
  State<BaseSection> createState() => _BaseSectionState();
}

class _BaseSectionState extends State<BaseSection> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // for go to bottom
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await Future.delayed(const Duration(milliseconds: 100));
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing12),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: CONTENT_HEIGHT,
                  decoration: BoxDecoration(
                    color: AppTheme.colorShade.background2,
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadius20),
                  ),
                  padding: const EdgeInsets.all(AppTheme.spacing20),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: ThemeTextStyle.headline2(context,
                                      color: AppTheme.colorShade.text),
                                ),
                                widget.subtitle,
                              ],
                            )
                          ],
                        ),
                        Wrap(
                          children: [
                            InkWell(
                              onTap: widget.onClickBook,
                              child: const Icon(
                                CustomIcons.book,
                                size: 24,
                              ),
                            ),
                            const SizedBox(
                              width: AppTheme.spacing20,
                            ),
                            InkWell(
                              onTap: widget.onEdit,
                              child: const Icon(
                                CustomIcons.edit,
                                size: 24,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: AppTheme.spacing20,
                    ),
                    widget.header,
                    Divider(
                      color: AppTheme.colorShade.placeholder,
                      height: 1,
                    ),
                    const SizedBox(
                      height: AppTheme.spacing16,
                    ),
                    Expanded(
                        child: Scrollbar(
                            thumbVisibility: true,
                            controller: _scrollController,
                            child: SingleChildScrollView(
                                controller: _scrollController,
                                child: widget.content))),
                    // const SizedBox(
                    //   height: AppTheme.spacing20,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     BaseButton(
                    //       "common.edit".tr(),
                    //       disabled: !widget.editable,
                    //       onPressed: widget.onEdit,
                    //       buttonBorder: ButtonBorder.circular,
                    //       type: ButtonType.secondary,
                    //     ),
                    //     const SizedBox(
                    //       width: AppTheme.spacing10,
                    //     ),
                    //     BaseButton(
                    //       "+ ${"common.add".tr()}",
                    //       onPressed: widget.onAdd,
                    //       buttonBorder: ButtonBorder.circular,
                    //     ),
                    //   ],
                    // )
                  ]),
                ),
                const SizedBox(
                  height: AppTheme.spacing14,
                ),
                NoteSection(notes: widget.notes),
                // spacing for floating button
                const SizedBox(
                  height: 140,
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 57,
                    height: 57,
                    child: FittedBox(
                      child: FloatingActionButton(
                        // change to add note
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AddNoteDialog(
                                  addNote: widget.onAddNote,
                                );
                              });
                        },
                        backgroundColor: AppTheme.colorShade.label,
                        shape: const CircleBorder(),
                        child: const Icon(CustomIcons.noteAdd),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 68,
                    height: 68,
                    child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: AppTheme.colorShade.primary,
                        onPressed: widget.onAdd,
                        shape: const CircleBorder(),
                        heroTag: null,
                        child: const Icon(
                          CustomIcons.add,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

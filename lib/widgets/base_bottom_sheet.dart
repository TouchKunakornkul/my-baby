import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:my_baby/configs/theme.dart';
import 'package:my_baby/widgets/base_button.dart';
import 'package:my_baby/widgets/base_text_input.dart';

enum BottomSheetSize {
  small,
  medium,
}

class SelectItem {
  final String label;
  final String value;
  final String? icon;

  const SelectItem({
    Key? key,
    required this.label,
    required this.value,
    this.icon,
  });
}

class BaseBottomSheet {
  static void showSelectableList(
    BuildContext parentContext, {
    required Function(String) onSubmit,
    required String title,
    required String value,
    required List<SelectItem> items,
    String? searchHint,
    bool searchable = false,
    BottomSheetSize? size,
    bool requiredSubmit = false,
  }) {
    final size0 = size ?? BottomSheetSize.medium;
    showModalBottomSheet(
      context: parentContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.borderRadius4),
          topRight: Radius.circular(AppTheme.borderRadius4),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom / 2,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height /
                  (size0 == BottomSheetSize.medium ? 2 : 4),
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListViewArrow(
                      searchHint: searchHint,
                      items: items,
                      title: title,
                      ignoreAutoPopWhenClickChild: false,
                      onSubmit: (str) {
                        onSubmit(str);
                      },
                      requiredSubmit: requiredSubmit,
                      searchable: searchable,
                      currentItem: value,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // static void showMultiSelectableList(
  //   BuildContext parentContext, {
  //   required Function(List<String>) onSubmit,
  //   bool requiredSubmit = true,
  //   required String title,
  //   required List<String> values,
  //   required List<SelectItem> items,
  //   String? searchHint,
  //   bool? searchable,
  //   bool? hasClear,
  //   String? clearTitle,
  //   BottomSheetSize? size,
  // }) {
  //   final size0 = size ?? BottomSheetSize.medium;
  //   showModalBottomSheet(
  //     context: parentContext,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(AppTheme.borderRadius4),
  //         topRight: Radius.circular(AppTheme.borderRadius4),
  //       ),
  //     ),
  //     builder: (context) {
  //       return SafeArea(
  //         child: AnimatedPadding(
  //           duration: const Duration(milliseconds: 150),
  //           curve: Curves.easeOut,
  //           padding: EdgeInsets.only(
  //             bottom: MediaQuery.of(context).viewInsets.bottom / 2,
  //           ),
  //           child: Container(
  //             height: MediaQuery.of(context).size.height /
  //                 (size0 == BottomSheetSize.medium ? 2 : 4),
  //             padding: const EdgeInsets.all(AppTheme.spacing16),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Expanded(
  //                   child: ListViewArrowMulti(
  //                     searchHint: searchHint,
  //                     items: items,
  //                     title: title,
  //                     ignoreAutoPopWhenClickChild: true,
  //                     onSubmit: (str) {
  //                       onSubmit(str);
  //                     },
  //                     requiredSubmit: requiredSubmit,
  //                     hasClear: hasClear,
  //                     clearTitle: clearTitle,
  //                     searchable: searchable,
  //                     currentItem: values,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

class ListViewArrow extends StatefulWidget {
  final List<SelectItem> items;
  final Function(String) onSubmit;
  final bool ignoreAutoPopWhenClickChild;
  final String? searchHint;
  String currentItem;
  final bool searchable;
  final String title;
  final bool requiredSubmit;
  ListViewArrow({
    Key? key,
    required this.items,
    required this.onSubmit,
    required this.ignoreAutoPopWhenClickChild,
    this.searchHint,
    this.searchable = false,
    required this.currentItem,
    required this.title,
    this.requiredSubmit = true,
  }) : super(key: key);

  @override
  _ListViewArrowState createState() => _ListViewArrowState();
}

class _ListViewArrowState extends State<ListViewArrow> {
  final ScrollController _scrollController = ScrollController();
  bool showArrowIcon = false;
  String? _searchValue;
  String? _selectedItem;
  @override
  void initState() {
    _selectedItem = widget.currentItem;
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset.floor() >=
          _scrollController.position.maxScrollExtent.floor()) {
        setState(() {
          showArrowIcon = false;
        });
      } else {
        setState(() {
          showArrowIcon = true;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.items.length > 10) {
      setState(() {
        showArrowIcon = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<SelectItem> sortedItems = List.from(widget.items);
    final currentSelectItem = sortedItems
        .firstWhereOrNull((element) => element.value == widget.currentItem);
    if (currentSelectItem != null) {
      sortedItems.remove(currentSelectItem);
      sortedItems.insert(0, currentSelectItem);
    }
    final filteredItems = _searchValue != null && _searchValue!.isNotEmpty
        ? sortedItems
            .where((e) =>
                e.label.contains(RegExp(_searchValue!, caseSensitive: false)))
            .toList()
        : sortedItems;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: ThemeTextStyle.boldParagraph2(
                context,
                color: AppTheme.grayShade.shade02,
              ),
            ),
            if (widget.requiredSubmit)
              InkWell(
                onTap: () {
                  widget.onSubmit(_selectedItem ?? '');
                  Navigator.of(context).pop();
                },
                child: Ink(
                  padding: const EdgeInsets.all(AppTheme.spacing10),
                  child: Text(
                    "common.done".tr(),
                    style: ThemeTextStyle.boldParagraph2(
                      context,
                      color: AppTheme.primaryShade.main,
                    ),
                  ),
                ),
              )
          ],
        ),
        const SizedBox(
          height: AppTheme.spacing8,
        ),
        if (widget.searchable)
          BaseTextInput(
            type: InputType.search,
            hintText: widget.searchHint,
            onChanged: (value) {
              setState(() {
                _searchValue = value;
              });
            },
          ),
        Expanded(
          child: filteredItems.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/no-data.png',
                          width: 50,
                        ),
                        const SizedBox(
                          height: AppTheme.spacing16,
                        ),
                        Text(
                          'common.no_data'.tr(),
                          style: ThemeTextStyle.headline3(context,
                              color: AppTheme.grayShade.shade04),
                        ),
                      ],
                    ),
                  ],
                )
              : ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filteredItems.length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    final isSelected =
                        _selectedItem == filteredItems[index].value;
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _selectedItem = filteredItems[index].value;
                            if (!widget.requiredSubmit) {
                              widget.onSubmit(_selectedItem ?? '');
                            }
                            if (widget.ignoreAutoPopWhenClickChild) {
                              setState(() {});
                              return;
                            }
                            widget.onSubmit(_selectedItem ?? '');
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            color:
                                isSelected ? AppTheme.primaryShade.light : null,
                            padding: const EdgeInsets.only(
                              top: AppTheme.spacing8,
                              bottom: AppTheme.spacing8,
                              right: AppTheme.spacing16,
                              left: AppTheme.spacing16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    filteredItems[index].label,
                                    style: ThemeTextStyle.paragraph2(context,
                                        color: isSelected
                                            ? AppTheme.primaryShade.main
                                            : AppTheme.grayShade.shade01),
                                  ),
                                ),
                                // Visibility(
                                //     maintainSize: true,
                                //     maintainAnimation: true,
                                //     maintainState: true,
                                //     visible: isSelected ? true : false,
                                //     child: Icon(
                                //       CustomIcons.check,
                                //       color: AppTheme.primaryShade.main,
                                //       size: 14,
                                //     )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
        ),
      ],
    );
  }
}

// class ListViewArrowMulti extends StatefulWidget {
//   final List<SelectItem> items;
//   final Function(List<String>) onSubmit;
//   final bool ignoreAutoPopWhenClickChild;
//   final String? searchHint;
//   final List<String> currentItem;
//   final bool? searchable;
//   final String title;
//   final bool? hasClear;
//   final String? clearTitle;
//   final bool requiredSubmit;
//   const ListViewArrowMulti({
//     Key? key,
//     required this.items,
//     required this.onSubmit,
//     required this.ignoreAutoPopWhenClickChild,
//     this.searchHint,
//     this.searchable,
//     required this.currentItem,
//     required this.title,
//     this.hasClear,
//     this.clearTitle,
//     this.requiredSubmit = true,
//   }) : super(key: key);

//   @override
//   _ListViewArrowMultiState createState() => _ListViewArrowMultiState();
// }

// class _ListViewArrowMultiState extends State<ListViewArrowMulti> {
//   final ScrollController _scrollController = ScrollController();
//   bool showArrowIcon = false;
//   String? _searchValue;
//   List<String> _selectedItems = [];
//   @override
//   void initState() {
//     _selectedItems = widget.currentItem;
//     super.initState();
//     _scrollController.addListener(() {
//       if (_scrollController.offset.floor() >=
//           _scrollController.position.maxScrollExtent.floor()) {
//         setState(() {
//           showArrowIcon = false;
//         });
//       } else {
//         setState(() {
//           showArrowIcon = true;
//         });
//       }
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (widget.items.length > 10) {
//       setState(() {
//         showArrowIcon = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredItems = _searchValue != null && _searchValue!.isNotEmpty
//         ? widget.items
//             .where((e) =>
//                 e.label.contains(RegExp(_searchValue!, caseSensitive: false)))
//             .toList()
//         : widget.items;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               widget.title,
//               style: ThemeTextStyle.boldParagraph2(
//                 context,
//                 color: AppTheme.grayShade.shade02,
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 widget.onSubmit(_selectedItems);
//                 Navigator.of(context).pop();
//               },
//               child: Ink(
//                 padding: const EdgeInsets.all(AppTheme.spacing10),
//                 child: Text(
//                   "common.done".tr(),
//                   style: ThemeTextStyle.boldParagraph2(
//                     context,
//                     color: AppTheme.primaryShade.main,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//         const SizedBox(
//           height: AppTheme.spacing8,
//         ),
//         if (widget.searchable ?? true)
//           BaseTextInput(
//             type: InputType.search,
//             hintText: widget.searchHint,
//             onChanged: (value) {
//               setState(() {
//                 _searchValue = value;
//               });
//             },
//           ),
//         Expanded(
//           child: filteredItems.isEmpty
//               ? Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/images/no-data.png',
//                           width: 50,
//                         ),
//                         const SizedBox(
//                           height: AppTheme.spacing16,
//                         ),
//                         Text(
//                           'common.no_data'.tr(),
//                           style: ThemeTextStyle.headline3(context,
//                               color: AppTheme.grayShade.shade04),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )
//               : ListView.builder(
//                   controller: _scrollController,
//                   shrinkWrap: true,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   itemCount: widget.hasClear ?? false
//                       ? filteredItems.length + 1
//                       : filteredItems.length,
//                   itemBuilder: (
//                     BuildContext context,
//                     int rawIndex,
//                   ) {
//                     final index =
//                         widget.hasClear ?? false ? rawIndex - 1 : rawIndex;
//                     final isSelected = index == -1
//                         ? _selectedItems.isEmpty
//                         : _selectedItems
//                             .where((e) => e == filteredItems[index].value)
//                             .isNotEmpty;
//                     return Column(
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             if (index == -1) {
//                               _selectedItems = [];
//                             } else {
//                               if (isSelected) {
//                                 _selectedItems
//                                     .remove(filteredItems[index].value);
//                               } else {
//                                 _selectedItems.add(filteredItems[index].value);
//                               }
//                             }
//                             if (!widget.requiredSubmit) {
//                               widget.onSubmit(_selectedItems);
//                             }
//                             if (widget.ignoreAutoPopWhenClickChild) {
//                               setState(() {});
//                               return;
//                             }
//                             widget.onSubmit(_selectedItems);
//                             Navigator.of(context).pop();
//                           },
//                           child: Container(
//                             color:
//                                 isSelected ? AppTheme.primaryShade.light : null,
//                             padding: const EdgeInsets.only(
//                               top: AppTheme.spacing8,
//                               bottom: AppTheme.spacing8,
//                               right: AppTheme.spacing16,
//                               left: AppTheme.spacing16,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     index == -1
//                                         ? widget.clearTitle ?? ''
//                                         : filteredItems[index].label,
//                                     style: ThemeTextStyle.paragraph2(context,
//                                         color: isSelected
//                                             ? AppTheme.primaryShade.main
//                                             : AppTheme.grayShade.shade01),
//                                   ),
//                                 ),
//                                 Visibility(
//                                     maintainSize: true,
//                                     maintainAnimation: true,
//                                     maintainState: true,
//                                     visible: isSelected ? true : false,
//                                     child: Icon(
//                                       CustomIcons.check,
//                                       color: AppTheme.primaryShade.main,
//                                       size: 14,
//                                     )),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }),
//         ),
//       ],
//     );
//   }
// }

class TextInputWithButton extends StatefulWidget {
  final Function(String) onSubmit;
  final String? initialValue;
  final String? label;
  const TextInputWithButton({
    Key? key,
    required this.onSubmit,
    this.label,
    this.initialValue,
  }) : super(key: key);

  @override
  _TextInputWithButtonState createState() => _TextInputWithButtonState();
}

class _TextInputWithButtonState extends State<TextInputWithButton> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseTextInput(
          label: widget.label,
          controller: _textController,
        ),
        const SizedBox(
          height: 18,
        ),
        BaseButton(
          'common.save'.tr(),
          onPressed: () {
            widget.onSubmit(_textController.text);
          },
        ),
      ],
    );
  }
}

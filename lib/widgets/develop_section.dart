import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/icons/my_flutter_app_icons.dart';
import 'package:my_baby/providers/develop_provider.dart';
import 'package:my_baby/widgets/base_dialog.dart';
import 'package:provider/provider.dart';

class DevelopItem extends StatelessWidget {
  final IconData icon;
  final DateTime? checkedAt;
  const DevelopItem({
    Key? key,
    required this.icon,
    this.checkedAt,
  }) : super(key: key);

  String get _daysAgo {
    if (checkedAt != null) {
      final date = DateTime.now();
      final difference = date.difference(checkedAt!);
      final dayAgo = difference.inDays;
      return dayAgo > 1
          ? "common.days_ago".tr(args: [dayAgo.toString()])
          : "common.day_ago".tr(args: [dayAgo.toString()]);
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(_daysAgo),
          Icon(icon),
          Text(checkedAt != null ? "checked" : ""),
        ],
      ),
    );
  }
}

class DevelopDialog extends StatefulWidget {
  const DevelopDialog({super.key});

  @override
  State<DevelopDialog> createState() => _DevelopDialogState();
}

class _DevelopDialogState extends State<DevelopDialog> {
  bool _muscle = false;
  bool _brain = false;
  bool _people = false;
  bool _emotion = false;

  @override
  void initState() {
    _muscle = context.read<DevelopProvider>().muscle != null;
    _brain = context.read<DevelopProvider>().brain != null;
    _people = context.read<DevelopProvider>().people != null;
    _emotion = context.read<DevelopProvider>().emotion != null;
    super.initState();
  }

  Future<void> _updateDevelop() async {
    final muscle = context.read<DevelopProvider>().muscle != null;
    final brain = context.read<DevelopProvider>().brain != null;
    final people = context.read<DevelopProvider>().people != null;
    final emotion = context.read<DevelopProvider>().emotion != null;
    await context.read<DevelopProvider>().updateDevelop(
          muscle: !muscle && _muscle,
          brain: !brain && _brain,
          people: !people && _people,
          emotion: !emotion && _emotion,
        );
  }

  @override
  Widget build(BuildContext context) {
    final muscle = context.read<DevelopProvider>().muscle != null;
    final brain = context.read<DevelopProvider>().brain != null;
    final people = context.read<DevelopProvider>().people != null;
    final emotion = context.read<DevelopProvider>().emotion != null;
    return BaseDialog(
      title: ''.tr(),
      content: Column(children: [
        Text(DateFormat('d MMM yy').format(DateTime.now())),
        Checkbox(
            value: _muscle,
            onChanged: !muscle
                ? (bool? value) {
                    setState(() {
                      _muscle = value!;
                    });
                  }
                : null),
        Checkbox(
          value: _brain,
          onChanged: !brain
              ? (bool? value) {
                  setState(() {
                    _brain = value!;
                  });
                }
              : null,
        ),
        Checkbox(
          value: _people,
          onChanged: !people
              ? (bool? value) {
                  setState(() {
                    _people = value!;
                  });
                }
              : null,
        ),
        Checkbox(
          value: _emotion,
          onChanged: !emotion
              ? (bool? value) {
                  setState(() {
                    _emotion = value!;
                  });
                }
              : null,
        ),
      ]),
      onOk: _updateDevelop,
    );
  }
}

class DevelopSection extends StatelessWidget {
  const DevelopSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final muscle = context.watch<DevelopProvider>().muscle;
    final brain = context.watch<DevelopProvider>().brain;
    final people = context.watch<DevelopProvider>().people;
    final emotion = context.watch<DevelopProvider>().emotion;

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        child: Row(
          children: [
            Column(
              children: [
                const Text("Develop"),
                InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) =>
                            const DevelopDialog(),
                      );
                      // context
                      //     .read<DevelopProvider>()
                      //     .updateDevelop(muscle: true);
                    },
                    child: const Text("+ADD")),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      DevelopItem(
                        icon: CustomIcon.edit,
                        checkedAt: muscle?.createdAt,
                      ),
                      DevelopItem(
                        icon: CustomIcon.edit,
                        checkedAt: brain?.createdAt,
                      ),
                      DevelopItem(
                        icon: CustomIcon.edit,
                        checkedAt: people?.createdAt,
                      ),
                      DevelopItem(
                        icon: CustomIcon.edit,
                        checkedAt: emotion?.createdAt,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}

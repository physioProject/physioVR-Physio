import 'AppColor.dart';
import 'AppSize.dart';
import 'AppText.dart';

import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Widget? leading;
  final List<Widget>? actions;
  const AppBarWidget({Key? key, required this.text, this.leading, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.noColor,
      elevation: 0,
      title: AppText(
        text: text,
        fontSize: AppSize.titleTextSize,
        color: AppColor.black,
      ),
      leading: leading,
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

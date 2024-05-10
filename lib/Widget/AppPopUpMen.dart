import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'AppColor.dart';

class AppPopUpMen extends StatelessWidget {
  final List<PopupMenuEntry> menuList;
  final Widget? icon;
  const AppPopUpMen({Key? key, required this.menuList, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: AppColor.black,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0.spMin),
      ),
      itemBuilder: ((context) => menuList),
      icon: icon,
    );
  }
}

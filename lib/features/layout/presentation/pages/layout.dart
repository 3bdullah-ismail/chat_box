import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/constants/assets_manager.dart';
import 'package:silora/features/friends/presentation/pages/friends.dart';
import 'package:silora/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/styles_manager.dart';
import '../../../chat/presentation/pages/chats_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:silora/core/translations/locale_keys.g.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int _currentIndex = 0;
  List<Widget> get _pages => [
    ChatsPage(
      onJumpToFriendsTab: () {
        setState(() => _currentIndex = 1);
      },
    ),
    const FriendsPage(),
    const ProfilePage(),
  ];

  Widget _buildIcon(int index, String? svgAsset, IconData iconData) {
    final color = _currentIndex == index
        ? ColorManager.black
        : ColorManager.gray;
    return svgAsset != null
        ? SvgPicture.asset(
            svgAsset,
            width: AppSize.s20,
            height: AppSize.s20,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          )
        : Icon(iconData, size: AppSize.s28, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: ColorManager.transparent,
          highlightColor: ColorManager.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: ColorManager.white,
          selectedItemColor: ColorManager.black,
          unselectedItemColor: ColorManager.gray,
          selectedLabelStyle: getBoldStyle(color: ColorManager.nearBlack),
          unselectedLabelStyle: getBoldStyle(color: ColorManager.nearBlack),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(
                0,
                ImageAssets.chatSvg,
                Icons.chat_bubble_outline_rounded,
              ),
              label: LocaleKeys.layout_chatsTab.tr(),
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                1,
                ImageAssets.friendsSvg,
                Icons.people_outline_rounded,
              ),
              label: LocaleKeys.layout_friendsTab.tr(),
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(2, null, Icons.person_rounded),
              label: LocaleKeys.layout_profileTab.tr(),
            ),
          ],
        ),
      ),
    );
  }
}

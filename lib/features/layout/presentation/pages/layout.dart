import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/features/friends/presentation/pages/friends.dart';
import 'package:chat_app/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/styles_manager.dart';
import '../../../chat/presentation/pages/chats_page.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [ChatsPage(), FriendsPage(), ProfilePage()];

  Widget _buildIcon(int index, String? svgAsset, IconData iconData) {
    final color = _currentIndex == index
        ? ColorManager.black
        : ColorManager.gray;
    return svgAsset != null
        ? SvgPicture.asset(
            svgAsset,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          )
        : Icon(iconData, size: 28, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
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
                'assets/images/chat.svg',
                Icons.chat_bubble_outline_rounded,
              ),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                1,
                'assets/images/friends.svg',
                Icons.people_outline_rounded,
              ),
              label: 'Friends',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(2, null, Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

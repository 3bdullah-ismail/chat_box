import 'package:chat_app/core/constants/color_manager.dart';
import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {
  const EmptyCard({super.key});

  Widget _buildSkeleton(double width, Color color) => Container(
    width: width,
    height: 10,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5),
    ),
  );

  Widget _buildAvatar({
    required Color bg,
    required IconData icon,
    Color ic = ColorManager.neutralGray,
  }) => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: bg,
      shape: BoxShape.circle,
      border: Border.all(color: ColorManager.white, width: 2),
    ),
    child: Icon(icon, size: 18, color: ic),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Transform.rotate(
              angle: 0.05,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorManager.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: ColorManager.borderGray),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Transform.rotate(
              angle: -0.05,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: ColorManager.surfaceGray),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeleton(100, ColorManager.borderGray),
                    const SizedBox(height: 6),
                    _buildSkeleton(70, ColorManager.lightGray),
                    const Spacer(),

                    Center(
                      child: Badge(
                        alignment: const Alignment(0.7, -0.7),
                        backgroundColor: ColorManager.danger,
                        smallSize: 10,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: ColorManager.lightGray,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.people_outline_rounded,
                            size: 30,
                            color: ColorManager.neutralGray,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),

                    Center(
                      child: SizedBox(
                        width: 88,
                        height: 36,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              child: _buildAvatar(
                                bg: ColorManager.lightGray,
                                icon: Icons.person_outline_rounded,
                              ),
                            ),
                            Positioned(
                              left: 26,
                              child: _buildAvatar(
                                bg: ColorManager.lightGray,
                                icon: Icons.person_outline_rounded,
                              ),
                            ),
                            Positioned(
                              left: 52,
                              child: _buildAvatar(
                                bg: ColorManager.nearBlack,
                                icon: Icons.add,
                                ic: ColorManager.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),

                    _buildSkeleton(double.infinity, ColorManager.lightGray),
                    const SizedBox(height: 6),
                    _buildSkeleton(120, ColorManager.lightGray),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

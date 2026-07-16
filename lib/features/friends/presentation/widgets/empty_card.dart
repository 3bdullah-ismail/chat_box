import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {
  const EmptyCard({super.key});

  Widget _buildSkeleton(double width, Color color) => Container(
    width: width,
    height: AppSize.s10,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(AppRadius.r4),
    ),
  );

  Widget _buildAvatar({
    required Color bg,
    required IconData icon,
    Color ic = ColorManager.neutralGray,
  }) => Container(
    width: AppSize.s40,
    height: AppSize.s40,
    decoration: BoxDecoration(
      color: bg,
      shape: BoxShape.circle,
      border: Border.all(color: ColorManager.white, width: AppSize.s2),
    ),
    child: Icon(icon, size: AppSize.s18, color: ic),
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
                  borderRadius: BorderRadius.circular(AppRadius.r24),
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
                  horizontal: AppPadding.p20,
                  vertical: AppPadding.p18,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(AppRadius.r24),
                  border: Border.all(color: ColorManager.surfaceGray),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.black.withValues(alpha: 0.04),
                      blurRadius: AppSize.s12,
                      offset: const Offset(0, AppSize.s4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeleton(100, ColorManager.borderGray),
                    const SizedBox(height: AppSize.s6),
                    _buildSkeleton(70, ColorManager.lightGray),
                    const Spacer(),

                    Center(
                      child: Badge(
                        alignment: const Alignment(0.7, -0.7),
                        backgroundColor: ColorManager.danger,
                        smallSize: AppSize.s10,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: ColorManager.lightGray,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.people_outline_rounded,
                            size: AppSize.s30,
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
                    const SizedBox(height: AppSize.s6),
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

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/data/models/user/user.dart';
import 'package:straight_to_yard/domain/repositories/local_repository.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_tabbar_controller.dart';
import 'package:straight_to_yard/presentation/dashboard/views/address.dart';
import 'package:straight_to_yard/presentation/dashboard/views/dashboard.dart';
import 'package:straight_to_yard/presentation/dashboard/views/packages.dart';

class DashboardMainScreen extends GetView<DashboardTabBarController> {
  const DashboardMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      value: SystemUiOverlayStyle.dark,
      showGradients: false,
      backgroundColor: const Color(0xFFF8FAFD),
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(
              painter: _DashboardBackgroundPainter(),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.width < 380 ? 16 : 20,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  const _DashboardHeader(),
                  Obx(
                    () => controller.isDashboardSelected
                        ? const Column(
                            children: [
                              SizedBox(height: 24),
                              _UserSummaryCard(),
                              SizedBox(height: 22),
                            ],
                          )
                        : const SizedBox(height: 24),
                  ),
                  _DashboardSegmentedTabs(controller: controller),
                  Expanded(
                    child: TabBarView(
                      controller: controller.tabController,
                      children: const [
                        Dashboard(),
                        Packages(),
                        Address(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 0,
            top: 4,
            child: _HeaderButton(
              icon: Icons.menu_rounded,
              onTap: () {},
            ),
          ),
          Positioned(
            top: 0,
            child: Image.asset(
              'assets/images/icon.png',
              width: math.min(170, context.width * 0.34),
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            right: 0,
            top: 4,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _HeaderButton(
                  icon: Icons.notifications_none_rounded,
                  onTap: () {},
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF1717),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C81).withOpacity(0.11),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: const Color(0xFF020A24),
          size: 32,
        ),
      ),
    );
  }
}

class _UserSummaryCard extends StatelessWidget {
  const _UserSummaryCard();

  @override
  Widget build(BuildContext context) {
    final user = find<LocalRepository>().getInstantUser();
    final name = _displayName(user);
    final account = user.mailbox.isNotEmpty ? user.mailbox : user.loyaltynum;
    final initials = _initials(user, name);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C81).withOpacity(0.09),
            blurRadius: 24,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFF075BEE),
                  Color(0xFF078E31),
                ],
              ),
            ),
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $name \u{1F44B}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF020A24),
                    fontSize: 19,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Account ID: ${account.isEmpty ? '--' : account}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF27304A),
                          fontSize: 13.5,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.copy_rounded,
                      color: Color(0xFF27304A),
                      size: 19,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFFFDF9F),
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFAE00),
                  size: 19,
                ),
                SizedBox(width: 6),
                Text(
                  'Gold Member',
                  style: TextStyle(
                    color: Color(0xFFE99A00),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFFE99A00),
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _displayName(User user) {
    final firstName = user.firstName.trim();
    if (firstName.isNotEmpty) return firstName;
    final completeName = user.completeName.trim();
    if (completeName.isNotEmpty) return completeName;
    final username = user.userName.trim();
    if (username.isNotEmpty) return username;
    return 'User';
  }

  String _initials(User user, String name) {
    final first = user.firstName.trim();
    final last = user.lastName.trim();
    if (first.isNotEmpty && last.isNotEmpty) {
      return '${first[0]}${last[0]}'.toUpperCase();
    }
    final cleanedName = name.trim();
    if (cleanedName.isEmpty) return 'UN';
    final pieces = cleanedName.split(RegExp(r'\s+'));
    if (pieces.length > 1) {
      return '${pieces.first[0]}${pieces.last[0]}'.toUpperCase();
    }
    return cleanedName.substring(0, math.min(2, cleanedName.length)).toUpperCase();
  }
}

class _DashboardSegmentedTabs extends StatelessWidget {
  const _DashboardSegmentedTabs({required this.controller});

  final DashboardTabBarController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SegmentedTab(
            icon: Icons.grid_view_rounded,
            title: 'Dashboard',
            index: 0,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SegmentedTab(
            icon: Icons.inventory_2_outlined,
            title: 'Packages',
            index: 1,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SegmentedTab(
            icon: Icons.location_on_outlined,
            title: 'Address',
            index: 2,
          ),
        ),
      ],
    );
  }
}

class _SegmentedTab extends GetView<DashboardTabBarController> {
  const _SegmentedTab({
    required this.icon,
    required this.title,
    required this.index,
  });

  final IconData icon;
  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final selected = controller.index.value == index;
        final activeColor =
            index == 1 ? const Color(0xFF075BEE) : const Color(0xFF078E31);
        final selectedAddress = selected && index == 2;
        final selectedForeground =
            selectedAddress ? Colors.white : activeColor;

        return InkWell(
          onTap: () => controller.tabController.animateTo(index),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: 70,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: selectedAddress
                  ? const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF22A763),
                        Color(0xFF075BEE),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: selectedAddress
                      ? const Color(0xFF075BEE).withOpacity(0.18)
                      : const Color(0xFF0F4C81).withOpacity(0.08),
                  blurRadius: selectedAddress ? 22 : 18,
                  offset: Offset(0, selectedAddress ? 12 : 9),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: selected
                            ? selectedForeground
                            : const Color(0xFF020A24),
                        size: 24,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: selected
                                ? selectedForeground
                                : const Color(0xFF020A24),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight:
                                selected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected && !selectedAddress)
                  Positioned(
                    left: 42,
                    right: 42,
                    bottom: 0,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: activeColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DashboardBackgroundPainter extends CustomPainter {
  const _DashboardBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF8FAFD),
    );

    final green = Paint()..color = const Color(0xFF61CF71).withOpacity(0.72);
    final lightGreen = Paint()..color = const Color(0xFFBDEEC6).withOpacity(0.8);

    canvas.drawCircle(
      Offset(size.width * -0.08, size.height * 0.98),
      size.width * 0.23,
      lightGreen,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.91)
        ..cubicTo(
          size.width * 0.08,
          size.height * 0.93,
          size.width * 0.14,
          size.height * 0.99,
          size.width * 0.26,
          size.height,
        )
        ..lineTo(0, size.height)
        ..close(),
      green,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

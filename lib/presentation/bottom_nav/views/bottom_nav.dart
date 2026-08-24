import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/routes/app_routes.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';

class BottomNavScreen extends GetView<BottomNavController> {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      value: SystemUiOverlayStyle.dark,
      showGradients: false,
      extendBody: true,
      wrapWithAnnotatedRegion: true,
      backgroundColor: const Color(0xFFF8FAFD),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 104),
        child: Navigator(
          key: Get.nestedKey(controller.bottomNavNestedID),
          onGenerateRoute: (settings) {
            Get.routing.args = settings.arguments;
            final page = AppRoutes.routes.firstWhere(
              (r) => r.name == settings.name,
            );
            return GetPageRoute<dynamic>(
              page: page.page,
              settings: settings,
              binding: page.binding,
              transition: page.transition,
              parameter: page.parameters,
              opaque: page.opaque,
              popGesture: page.popGesture,
              fullscreenDialog: page.fullscreenDialog,
              maintainState: page.maintainState,
              curve: page.curve,
              middlewares: page.middlewares,
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: Container(
            height: 82,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.98),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F4C81).withOpacity(0.13),
                  blurRadius: 26,
                  offset: const Offset(0, 11),
                ),
              ],
            ),
            child: Obx(
              () => Row(
                children: [
                  _BottomNavItem(
                    label: 'Dashboard',
                    icon: Icons.home_rounded,
                    selected: controller.currentIndex.value == 0,
                    onTap: () => controller.onTabChange(0),
                  ),
                  _BottomNavItem(
                    label: 'Authorize User',
                    icon: Icons.person_outline_rounded,
                    selected: controller.currentIndex.value == 1,
                    onTap: () => controller.onTabChange(1),
                  ),
                  _BottomNavItem(
                    label: 'Delivery',
                    icon: Icons.location_on_outlined,
                    selected: controller.currentIndex.value == 2,
                    onTap: () => controller.onTabChange(2),
                  ),
                  _BottomNavItem(
                    label: 'News',
                    icon: Icons.article_outlined,
                    selected: controller.currentIndex.value == 3,
                    onTap: () => controller.onTabChange(3),
                  ),
                  _BottomNavItem(
                    label: 'Account',
                    icon: Icons.person_outline_rounded,
                    selected: controller.currentIndex.value == 4,
                    onTap: () => controller.onTabChange(4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 44,
              height: 38,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF078E31) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : const Color(0xFF020A24),
                size: selected ? 29 : 28,
              ),
            ),
            const SizedBox(height: 5),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: selected
                      ? const Color(0xFF078E31)
                      : const Color(0xFF020A24),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

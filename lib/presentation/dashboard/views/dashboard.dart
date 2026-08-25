import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:straight_to_yard/data/models/dashboard_data/dashboard_data.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_controller.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      color: const Color(0xFF078E31),
      child: controller.obx(
        onLoading: const _ShimmerWidget(),
        onEmpty: const Center(
          child: Text(
            'No data found',
            style: TextStyle(
              color: Color(0xFF020A24),
              fontSize: 22,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        onError: (error) => SizedBox(
          height: context.height / 1.5,
          width: context.width,
          child: const Center(
            child: Text(
              'Something went wrong try again later',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF020A24),
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        (state) {
          if (state == null) return const SizedBox.shrink();

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(0, 18, 0, 26),
            children: [
              _DashboardMetricCard(
                value: state.wherehouse.toString(),
                eyebrow: 'Total Packages at',
                title: 'Miami Warehouse',
                color: const Color(0xFF075BEE),
                icon: Icons.warehouse_outlined,
                illustration: _MetricIllustration.warehouse,
              ),
              const SizedBox(height: 20),
              _DashboardMetricCard(
                value: state.inTransit.toString(),
                eyebrow: 'Total Packages',
                title: 'In Transit',
                color: const Color(0xFF078E31),
                icon: Icons.local_shipping_outlined,
                illustration: _MetricIllustration.map,
              ),
              const SizedBox(height: 20),
              _DashboardMetricCard(
                value: state.outstandingPackage.toString(),
                eyebrow: 'Total Packages',
                title: 'Ready for Pick Up',
                color: const Color(0xFFFF6900),
                icon: Icons.shopping_bag_outlined,
                illustration: _MetricIllustration.pickup,
              ),
              const SizedBox(height: 20),
              _DashboardMetricCard(
                value: _balanceText(state),
                eyebrow: 'Total Outstanding',
                title: 'Balance',
                color: const Color(0xFF6633D9),
                icon: Icons.account_balance_wallet_outlined,
                illustration: _MetricIllustration.wallet,
              ),
            ],
          );
        },
      ),
    );
  }

  String _balanceText(DashboardData state) {
    final balance = state.outstandingBalance.trim();
    if (balance.isEmpty) return '0.00 JMD';
    return balance.toUpperCase().contains('JMD') ? balance : '$balance JMD';
  }
}

enum _MetricIllustration { warehouse, map, pickup, wallet }

class _DashboardMetricCard extends StatelessWidget {
  const _DashboardMetricCard({
    required this.value,
    required this.eyebrow,
    required this.title,
    required this.color,
    required this.icon,
    required this.illustration,
  });

  final String value;
  final String eyebrow;
  final String title;
  final Color color;
  final IconData icon;
  final _MetricIllustration illustration;

  @override
  Widget build(BuildContext context) {
    final compact = context.width < 380;

    return Container(
      height: compact ? 142 : 154,
      clipBehavior: Clip.antiAlias,
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
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 7,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(22),
                ),
              ),
            ),
          ),
          Positioned(
            right: compact ? 10 : 12,
            top: compact ? 12 : 14,
            child: _DottedAccent(color: const Color(0xFFE7ECF5)),
          ),
          Positioned(
            right: compact ? -14 : 14,
            bottom: 0,
            child: CustomPaint(
              size: Size(compact ? 150 : 190, compact ? 110 : 128),
              painter: _MetricIllustrationPainter(
                color: color,
                illustration: illustration,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              compact ? 26 : 32,
              compact ? 20 : 22,
              compact ? 18 : 26,
              compact ? 20 : 22,
            ),
            child: Row(
              children: [
                Container(
                  width: compact ? 80 : 90,
                  height: compact ? 80 : 90,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(compact ? 18 : 20),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: compact ? 46 : 54,
                  ),
                ),
                SizedBox(width: compact ? 20 : 28),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          value,
                          maxLines: 1,
                          style: TextStyle(
                            color: color,
                            fontSize: value.length > 8
                                ? (compact ? 25 : 29)
                                : (compact ? 34 : 40),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                      SizedBox(height: compact ? 10 : 14),
                      Text(
                        eyebrow,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF27304A),
                          fontSize: compact ? 14.5 : 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: color,
                          fontSize: compact ? 15.5 : 17,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                    ],
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

class _DottedAccent extends StatelessWidget {
  const _DottedAccent({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: CustomPaint(
        painter: _DotsPainter(color: color, rows: 3, columns: 3),
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  const _DotsPainter({
    required this.color,
    required this.rows,
    required this.columns,
  });

  final Color color;
  final int rows;
  final int columns;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < columns; column++) {
        canvas.drawCircle(
          Offset(
            column * (size.width / math.max(1, columns - 1)),
            row * (size.height / math.max(1, rows - 1)),
          ),
          3.2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MetricIllustrationPainter extends CustomPainter {
  const _MetricIllustrationPainter({
    required this.color,
    required this.illustration,
  });

  final Color color;
  final _MetricIllustration illustration;

  @override
  void paint(Canvas canvas, Size size) {
    switch (illustration) {
      case _MetricIllustration.warehouse:
        _drawWarehouse(canvas, size);
        break;
      case _MetricIllustration.map:
        _drawMap(canvas, size);
        break;
      case _MetricIllustration.pickup:
        _drawPickup(canvas, size);
        break;
      case _MetricIllustration.wallet:
        _drawWallet(canvas, size);
        break;
    }
  }

  void _drawWarehouse(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(0.14);
    final strong = Paint()..color = color.withOpacity(0.88);
    final mid = Paint()..color = color.withOpacity(0.48);

    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.16, size.height * 0.78)
        ..lineTo(size.width * 0.44, size.height * 0.43)
        ..lineTo(size.width * 0.78, size.height * 0.78)
        ..close(),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.22, size.height * 0.54)
        ..lineTo(size.width * 0.48, size.height * 0.34)
        ..lineTo(size.width * 0.86, size.height * 0.62)
        ..lineTo(size.width * 0.82, size.height * 0.7)
        ..lineTo(size.width * 0.48, size.height * 0.46)
        ..lineTo(size.width * 0.26, size.height * 0.62)
        ..close(),
      strong,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.3,
          size.height * 0.62,
          size.width * 0.48,
          size.height * 0.36,
        ),
        const Radius.circular(6),
      ),
      mid,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.4,
          size.height * 0.74,
          size.width * 0.2,
          size.height * 0.24,
        ),
        const Radius.circular(4),
      ),
      strong,
    );
    for (var i = 0; i < 4; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * (0.02 + i * 0.1),
          size.height * (0.83 - i * 0.04),
          size.width * 0.08,
          size.height * 0.17,
        ),
        paint,
      );
    }
  }

  void _drawMap(Canvas canvas, Size size) {
    final mapPaint = Paint()..color = color.withOpacity(0.13);
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.05,
        size.height * 0.2,
        size.width * 0.76,
        size.height * 0.55,
      ),
      mapPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.12, size.height * 0.72)
        ..cubicTo(
          size.width * 0.3,
          size.height * 0.48,
          size.width * 0.48,
          size.height * 0.84,
          size.width * 0.68,
          size.height * 0.56,
        )
        ..cubicTo(
          size.width * 0.8,
          size.height * 0.4,
          size.width * 0.84,
          size.height * 0.62,
          size.width * 0.95,
          size.height * 0.45,
        ),
      linePaint..style = PaintingStyle.stroke,
    );
    final pinCenter = Offset(size.width * 0.9, size.height * 0.38);
    canvas.drawCircle(pinCenter, 17, Paint()..color = color);
    canvas.drawCircle(pinCenter, 6, Paint()..color = Colors.white);
  }

  void _drawPickup(Canvas canvas, Size size) {
    final mid = Paint()..color = color.withOpacity(0.72);
    final strong = Paint()..color = color;
    final navy = Paint()..color = const Color(0xFF06184A);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.58, size.height * 0.36, 42, 54),
        const Radius.circular(7),
      ),
      mid,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.68, size.height * 0.34, 10, 16),
      strong,
    );
    canvas.drawLine(
      Offset(size.width * 0.46, size.height * 0.18),
      Offset(size.width * 0.54, size.height * 0.76),
      Paint()
        ..color = const Color(0xFF06184A)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      Offset(size.width * 0.54, size.height * 0.84),
      18,
      navy,
    );
    canvas.drawCircle(
      Offset(size.width * 0.54, size.height * 0.84),
      8,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(size.width * 0.83, size.height * 0.76),
      24,
      strong,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.76, size.height * 0.76)
        ..lineTo(size.width * 0.81, size.height * 0.82)
        ..lineTo(size.width * 0.91, size.height * 0.68),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawWallet(Canvas canvas, Size size) {
    final pale = Paint()..color = color.withOpacity(0.22);
    final mid = Paint()..color = color.withOpacity(0.75);
    final strong = Paint()..color = color;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.36, size.height * 0.34, 95, 56),
        const Radius.circular(12),
      ),
      mid,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.42, size.height * 0.23, 78, 38),
        const Radius.circular(10),
      ),
      pale,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.68, size.height * 0.54, 42, 26),
        const Radius.circular(9),
      ),
      strong,
    );
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.67),
      5,
      Paint()..color = Colors.white.withOpacity(0.88),
    );
    for (var i = 0; i < 5; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * (0.42 + i * 0.055),
            size.height * (0.19 - i * 0.025),
            40,
            18,
          ),
          const Radius.circular(5),
        ),
        pale,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ShimmerWidget extends StatelessWidget {
  const _ShimmerWidget();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 4,
      padding: const EdgeInsets.fromLTRB(0, 18, 0, 26),
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return const _DashboardShimmerCard();
      },
    );
  }
}

class _DashboardShimmerCard extends StatelessWidget {
  const _DashboardShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 154,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C81).withOpacity(0.09),
            blurRadius: 24,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(32, 22, 26, 22),
      child: Row(
        children: [
          ShimmerWidget(
            radius: BorderRadius.circular(20),
            width: 90,
            height: 90,
            child: const SizedBox(width: 90, height: 90),
          ),
          const SizedBox(width: 28),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  radius: BorderRadius.circular(8),
                  width: 88,
                  height: 34,
                  child: const SizedBox(width: 88, height: 34),
                ),
                const SizedBox(height: 18),
                ShimmerWidget(
                  radius: BorderRadius.circular(6),
                  width: 150,
                  height: 18,
                  child: const SizedBox(width: 150, height: 18),
                ),
                const SizedBox(height: 10),
                ShimmerWidget(
                  radius: BorderRadius.circular(6),
                  width: 132,
                  height: 18,
                  child: const SizedBox(width: 132, height: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

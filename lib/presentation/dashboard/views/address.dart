import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_address_controller.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class Address extends GetView<DashboardAddressController> {
  const Address({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFF078E31),
      onRefresh: controller.refreshData,
      child: controller.obx(
        onLoading: const _AddressShimmerList(),
        onEmpty: const _AddressStateMessage('No data found'),
        onError: (error) => const _AddressStateMessage(
          'Something went wrong try again late',
        ),
        (state) {
          if (state == null) return const SizedBox.shrink();

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(0, 38, 0, 28),
            children: [
              _AddressCard(
                shippingMode: _ShippingMode.air,
                name: state.userInfo.userName,
                address1: state.setting.packageShippingAddress1,
                address2: state.userInfo.addressLine2,
                city: state.setting.city,
                country: state.setting.country,
                zipCode: state.setting.zip,
                stateName: state.setting.state,
              ),
              const SizedBox(height: 20),
              _AddressCard(
                shippingMode: _ShippingMode.sea,
                name: state.userInfo.userName,
                address1: state.setting.seaShippingAddress1,
                address2: state.setting.seaShippingAddress2,
                city: state.setting.seaCity,
                country: state.setting.seaCountry,
                zipCode: state.setting.seaZip,
                stateName: state.setting.seaState,
              ),
            ],
          );
        },
      ),
    );
  }
}

enum _ShippingMode { air, sea }

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.shippingMode,
    required this.name,
    required this.address1,
    required this.address2,
    required this.city,
    required this.country,
    required this.zipCode,
    required this.stateName,
  });

  final _ShippingMode shippingMode;
  final String name;
  final String address1;
  final String address2;
  final String city;
  final String country;
  final String zipCode;
  final String stateName;

  @override
  Widget build(BuildContext context) {
    final isAir = shippingMode == _ShippingMode.air;
    final highlight = isAir ? 'Air Shipping' : 'Sea Shipping';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C81).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          _AddressHero(
            highlight: highlight,
            isAir: isAir,
          ),
          const SizedBox(height: 16),
          _AddressFieldRow(
            label: 'NAME',
            value: name,
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 9),
          _AddressFieldRow(
            label: 'ADDRESS LINE 1',
            value: address1,
            icon: Icons.home_outlined,
          ),
          const SizedBox(height: 9),
          _AddressFieldRow(
            label: 'ADDRESS LINE 2',
            value: address2,
            icon: Icons.apartment_rounded,
          ),
          const SizedBox(height: 9),
          _AddressFieldRow(
            label: 'CITY',
            value: city,
            icon: Icons.location_city_outlined,
          ),
          if (stateName.trim().isNotEmpty) ...[
            const SizedBox(height: 9),
            _AddressFieldRow(
              label: 'STATE',
              value: stateName,
              icon: Icons.place_outlined,
            ),
          ],
          const SizedBox(height: 9),
          _AddressFieldRow(
            label: 'COUNTRY',
            value: country,
            customIcon: const _CountryFlagIcon(),
          ),
          const SizedBox(height: 9),
          _AddressFieldRow(
            label: 'ZIP',
            value: zipCode,
            icon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: 12),
          const _AddressNote(),
        ],
      ),
    );
  }
}

class _AddressHero extends StatelessWidget {
  const _AddressHero({
    required this.highlight,
    required this.isAir,
  });

  final String highlight;
  final bool isAir;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      padding: const EdgeInsets.fromLTRB(18, 18, 0, 18),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FF),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFF078E31),
                  Color(0xFF075BEE),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF075BEE).withOpacity(0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Colors.white,
              size: 43,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Your ',
                    children: [
                      TextSpan(
                        text: highlight,
                        style: const TextStyle(
                          color: Color(0xFF075BEE),
                        ),
                      ),
                      const TextSpan(text: ' Address'),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF020A24),
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Use this address when shopping online',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF56627A),
                    fontSize: 14.5,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 145,
            child: _ShippingArt(isAir: isAir),
          ),
        ],
      ),
    );
  }
}

class _ShippingArt extends StatelessWidget {
  const _ShippingArt({required this.isAir});

  final bool isAir;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          right: -18,
          top: 0,
          child: Container(
            width: 118,
            height: 118,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFDDE8FF).withOpacity(0.82),
            ),
          ),
        ),
        Positioned(
          right: 18,
          top: isAir ? 12 : 18,
          child: Transform.rotate(
            angle: isAir ? -0.28 : 0,
            child: Icon(
              isAir ? Icons.flight_takeoff_rounded : Icons.local_shipping_rounded,
              color: const Color(0xFF078E31),
              size: isAir ? 54 : 58,
            ),
          ),
        ),
        Positioned(
          right: 24,
          bottom: 6,
          child: Container(
            width: 58,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFD69B46),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFAD7A29).withOpacity(0.22),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 22,
                  top: 0,
                  child: Container(
                    width: 14,
                    height: 18,
                    color: const Color(0xFFF5D48A),
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.inventory_2_rounded,
                    color: Color(0xFF078E31),
                    size: 23,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 18,
          bottom: 24,
          child: CustomPaint(
            size: const Size(44, 30),
            painter: _MiniFlagPainter(),
          ),
        ),
      ],
    );
  }
}

class _AddressFieldRow extends StatelessWidget {
  const _AddressFieldRow({
    required this.label,
    required this.value,
    this.icon,
    this.customIcon,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Widget? customIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      minHeight: 86,
      padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE0E6EF),
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF8EF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: customIcon ??
                Icon(
                  icon,
                  color: const Color(0xFF078E31),
                  size: 34,
                ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF087A24),
                    fontSize: 12.5,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  value.isEmpty ? '--' : value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF020A24),
                    fontSize: 17,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _CopyButton(value),
        ],
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Material(
        color: const Color(0xFFF4F6F8),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: value));
            FlushSnackbar.showSnackBar('Copied to Clipboard');
          },
          borderRadius: BorderRadius.circular(15),
          child: const Icon(
            Icons.copy_rounded,
            color: Color(0xFF078E31),
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _CountryFlagIcon extends StatelessWidget {
  const _CountryFlagIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(42, 31),
      painter: _MiniFlagPainter(),
    );
  }
}

class _AddressNote extends StatelessWidget {
  const _AddressNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F1),
        borderRadius: BorderRadius.circular(13),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: Color(0xFF078E31),
            size: 30,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Copy this address and use at checkout.',
              style: TextStyle(
                color: Color(0xFF47536B),
                fontSize: 14.5,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniFlagPainter extends CustomPainter {
  const _MiniFlagPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final radius = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(6),
    );
    canvas.save();
    canvas.clipRRect(radius);

    final stripeHeight = size.height / 7;
    final red = Paint()..color = const Color(0xFFE71939);
    final white = Paint()..color = Colors.white;
    for (var i = 0; i < 7; i++) {
      canvas.drawRect(
        Rect.fromLTWH(0, i * stripeHeight, size.width, stripeHeight),
        i.isEven ? red : white,
      );
    }

    final blue = Paint()..color = const Color(0xFF1255B3);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * 0.43, size.height * 0.56),
      blue,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AddressStateMessage extends StatelessWidget {
  const _AddressStateMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: context.height * 0.24),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF020A24),
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddressShimmerList extends StatelessWidget {
  const _AddressShimmerList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 38, 0, 28),
      children: const [
        _AddressShimmerCard(),
        SizedBox(height: 20),
        _AddressShimmerCard(),
      ],
    );
  }
}

class _AddressShimmerCard extends StatelessWidget {
  const _AddressShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C81).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          ShimmerWidget(
            radius: BorderRadius.circular(22),
            height: 132,
            width: double.infinity,
            child: const SizedBox.expand(),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            7,
            (index) => Padding(
              padding: EdgeInsets.only(top: index == 0 ? 0 : 9),
              child: ShimmerWidget(
                radius: BorderRadius.circular(16),
                height: 86,
                width: double.infinity,
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ShimmerWidget(
            radius: BorderRadius.circular(13),
            height: 58,
            width: double.infinity,
            child: const SizedBox.expand(),
          ),
        ],
      ),
    );
  }
}

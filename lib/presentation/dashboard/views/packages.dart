import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/extensions/string_ext.dart';
import 'package:straight_to_yard/data/models/get_packages_ready_for_pickup_response/get_packages_ready_for_pickup_response.dart';
import 'package:straight_to_yard/presentation/controller/download_file_controller.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_packages_controller.dart';
import 'package:straight_to_yard/presentation/widgets/dialogs/download_dialog.dart';
import 'package:straight_to_yard/presentation/widgets/dialogs/file_upload_dialog.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class Packages extends GetView<DashboardPackagesController> {
  const Packages({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 26, bottom: 18),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C81).withOpacity(0.09),
            blurRadius: 24,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      child: Column(
        children: [
          _PackageSearchBar(controller: controller.textEditingController),
          const SizedBox(height: 20),
          Expanded(
            child: RefreshIndicator(
              color: const Color(0xFF075BEE),
              onRefresh: () => Future.sync(
                () => controller.pagingController.refresh(),
              ),
              child: PagedListView<int, Package>.separated(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  animateTransitions: true,
                  transitionDuration: 350.milliseconds,
                  firstPageProgressIndicatorBuilder: (context) {
                    return const ShimmerListView();
                  },
                  newPageProgressIndicatorBuilder: (context) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 18),
                      child: PackagesShimmer(),
                    );
                  },
                  noItemsFoundIndicatorBuilder: (context) {
                    return const Center(
                      child: Text(
                        'No packages found',
                        style: TextStyle(
                          color: Color(0xFF020A24),
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, item, index) {
                    return _PackagesItemWidget(item);
                  },
                ),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 18);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PackageSearchBar extends StatelessWidget {
  const _PackageSearchBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 66,
            child: TextField(
              controller: controller,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              style: const TextStyle(
                color: Color(0xFF020A24),
                fontSize: 17,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Search by Tracking ID, Shipper...',
                hintStyle: const TextStyle(
                  color: Color(0xFF858895),
                  fontSize: 17,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF020A24),
                  size: 34,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 66,
                  minHeight: 66,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                border: _border(const Color(0xFFDCE3ED), 1.15),
                enabledBorder: _border(const Color(0xFFDCE3ED), 1.15),
                focusedBorder: _border(const Color(0xFFB9C7DA), 1.35),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFDCE3ED),
              width: 1.15,
            ),
          ),
          child: const Icon(
            Icons.filter_list_rounded,
            color: Color(0xFF078E31),
            size: 31,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _PackagesItemWidget extends GetView<DashboardPackagesController> {
  const _PackagesItemWidget(this.item);

  final Package item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C81).withOpacity(0.1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _PackageTimelineRow(
            icon: Icons.calendar_month_outlined,
            label: 'Date',
            value: item.createdAt.toDDMMYYYY,
          ),
          _PackageTimelineRow(
            icon: Icons.person_outline_rounded,
            label: 'Shipper',
            value: _displayValue(item.courier),
          ),
          _PackageTimelineRow(
            icon: Icons.scale_outlined,
            label: 'Weight',
            value: _displayValue(item.weight),
          ),
          _PackageTimelineRow(
            icon: Icons.local_shipping_outlined,
            label: 'Carrier Tracking',
            value: _displayValue(item.supplierTrackingNo),
            trailing: IconButton(
              splashRadius: 22,
              onPressed: item.supplierTrackingNo.isEmpty
                  ? null
                  : () {
                      Clipboard.setData(
                        ClipboardData(text: item.supplierTrackingNo),
                      );
                    },
              icon: const Icon(
                Icons.copy_rounded,
                color: Color(0xFF078E31),
                size: 25,
              ),
            ),
          ),
          _PackageTimelineRow(
            icon: Icons.assignment_turned_in_outlined,
            label: 'Shipment Status',
            valueWidget: _StatusPill(status: item.statusName),
          ),
          _PackageTimelineRow(
            icon: Icons.description_outlined,
            label: 'Description',
            value: _displayValue(item.itemDescription).toUpperCase(),
            isLast: true,
          ),
          const SizedBox(height: 18),
          _InvoiceActionButton(
            showDownloadButton: item.invoice.isNotEmpty,
            id: item.packegId,
            fileURL: item.invoice,
            onDone: () {
              if (Get.isDialogOpen ?? false) Get.back();
              controller.onUploadingInvoiceDone(item.packegId);
            },
          ),
        ],
      ),
    );
  }

  String _displayValue(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? '--' : trimmed;
  }
}

class _PackageTimelineRow extends StatelessWidget {
  const _PackageTimelineRow({
    required this.icon,
    required this.label,
    this.value,
    this.valueWidget,
    this.trailing,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? valueWidget;
  final Widget? trailing;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF075BEE),
                    size: 30,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: SizedBox(
                      width: 2,
                      child: CustomPaint(
                        painter: _DashedLinePainter(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                top: 3,
                bottom: isLast ? 0 : 19,
              ),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(
                          color: Color(0xFFE6EBF2),
                          width: 1,
                        ),
                      ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF020A24),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 9),
                        valueWidget ??
                            Text(
                              value ?? '--',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF020A24),
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 12),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final text = status.trim().isEmpty ? 'PENDING' : status.trim().toUpperCase();

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFE6F7E9),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                color: Color(0xFF0AA132),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF078E31),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceActionButton extends StatelessWidget {
  const _InvoiceActionButton({
    required this.showDownloadButton,
    required this.id,
    this.onDone,
    this.fileURL,
  });

  final bool showDownloadButton;
  final int id;
  final VoidCallback? onDone;
  final String? fileURL;

  @override
  Widget build(BuildContext context) {
    final title = showDownloadButton ? 'Download Invoice' : 'Upload Invoice';
    final icon = showDownloadButton
        ? Icons.file_download_outlined
        : Icons.file_upload_outlined;

    return Container(
      height: 66,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF168BFF),
            Color(0xFF0047D8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF005DEA).withOpacity(0.28),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            if (showDownloadButton && (fileURL?.isNotEmpty ?? false)) {
              final controller = find<FileDownloadController>();
              controller.downloadFile(fileURL!);
              Get.dialog(const DownloadDialog());
            } else {
              Get.dialog(
                FileUploadDialog(
                  id: id,
                  onDone: onDone,
                ),
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDCE3ED)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    var y = 0.0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, y + 5),
        paint,
      );
      y += 10;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ShimmerListView extends StatelessWidget {
  const ShimmerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (context, index) {
        return const PackagesShimmer();
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 18);
      },
    );
  }
}

class PackagesShimmer extends StatelessWidget {
  const PackagesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: List.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: index == 4 ? 0 : 18),
                child: ShimmerWidget(
                  width: 56,
                  height: 56,
                  radius: BorderRadius.circular(13),
                  child: const SizedBox(width: 56, height: 56),
                ),
              ),
            ),
          ),
          const SizedBox(width: 28),
          Expanded(
            child: Column(
              children: List.generate(
                5,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: index == 4 ? 0 : 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(
                        width: 140,
                        height: 18,
                        radius: BorderRadius.circular(5),
                        child: const SizedBox(width: 140, height: 18),
                      ),
                      const SizedBox(height: 10),
                      ShimmerWidget(
                        width: double.infinity,
                        height: 22,
                        radius: BorderRadius.circular(5),
                        child: const SizedBox(width: double.infinity, height: 22),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PackagesReadyCounterButton extends StatelessWidget {
  const PackagesReadyCounterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class DescriptionWidget extends StatelessWidget {
  final String description;
  final String? title;
  final TextStyle? descStyle;

  const DescriptionWidget({
    super.key,
    required this.description,
    this.title,
    this.descStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      softWrap: true,
      textAlign: TextAlign.start,
      style: descStyle ??
          const TextStyle(
            color: Color(0xFF020A24),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

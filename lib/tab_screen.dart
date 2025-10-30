import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sytelis_tapbar_project/tab_header_controller.dart';
class TabScreen extends StatelessWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TabHeaderController>(
      init: TabHeaderController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: TabHeaderController.warmBg,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: TabHeaderController.warmBg,
            title: const Text('Activities'),
            toolbarHeight: 56,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Stack(
                key: controller.headerKey,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 12, right: 12),
                    height: 56,
                    color: TabHeaderController.warmBg,
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 4),
                      color: TabHeaderController.dividerGrey,
                    ),
                  ),
                  SingleChildScrollView(
                    controller: controller.scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        for (int i = 0; i < controller.tabs.length; i++)
                          GestureDetector(
                            onTap: () => controller.select(i),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              key: controller.tabKeys[i],
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Text(
                                controller.tabs[i],
                                style: TextStyle(
                                  color: i == controller.selectedIndex ? Colors.black87 : Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    left: controller.indicatorLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      height: 5,
                      width: controller.indicatorWidth > 0 ? controller.indicatorWidth : 0,
                      decoration: BoxDecoration(
                        color: TabHeaderController.indicatorGreen,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Center(
            child: Text(controller.tabs[controller.selectedIndex]),
          ),
        );
      },
    );
  }
}

class RoundedUnderlineTabIndicator extends Decoration {
  final Color color;
  final double thickness;
  final double verticalOffset;
  final double horizontalInset;

  const RoundedUnderlineTabIndicator({
    required this.color,
    this.thickness = 4,
    this.verticalOffset = 4,
    this.horizontalInset = 8,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RoundedUnderlinePainter(this, onChanged);
  }
}

class _RoundedUnderlinePainter extends BoxPainter {
  final RoundedUnderlineTabIndicator decoration;

  _RoundedUnderlinePainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    if (cfg.size == null) return;
    final Size size = cfg.size!;
    final double y = offset.dy + size.height - decoration.verticalOffset;
    final double startX = offset.dx + decoration.horizontalInset;
    final double endX = offset.dx + size.width - decoration.horizontalInset;

    final Paint paint = Paint()
      ..color = decoration.color
      ..strokeWidth = decoration.thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
  }
}
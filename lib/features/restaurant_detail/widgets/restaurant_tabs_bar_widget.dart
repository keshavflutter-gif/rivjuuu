import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class RestaurantTabsBarWidget extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  static const List<String> tabTitles = [
    'Menu',
    'Coupons',
    'Loyalty',
    'Giveaways',
    'Reviews',
  ];

  const RestaurantTabsBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  State<RestaurantTabsBarWidget> createState() =>
      _RestaurantTabsBarWidgetState();
}

class _RestaurantTabsBarWidgetState extends State<RestaurantTabsBarWidget> {
  late final ScrollController _scrollController;
  late final List<GlobalKey> _tabKeys;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabKeys = List.generate(
      RestaurantTabsBarWidget.tabTitles.length,
      (_) => GlobalKey(),
    );
  }

  @override
  void didUpdateWidget(covariant RestaurantTabsBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToTab(widget.selectedIndex);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTab(int index) {
    if (!_scrollController.hasClients) return;
    if (index < 0 || index >= _tabKeys.length) return;

    final ctx = _tabKeys[index].currentContext;
    if (ctx != null) {
      final box = ctx.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        final parentBox = _scrollController
            .position.context.notificationContext
            ?.findRenderObject() as RenderBox?;
        if (parentBox != null) {
          final offset = box.localToGlobal(Offset.zero, ancestor: parentBox);
          final currentScroll = _scrollController.offset;
          final tabLeft = currentScroll + offset.dx;
          final tabRight = tabLeft + box.size.width;
          final viewportWidth = _scrollController.position.viewportDimension;

          if (tabLeft < currentScroll + 20) {
            _scrollController.animateTo(
              (tabLeft - 20)
                  .clamp(0.0, _scrollController.position.maxScrollExtent),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
            );
          } else if (tabRight > currentScroll + viewportWidth - 20) {
            _scrollController.animateTo(
              (tabRight - viewportWidth + 20)
                  .clamp(0.0, _scrollController.position.maxScrollExtent),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: const BoxDecoration(
        color: AppColors.cream,
        border: Border(
          bottom: BorderSide(color: AppColors.line, width: 1),
        ),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: List.generate(RestaurantTabsBarWidget.tabTitles.length, (index) {
            final isSelected = index == widget.selectedIndex;
            return InkWell(
              key: ValueKey('restaurant_tab_$index'),
              onTap: () => widget.onTabSelected(index),
              child: Container(
                key: _tabKeys[index],
                height: 46,
                margin: EdgeInsets.only(
                  right: index == RestaurantTabsBarWidget.tabTitles.length - 1 ? 0 : 22,
                ),
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Center(
                      child: Text(
                        RestaurantTabsBarWidget.tabTitles[index],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppColors.navy : const Color(0xFF71717A),
                        ),
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 3,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.coral,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(3)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

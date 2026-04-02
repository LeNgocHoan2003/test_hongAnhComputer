import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_honganhcom/features/products/presentation/widgets/header_curve_clipper.dart';
import 'package:test_honganhcom/features/products/presentation/bloc/product_list_state.dart';

import '../../../../core/theme/app_colors.dart';
import 'search_field.dart';
import 'tab_chip.dart';

/// Dark navy header: back, search, cart badge, tabs, in-stock toggle.
class StorefrontHeader extends StatelessWidget {
  const StorefrontHeader({
    super.key,
    required this.searchController,
    required this.categoryHint,
    required this.cartCount,
    required this.selectedTab,
    required this.onTabSelected,
    required this.priceAscending,
    required this.onPriceTabTap,
    required this.inStockOnly,
    required this.onInStockChanged,
  });

  final TextEditingController searchController;
  final String categoryHint;
  final int cartCount;
  final StorefrontSortTab selectedTab;
  final ValueChanged<StorefrontSortTab> onTabSelected;
  final bool priceAscending;
  final VoidCallback onPriceTabTap;
  final bool inStockOnly;
  final ValueChanged<bool> onInStockChanged;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    const curveHeight = 22.0;

    return ClipPath(
      clipper: const HeaderCurveClipper(curveHeight: curveHeight),
      child: ColoredBox(
        color: AppColors.appBar,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, topPad + 6, 8, 12 + curveHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: SvgPicture.asset('assets/images/left.svg'),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                  Expanded(
                    child: SearchField(
                      controller: searchController,
                      categoryHint: categoryHint,
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/images/cart.svg',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                        ),
                      ),
                      if (cartCount > 0)
                        Positioned(
                          right: 6,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: const BoxDecoration(
                              color: AppColors.outStockRed,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              cartCount > 9 ? '9+' : '$cartCount',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  TabChip(
                    label: 'Tất cả',
                    selected: selectedTab == StorefrontSortTab.all,
                    onTap: () => onTabSelected(StorefrontSortTab.all),
                  ),
                  TabChip(
                    label: 'Mới nhất',
                    selected: selectedTab == StorefrontSortTab.newest,
                    onTap: () => onTabSelected(StorefrontSortTab.newest),
                  ),
                  InkWell(
                    onTap: onPriceTabTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Giá',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: selectedTab == StorefrontSortTab.price
                                  ? Colors.white
                                  : AppColors.mutedOnAppBar,
                            ),
                          ),
                          const SizedBox(width: 17),
                          // SVG assets cannot use ImageIcon/AssetImage; SvgPicture keeps the same asset path.
                          SvgPicture.asset(
                            'assets/images/price.svg',
                            width: 6,
                            height: 11,
                            colorFilter: ColorFilter.mode(
                              selectedTab == StorefrontSortTab.price
                                  ? Colors.white
                                  : AppColors.mutedOnAppBar,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Còn hàng',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SmallSwitch(
                      value: inStockOnly,
                      onChanged: onInStockChanged,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SmallSwitch extends StatelessWidget {
  const SmallSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  static const double _width = 36;
  static const double _height = 22;
  static const double _thumbSize = 14;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _width,
        height: _height,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_height / 2),
          color: value ? AppColors.accentBlue : AppColors.dottedLine,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment:
                  value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: _thumbSize,
                height: _thumbSize,
                decoration: BoxDecoration(
                  color: value
                      ? Colors.white
                      : AppColors.pageBackground,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
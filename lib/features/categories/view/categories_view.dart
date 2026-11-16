import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../home/widgets/home_bottom_nav_widget.dart';
import '../bloc/categories_bloc.dart';
import '../bloc/categories_state.dart';
import '../widgets/categories_top_bar_widget.dart';
import '../widgets/category_tile_widget.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar
            CategoriesTopBarWidget(
              onSearch: () {
                Navigator.of(context).pushNamed(AppRoutes.search);
              },
            ),

            // Scrollable 2-Column Grid
            Expanded(
              child: BlocBuilder<CategoriesBloc, CategoriesState>(
                builder: (context, state) {
                  return GridView.builder(
                    key: const PageStorageKey<String>('customer_categories_scroll_view'),
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 128,
                    ),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return CategoryTileWidget(
                        category: category,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.restaurantList,
                            arguments: '${category.title} restaurants',
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavWidget(
        currentIndex: 1, // Explore is selected
        onNavTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.home,
              (route) => false,
            );
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.myRewards);
          } else if (index == 4) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.profile);
          }
        },
      ),
    );
  }
}


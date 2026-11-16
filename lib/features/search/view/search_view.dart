import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/routes/app_router.dart';
import '../../restaurant_list/models/restaurant_item_model.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSelectQuery(String query) {
    _controller.text = query;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    context.read<SearchBloc>().add(SearchRecentSelected(query));
  }

  void _onClearSearch() {
    _controller.clear();
    context.read<SearchBloc>().add(const SearchCleared());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.cream,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Back button + Search input (search--active)
              _buildTopBar(context),

              // Dynamic Body: Initial State OR Results State OR No-Results State
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case SearchViewStatus.initial:
                        return _buildInitialState(context, state);
                      case SearchViewStatus.results:
                        return _buildResultsState(context, state);
                      case SearchViewStatus.noResults:
                        return _buildNoResultsState(context, state);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          // Round Back Button (42x42)
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.line),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: AppColors.navy,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Search Field (.search.search--active)
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.navy,
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: AppColors.navy,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (val) {
                        context.read<SearchBloc>().add(SearchSubmitted(val));
                      },
                      onChanged: (val) {
                        context
                            .read<SearchBloc>()
                            .add(SearchQueryChanged(val));
                      },
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        color: AppColors.navy,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Search restaurants',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFFA1A1AA),
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  BlocBuilder<SearchBloc, SearchState>(
                    buildWhen: (p, c) => (p.query.isEmpty) != (c.query.isEmpty),
                    builder: (context, state) {
                      if (state.query.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return GestureDetector(
                        onTap: _onClearSearch,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1ECE2),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Initial State: search.html (Recent searches, Popular categories, Suggested)
  // ---------------------------------------------------------------------------
  Widget _buildInitialState(BuildContext context, SearchState state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches section
          if (state.recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Recent searches',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    letterSpacing: -0.2,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context
                        .read<SearchBloc>()
                        .add(const SearchAllRecentCleared());
                  },
                  child: Text(
                    'Clear',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.coral,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Column(
              children: List.generate(
                state.recentSearches.length,
                (index) {
                  final item = state.recentSearches[index];
                  return _buildRecentSearchItem(
                    context,
                    item,
                    index,
                  );
                },
              ),
            ),
          ],

          // Popular categories section
          const SizedBox(height: 26),
          Text(
            'Popular categories',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.popularCategories.map((cat) {
              return _buildCategoryChip(context, cat);
            }).toList(),
          ),

          // Suggested for you section
          const SizedBox(height: 26),
          Text(
            'Suggested for you',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          _buildRestaurantRow(
            context: context,
            item: const RestaurantItemModel(
              name: 'Kōya Sushi & Ramen',
              imagePath: AppAssets.sushi,
              rating: '9.2',
              cuisine: 'Asian',
              distance: '2.4 km',
              perkText: '3 coupons',
              perkIcon: Icons.confirmation_number_outlined,
            ),
          ),
          const Divider(
            color: AppColors.line,
            height: 1,
            thickness: 1,
          ),
          _buildRestaurantRow(
            context: context,
            item: const RestaurantItemModel(
              name: 'Café Mókus',
              imagePath: AppAssets.coffee,
              rating: '9.0',
              cuisine: 'Café',
              distance: '400 m',
              perkText: 'Free dessert',
              perkIcon: Icons.card_giftcard_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(
    BuildContext context,
    String query,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _onSelectQuery(query),
      child: Container(
        height: 48,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.line, width: 1.0),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.schedule_outlined,
              size: 18,
              color: Color(0xFF71717A),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                query,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.navy,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read<SearchBloc>().add(SearchRecentRemoved(index));
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Color(0xFF71717A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String title) {
    return GestureDetector(
      onTap: () => _onSelectQuery(title),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Results State: search-results.html ("6 restaurants for 'pizza'")
  // ---------------------------------------------------------------------------
  Widget _buildResultsState(BuildContext context, SearchState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Count line matching search-results.html
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
          child: Text(
            '${state.searchResults.length} restaurants for “${state.query}”',
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: AppColors.text,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        // Scrollable Results List
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
            itemCount: state.searchResults.length,
            separatorBuilder: (context, index) => const Divider(
              color: AppColors.line,
              height: 1,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              final item = state.searchResults[index];
              return _buildRestaurantRow(
                context: context,
                item: item,
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 3. No Results State: search-no-results.html ("No restaurants found")
  // ---------------------------------------------------------------------------
  Widget _buildNoResultsState(BuildContext context, SearchState state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 70, 30, 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Large circular icon (96x96 with soft coral bg and coral search icon)
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(254, 85, 46, 0.12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.search_rounded,
                    size: 42,
                    color: AppColors.coral,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                'No restaurants found',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),

              const SizedBox(height: 6),

              // Description
              Text(
                'Try another name or dish, or browse by category.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: AppColors.text,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 22),

              // "Browse categories" Outline Button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.coral, width: 1.5),
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.coral,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _onClearSearch,
                child: Text(
                  'Browse categories',
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coral,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Reusable Restaurant Row matching .rr in rv3.css
  // ---------------------------------------------------------------------------
  Widget _buildRestaurantRow({
    required BuildContext context,
    required RestaurantItemModel item,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.restaurantDetail,
          arguments: item.name,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 92x92 rounded image with optional offer badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    item.imagePath,
                    width: 92,
                    height: 92,
                    fit: BoxFit.cover,
                  ),
                ),
                if (item.imageOfferBadge != null)
                  Positioned(
                    left: 6,
                    top: 6,
                    child: Container(
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: AppColors.coral,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item.imageOfferBadge!,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // Info Body
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.speed_rounded,
                        size: 15,
                        color: AppColors.coral,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        item.rating,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                      _buildDotSeparator(),
                      Flexible(
                        child: Text(
                          item.cuisine,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: AppColors.text,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildDotSeparator(),
                      Text(
                        item.distance,
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  if (item.perkText != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.perkIcon != null) ...[
                          Icon(
                            item.perkIcon,
                            size: 15,
                            color: AppColors.coral,
                          ),
                          const SizedBox(width: 5),
                        ],
                        Text(
                          item.perkText!,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.coral,
                          ),
                        ),
                      ],
                    ),
                  ] else if (item.badgeText != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      decoration: BoxDecoration(
                        color: AppColors.peach,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          item.badgeText!,
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF7A4A00),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotSeparator() {
    return Container(
      width: 3,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
        color: Color(0xFFB5B0A6),
        shape: BoxShape.circle,
      ),
    );
  }
}

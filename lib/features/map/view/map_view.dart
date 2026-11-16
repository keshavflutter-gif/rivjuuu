import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import '../widgets/map_vector_canvas_widget.dart';
import '../widgets/map_top_bar_widget.dart';
import '../widgets/map_bottom_card_widget.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFECEEE9),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          final selectedRestaurant = state.selectedPin;

          return Stack(
            children: [
              // 1. Fullscreen Vector Map Canvas with Pins
              Positioned.fill(
                child: MapVectorCanvasWidget(
                  pins: state.pins,
                  selectedPinId: state.selectedPinId,
                  userLocation: state.userLocation,
                  onPinSelected: (pinId) {
                    context.read<MapBloc>().add(MapPinSelected(pinId));
                  },
                ),
              ),

              // 2. Top Bar (Back button, Search area, Map/List Segment)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: MapTopBarWidget(
                  onBack: () => Navigator.of(context).pop(),
                  onSearchTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.search);
                  },
                  onListTap: () {
                    // Navigate to Restaurant List
                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.restaurantList,
                    );
                  },
                ),
              ),

              // 3. Floating 'My Location' Button
              Positioned(
                right: 16,
                bottom: 230 + bottomPadding,
                child: GestureDetector(
                  onTap: () {
                    context.read<MapBloc>().add(const MapMyLocationTapped());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Centered to your location'),
                        duration: Duration(seconds: 1),
                        backgroundColor: AppColors.navy,
                      ),
                    );
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.14),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.my_location_rounded,
                        size: 20,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ),
              ),

              // 4. Bottom Selected Restaurant Card
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomPadding + 14,
                child: MapBottomCardWidget(
                  restaurant: selectedRestaurant,
                  onViewRestaurant: () {
                    // Navigate to Restaurant Detail
                    Navigator.of(context).pushNamed(
                      AppRoutes.restaurantDetail,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


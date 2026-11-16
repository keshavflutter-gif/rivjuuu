import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/map_pin_model.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  static const List<MapPinModel> defaultPins = [
    MapPinModel(
      id: 'nr',
      name: 'Trattoria Nonna Rosa',
      rating: '8.9',
      cuisine: 'Italian',
      distance: '1.2 km',
      openStatus: 'until 23:00',
      couponCount: 3,
      imagePath: 'assets/pasta.jpg',
      dx: 210,
      dy: 448,
    ),
    MapPinModel(
      id: 'bbb',
      name: 'Bamba Burger Bar',
      rating: '8.7',
      cuisine: 'Burgers',
      distance: '1.5 km',
      openStatus: 'until 22:00',
      couponCount: 2,
      imagePath: 'assets/burger.jpg',
      dx: 92,
      dy: 236,
    ),
    MapPinModel(
      id: 'cm',
      name: 'Café Mókus',
      rating: '9.0',
      cuisine: 'Café',
      distance: '400 m',
      openStatus: 'until 20:00',
      couponCount: 1,
      imagePath: 'assets/coffee.jpg',
      dx: 200,
      dy: 330,
    ),
    MapPinModel(
      id: 'mh',
      name: 'Masala House',
      rating: '8.8',
      cuisine: 'Indian',
      distance: '850 m',
      openStatus: 'until 22:30',
      couponCount: 2,
      imagePath: 'assets/indian.jpg',
      dx: 70,
      dy: 560,
    ),
    MapPinModel(
      id: 'ksr',
      name: 'Kōya Sushi & Ramen',
      rating: '9.2',
      cuisine: 'Asian',
      distance: '2.4 km',
      openStatus: 'until 23:00',
      couponCount: 3,
      imagePath: 'assets/ramen.jpg',
      dx: 300,
      dy: 180,
    ),
  ];

  MapBloc({String? initialSelectedName})
      : super(const MapState(pins: defaultPins)) {
    on<MapStarted>(_onStarted);
    on<MapPinSelected>(_onPinSelected);
    on<MapMyLocationTapped>(_onMyLocationTapped);

    if (initialSelectedName != null) {
      add(MapStarted(initialSelectedName: initialSelectedName));
    }
  }

  void _onStarted(MapStarted event, Emitter<MapState> emit) {
    if (event.initialSelectedName != null) {
      final matching = state.pins.firstWhere(
        (p) =>
            p.name.toLowerCase() == event.initialSelectedName!.toLowerCase(),
        orElse: () => state.pins.first,
      );
      emit(state.copyWith(selectedPinId: matching.id));
    }
  }

  void _onPinSelected(MapPinSelected event, Emitter<MapState> emit) {
    emit(state.copyWith(selectedPinId: event.pinId));
  }

  void _onMyLocationTapped(MapMyLocationTapped event, Emitter<MapState> emit) {
    // Center or reset to user location
  }
}


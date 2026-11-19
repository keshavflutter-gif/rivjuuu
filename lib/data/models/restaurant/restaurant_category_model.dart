import 'package:equatable/equatable.dart';

class RestaurantCategoryModel extends Equatable {
  final String id;
  final String slug;
  final String name;
  final String? description;
  final String? status;
  final int? sortOrder;
  final int? restaurantsCount;
  final List<CategoryTranslation>? translations;
  final String? createdAt;
  final String? updatedAt;

  const RestaurantCategoryModel({
    required this.id,
    this.slug = '',
    required this.name,
    this.description,
    this.status,
    this.sortOrder,
    this.restaurantsCount,
    this.translations,
    this.createdAt,
    this.updatedAt,
  });

  factory RestaurantCategoryModel.fromJson(Map<String, dynamic> json) {
    return RestaurantCategoryModel(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      status: json['status'] as String?,
      sortOrder: json['sortOrder'] is int
          ? json['sortOrder'] as int
          : int.tryParse(json['sortOrder']?.toString() ?? ''),
      restaurantsCount: json['restaurantsCount'] is int
          ? json['restaurantsCount'] as int
          : int.tryParse(json['restaurantsCount']?.toString() ?? ''),
      translations: json['translations'] is List
          ? (json['translations'] as List)
              .map((t) => CategoryTranslation.fromJson(t as Map<String, dynamic>))
              .toList()
          : null,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (restaurantsCount != null) 'restaurantsCount': restaurantsCount,
      if (translations != null)
        'translations': translations!.map((t) => t.toJson()).toList(),
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  String localizedName(String localeCode) {
    final targetLang = localeCode.toLowerCase().split(RegExp(r'[-_]')).first;
    if (translations != null && translations!.isNotEmpty) {
      final match = translations!.firstWhere(
        (t) {
          final l = (t.locale ?? '').toLowerCase().split(RegExp(r'[-_]')).first;
          return l == targetLang;
        },
        orElse: () => const CategoryTranslation(),
      );
      if (match.name != null && match.name!.trim().isNotEmpty) {
        return match.name!.trim();
      }
    }
    if (targetLang == 'hu') {
      final lower = name.trim().toLowerCase();
      final slugLower = slug.trim().toLowerCase();
      if (lower.contains('italian') || slugLower.contains('italian')) return 'Olasz';
      if (lower.contains('burger') || slugLower.contains('burger')) return 'Hamburger';
      if (lower.contains('pizza') || slugLower.contains('pizza')) return 'Pizza';
      if (lower.contains('asian') || slugLower.contains('asian')) return 'Ázsiai';
      if (lower.contains('hungarian') || slugLower.contains('hungarian')) return 'Magyar';
      if (lower.contains('indian') || slugLower.contains('indian')) return 'Indiai';
      if (lower.contains('dessert') || slugLower.contains('dessert') || lower.contains('sweet')) return 'Desszertek';
      if (lower.contains('coffee') || slugLower.contains('coffee') || lower.contains('cafe')) return 'Kávézó';
      if (lower.contains('healthy') || slugLower.contains('healthy') || lower.contains('salad')) return 'Egészséges';
      if (lower.contains('street food') || slugLower.contains('street food')) return 'Street food';
      if (lower.contains('mexican') || slugLower.contains('mexican')) return 'Mexikói';
      if (lower.contains('sushi') || slugLower.contains('sushi')) return 'Szusi';
      if (lower.contains('bakery') || slugLower.contains('bakery')) return 'Pékség';
      if (lower.contains('bar') || slugLower.contains('bar') || lower.contains('pub')) return 'Bár';
      if (lower.contains('american') || slugLower.contains('american')) return 'Amerikai';
      if (lower.contains('chinese') || slugLower.contains('chinese')) return 'Kínai';
      if (lower.contains('japanese') || slugLower.contains('japanese')) return 'Japán';
      if (lower.contains('thai') || slugLower.contains('thai')) return 'Thai';
      if (lower.contains('greek') || slugLower.contains('greek')) return 'Görög';
      if (lower.contains('french') || slugLower.contains('french')) return 'Francia';
      if (lower.contains('fast food') || slugLower.contains('fast food')) return 'Gyorsétterem';
      if (lower.contains('seafood') || slugLower.contains('seafood')) return 'Tenger gyümölcsei';
      if (lower.contains('bbq') || slugLower.contains('bbq') || lower.contains('grill')) return 'Grill & BBQ';
      if (lower.contains('breakfast') || slugLower.contains('breakfast')) return 'Reggeli';
      if (lower.contains('sandwich') || slugLower.contains('sandwich')) return 'Szendvics';
    } else if (targetLang == 'en') {
      final lower = name.trim().toLowerCase();
      if (lower == 'olasz') return 'Italian';
      if (lower == 'hamburger') return 'Burger';
      if (lower == 'ázsiai') return 'Asian';
      if (lower == 'magyar') return 'Hungarian';
      if (lower == 'indiai') return 'Indian';
      if (lower == 'desszertek') return 'Desserts';
      if (lower == 'kávézó') return 'Cafe';
      if (lower == 'egészséges') return 'Healthy';
      if (lower == 'mexikói') return 'Mexican';
      if (lower == 'szusi') return 'Sushi';
      if (lower == 'pékség') return 'Bakery';
      if (lower == 'bár') return 'Bar';
    }
    return name;
  }

  String? localizedDescription(String localeCode) {
    final targetLang = localeCode.toLowerCase().split(RegExp(r'[-_]')).first;
    if (translations != null && translations!.isNotEmpty) {
      final match = translations!.firstWhere(
        (t) {
          final l = (t.locale ?? '').toLowerCase().split(RegExp(r'[-_]')).first;
          return l == targetLang;
        },
        orElse: () => const CategoryTranslation(),
      );
      if (match.description != null && match.description!.trim().isNotEmpty) {
        return match.description!.trim();
      }
    }
    if (targetLang == 'hu') {
      final lower = name.trim().toLowerCase();
      final slugLower = slug.trim().toLowerCase();
      final descLower = (description ?? '').trim().toLowerCase();
      if (lower.contains('italian') || slugLower.contains('italian') || descLower.contains('italian')) {
        return 'Autentikus olasz konyha';
      }
      if (lower.contains('burger') || slugLower.contains('burger') || descLower.contains('burger')) {
        return 'Hamburgerek, sült krumpli és street food';
      }
      if (lower.contains('pizza') || slugLower.contains('pizza') || descLower.contains('pizza')) {
        return 'Friss pizzák és kemencében sült ételek';
      }
      if (lower.contains('asian') || slugLower.contains('asian') || descLower.contains('asian')) {
        return 'Tradicionális ázsiai ízek';
      }
      if (lower.contains('dessert') || slugLower.contains('dessert') || descLower.contains('dessert')) {
        return 'Édességek, sütemények és torták';
      }
      if (lower.contains('coffee') || slugLower.contains('coffee') || lower.contains('cafe')) {
        return 'Különleges kávék és meleg italok';
      }
      if (lower.contains('healthy') || slugLower.contains('healthy') || descLower.contains('healthy')) {
        return 'Friss saláták és egészséges ételek';
      }
      if (lower.contains('hungarian') || slugLower.contains('hungarian') || descLower.contains('hungarian')) {
        return 'Hagyományos magyar ételek';
      }
    }
    return description;
  }

  @override
  List<Object?> get props => [
        id,
        slug,
        name,
        description,
        status,
        sortOrder,
        restaurantsCount,
        translations,
        createdAt,
        updatedAt,
      ];
}

class CategoryTranslation extends Equatable {
  final String? id;
  final String? categoryId;
  final String? locale;
  final String? name;
  final String? description;

  const CategoryTranslation({
    this.id,
    this.categoryId,
    this.locale,
    this.name,
    this.description,
  });

  factory CategoryTranslation.fromJson(Map<String, dynamic> json) {
    return CategoryTranslation(
      id: json['id'] as String?,
      categoryId: json['categoryId'] as String?,
      locale: json['locale'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (categoryId != null) 'categoryId': categoryId,
      if (locale != null) 'locale': locale,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    };
  }

  @override
  List<Object?> get props => [id, categoryId, locale, name, description];
}

class RestaurantCategoriesResponse extends Equatable {
  final int success;
  final String message;
  final List<RestaurantCategoryModel> data;
  final int? count;

  const RestaurantCategoriesResponse({
    required this.success,
    required this.message,
    required this.data,
    this.count,
  });

  bool get isSuccess => success == 1;

  factory RestaurantCategoriesResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] is List ? json['data'] as List : [];
    return RestaurantCategoriesResponse(
      success: json['success'] is int
          ? json['success'] as int
          : int.tryParse(json['success']?.toString() ?? '0') ?? 0,
      message: json['message'] as String? ?? '',
      data: list
          .whereType<Map<String, dynamic>>()
          .map(RestaurantCategoryModel.fromJson)
          .toList(),
      count: json['count'] is int
          ? json['count'] as int
          : int.tryParse(json['count']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      if (count != null) 'count': count,
    };
  }

  @override
  List<Object?> get props => [success, message, data, count];
}


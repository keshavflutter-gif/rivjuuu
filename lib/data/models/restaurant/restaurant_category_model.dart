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


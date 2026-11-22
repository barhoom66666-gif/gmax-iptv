import '../../helpers/helpers.dart';

class CategoryModel {
  final String? categoryId;
  final String? categoryName;
  final String? parentId;

  CategoryModel({
    this.categoryId,
    this.categoryName,
    this.parentId,
  });

  CategoryModel.fromJson(Map<String, dynamic> json)
      : categoryId = sanitizeString(json['category_id']),
        categoryName = sanitizeString(json['category_name']),
        parentId = sanitizeString(json['parent_id']);

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'category_name': categoryName,
        'parent_id': parentId,
      };
}

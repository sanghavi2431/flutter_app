import 'store_product_category.dart';

class ProductCategoryWrapper {
  List<StoreProductCategory>? categories;

  ProductCategoryWrapper({this.categories});

  factory ProductCategoryWrapper.fromJson(Map<String, dynamic> json) {
    return ProductCategoryWrapper(
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => StoreProductCategory.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'categories': categories?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}

// category_state.dart
import '../model/product_category_wrapper.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final ProductCategoryWrapper categoryWrapper;
  CategorySuccess(this.categoryWrapper);
}

class CategoryFailure extends CategoryState {
  final String error;
  CategoryFailure(this.error);
}

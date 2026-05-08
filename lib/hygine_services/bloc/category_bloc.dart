import 'package:flutter_bloc/flutter_bloc.dart';
import '../network/category_repository.dart';
import '../model/product_category_wrapper.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc({required this.repository}) : super(CategoryInitial()) {
    on<FetchCategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        final data = await repository.fetchCategories();

        // ✅ Log complete response as JSON
        print("✅ Category API response: ${data.toJson()}");

        emit(CategorySuccess(data));
      } catch (e) {
        print("❌ Category API error: $e");
        emit(CategoryFailure(e.toString()));
      }
    });
  }
}

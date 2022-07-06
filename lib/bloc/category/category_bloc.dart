import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kem/model/category.dart';
import 'package:kem/repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _repository = CategoryRepository();
  final List<Category> _categoryList = [Category(category: 'All')];
  CategoryBloc() : super(CategoryInitial()) {
    on<LoadCategoryEvent>((event, emit) async {
      final newList = await _repository
          .getAllCategory()
          .map((snapshot) => snapshot.docs.map((e) {
                return Category.fromMap(e.data());
              }).toList())
          .first;
      _categoryList.addAll(newList);
      emit(CategoryLoaded(categoryList: [..._categoryList]));
    });
  }
}

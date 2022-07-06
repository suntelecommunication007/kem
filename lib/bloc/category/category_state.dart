part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
}

class CategoryInitial extends CategoryState {
  @override
  List<Object?> get props => [];
}

class CategoryLoaded extends CategoryState {
  final List<Category> categoryList;
  const CategoryLoaded({required this.categoryList});
  @override
  List<Object?> get props => [];
}

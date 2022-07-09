part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
}

class LoadProducts extends ProductsEvent {
  final String category;
  const LoadProducts(this.category);
  @override
  List<Object> get props => [];
}

class LoadMoreProducts extends ProductsEvent {
  @override
  List<Object> get props => [];
}

class CategorySelectedEvent extends ProductsEvent {
  final String category;

  const CategorySelectedEvent(this.category);

  @override
  List<Object?> get props => [category];
}

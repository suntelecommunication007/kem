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
  final int loadedProductsCount;
  const LoadMoreProducts({required this.loadedProductsCount});
  @override
  List<Object> get props => [loadedProductsCount];
}

class CategorySelectedEvent extends ProductsEvent {
  final String category;

  const CategorySelectedEvent(this.category);

  @override
  List<Object?> get props => [category];
}

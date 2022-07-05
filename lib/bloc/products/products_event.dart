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
  final String category;
  final int loadedProductsCount;

  const LoadMoreProducts({required this.category,required this.loadedProductsCount});
  @override
  List<Object> get props => [category,loadedProductsCount];
}

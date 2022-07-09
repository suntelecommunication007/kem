part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();
}

class ProductsLoadingState extends ProductsState {
  @override
  List<Object?> get props => [];
}

class ProductsLoadedState extends ProductsState {
  final List<Product> productsList;

  const ProductsLoadedState({required this.productsList});

  @override
  List<Object?> get props => [productsList];
}

class LoadingMoreProducts extends ProductsState {
  final List<Product> productsList;
  const LoadingMoreProducts({required this.productsList});
  @override
  List<Object?> get props => [];
}

class NoMoreProducts extends ProductsState {
  final List<Product> productsList;
  const NoMoreProducts({required this.productsList});
  @override
  List<Object?> get props => [];
}

class ProductsLoadingErrorState extends ProductsState {
  const ProductsLoadingErrorState();
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FilterProductsLoadedState extends ProductsState {
  final List<Product> filteProductsList;
  const FilterProductsLoadedState({required this.filteProductsList});
  @override
  List<Object?> get props => [filteProductsList];
}

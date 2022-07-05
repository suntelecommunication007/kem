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

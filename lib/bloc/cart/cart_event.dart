part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class LoadCart extends CartEvent {
  const LoadCart();
  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final CartItem cartItem;

  const AddToCart(this.cartItem);

  @override
  List<Object?> get props => [cartItem];
}

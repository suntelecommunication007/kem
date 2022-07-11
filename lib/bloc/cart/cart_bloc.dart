import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kem/model/cart.dart';
import 'package:kem/model/cart_item.dart';
import 'package:kem/repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  Cart _cart = Cart(cartList: []);
  final _repository = CartRepository();
  CartBloc() : super(CartInitial()) {
    on<CartEvent>((event, emit) async {
      if (event is LoadCart) {
        // final cartFromFirebase = await _repository
        //     .loadCartOfTheUser('123')
        //     .map((event) => Cart.fromMap(event.data()!))
        //     .first;
        // _cart = cartFromFirebase;
        emit(CartLoaded(Cart(cartList: [..._cart.cartList])));
      } else if (event is AddToCart) {
        _cart.cartList.add(event.cartItem);
        emit(CartLoaded(Cart(cartList: [..._cart.cartList])));
      }
    });
  }
}

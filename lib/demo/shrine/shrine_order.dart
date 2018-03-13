import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../shrine_demo.dart' show ShrinePageRoute;
import 'shrine_types.dart';
import 'shrine_theme.dart';
import 'shrine_page.dart';

class ShrineOrderRoute extends ShrinePageRoute<Order> {
  Order order;

  @override
  Order get currentResult => order;

  ShrineOrderRoute({
    @required this.order,
    WidgetBuilder builder,
    RouteSettings settings: const RouteSettings(),
  })
      : assert(order != null),
        super(builder: builder, settings: settings);

  static ShrineOrderRoute of(BuildContext context) => ModalRoute.of(context);
}

class OrderPage extends StatefulWidget {
  final Order order;
  final List<Product> products;
  final Map<Product, Order> shoppingCart;

  const OrderPage(
      {Key key,
      @required this.order,
      @required this.products,
      @required this.shoppingCart})
      : assert(order != null),
        // ignore: const_eval_type_bool, non_constant_value_in_initializer
        assert(products != null),
        assert(shoppingCart != null),
        super(key: key);

  @override
  _OrderPageState createState() => new _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return new Container(child: new Text("order page."));
  }
}

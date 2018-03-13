import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'shrine_theme.dart';
import 'shrine_types.dart';

enum ShrineAction { sortByPrice, sortByProduct, emptyCart }

class ShrinePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scafflodKey;
  final Widget body;
  final Widget floatingActionButton;
  final List<Product> products;
  final Map<Product, Order> shoppingCart;

  @override
  ShrinePageState createState() => new ShrinePageState();

  const ShrinePage(
      {Key key,
      @required this.scafflodKey,
      @required this.body,
      this.floatingActionButton,
      this.products,
      this.shoppingCart})
      : assert(body != null),
        assert(scafflodKey != null),
        super(key: key);
}

class ShrinePageState extends State<ShrinePage> {
  var _appBarElevation = 0.0;

  @override
  Widget build(BuildContext context) {
    final ShrineTheme theme = ShrineTheme.of(context);
    return new Scaffold(
        key: widget.scafflodKey,
        appBar: new AppBar(
          elevation: _appBarElevation,
          backgroundColor: theme.appBarBackgroundColor,
          iconTheme: Theme.of(context).iconTheme,
          brightness: Brightness.light,
          flexibleSpace: new Container(),
          title: new Text('SHRINE',
              style: ShrineTheme.of(context).appBarTitleStyle),
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
                icon: const Icon(Icons.shopping_cart),
                tooltip: 'Shopping cart',
                onPressed: _showShoppingCart),
            new PopupMenuButton<ShrineAction>(
              itemBuilder: (BuildContext context) =>
                  <PopupMenuItem<ShrineAction>>[
                    const PopupMenuItem(
                      child: const Text('Sort By price'),
                      value: ShrineAction.sortByPrice,
                    ),
                    const PopupMenuItem(
                      child: const Text('Sort By product'),
                      value: ShrineAction.sortByProduct,
                    ),
                    const PopupMenuItem(
                      child: const Text('Empty shopping cart'),
                      value: ShrineAction.emptyCart,
                    ),
                  ],
              onSelected: (ShrineAction action) {
                switch (action) {
                  case ShrineAction.sortByPrice:
                    setState(_sortByPrice);
                    break;
                  case ShrineAction.sortByProduct:
                    setState(_sortByProduct);
                    break;
                  case ShrineAction.emptyCart:
                    setState(_emptyCart);
                    break;
                }
              },
            ),
          ],
        ),
        floatingActionButton: widget.floatingActionButton,
        body: new NotificationListener<ScrollNotification>(
          child: widget.body,
          onNotification: _handleScrollNotification,
        ));
  }

  void _sortByPrice() {
    widget.products.sort((Product a, Product b) => a.price.compareTo(b.price));
  }

  void _sortByProduct() {
    widget.products.sort((Product a, Product b) => a.name.compareTo(b.name));
  }

  void _emptyCart() {
    widget.shoppingCart.clear();
    widget.scafflodKey.currentState.showSnackBar(
        const SnackBar(content: const Text('Shopping cart is empty')));
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    final double elevation =
        notification.metrics.extentBefore <= 0.0 ? 0.0 : 1.0;
    if (elevation != _appBarElevation) {
      setState(() {
        _appBarElevation = elevation;
      });
    }
    return false;
  }

  void _showShoppingCart() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          if (widget.shoppingCart.isEmpty) {
            return const Padding(
              padding: const EdgeInsets.all(24.0),
              child: const Text('The shopping cart is empty'),
            );
          }

          return new ListView(
            padding: kMaterialListPadding,
            children: widget.shoppingCart.values.map((Order order) {
              return new ListTile(
                  title: new Text(order.product.name),
                  leading: new Text('${order.quantity}'),
                  subtitle: new Text(order.product.vendor.name));
            }).toList(),
          );
        });
  }
}

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
  GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scaffoldKey =
        new GlobalKey<ScaffoldState>(debugLabel: 'Shrine Order${widget.order}');
  }

  Order get currentOrder => ShrineOrderRoute.of(context).order;

  set currentOrder(Order value) {
    ShrineOrderRoute.of(context).order = value;
  }

  void updateOrder({int quantity, bool inCart}) {
    final Order newOrder =
        currentOrder.copyWith(quantity: quantity, inCart: inCart);
    if (currentOrder != newOrder) {
      setState(() {
        widget.shoppingCart[newOrder.product] = newOrder;
        currentOrder = newOrder;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ShrinePage(
        scafflodKey: scaffoldKey,
        products: widget.products,
        shoppingCart: widget.shoppingCart,
        floatingActionButton: new FloatingActionButton(
            backgroundColor: const Color(0xFFFF0000),
            child: const Icon(Icons.add_shopping_cart, color: Colors.white),
            onPressed: () {
              updateOrder(inCart: true);
              final int n = currentOrder.quantity;
              final String item = currentOrder.product.name;
              showSnackBarMessage('There ${n == 1
                  ? "is one $item item"
                  : "are $n $item items"} in the shopping cart.');
            }),
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverToBoxAdapter(
              child: new _Heading(
                product: widget.order.product,
                quantity: currentOrder.quantity,
                quantityChanged: (int value) {
                  updateOrder(quantity: value);
                },
              ),
            ),
            new SliverSafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0),
                sliver: new SliverGrid(
                    delegate: new SliverChildListDelegate(
                      widget.products
                          .where((Product product) =>
                              product != widget.order.product)
                          .map((Product product) {
                        return new Card(
                          elevation: 1.0,
                          child: new Image.asset(product.imageAsset,
                              fit: BoxFit.contain),
                        );
                      }).toList(),
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 248.0,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0))),
          ],
        ));
  }

  void showSnackBarMessage(String message) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}

class _Heading extends StatelessWidget {
  final Product product;
  final int quantity;
  final ValueChanged<int> quantityChanged;

  const _Heading({
    Key key,
    @required this.product,
    @required this.quantity,
    this.quantityChanged,
  })
      : assert(product != null),
        assert(quantity != null && quantity >= 0 && quantity <= 5),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new SizedBox(
      height: (screenSize.height - kToolbarHeight) * 1.35,
      child: new Material(
        type: MaterialType.card,
        elevation: 0.0,
        child: new Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 18.0, right: 16.0, bottom: 24.0),
          child: new CustomMultiChildLayout(
            delegate: new _HeadingLayout(),
            children: <Widget>[
              new LayoutId(
                  id: _HeadingLayout.image,
                  child: new Hero(
                      tag: product.tag,
                      child: new Image.asset(
                        product.imageAsset,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ))),
              new LayoutId(
                  id: _HeadingLayout.icon,
                  child: const Icon(Icons.info_outline,
                      size: 24.0, color: const Color(0xFF0000))),
              new LayoutId(
                  id: _HeadingLayout.product,
                  child: new _ProductItem(
                    product: product,
                    quantity: quantity,
                    onChanged: quantityChanged,
                  )),
              new LayoutId(
                  id: _HeadingLayout.vendor,
                  child: new _VendorItem(vendor: product.vendor))
            ],
          ),
        ),
      ),
    );
  }
}

class _VendorItem extends StatelessWidget {
  final Vendor vendor;

  const _VendorItem({Key key, @required this.vendor})
      : assert(vendor != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShrineTheme theme = ShrineTheme.of(context);
    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new SizedBox(
          height: 24.0,
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: new Text(vendor.name, style: theme.vendorTitleStyle),
          ),
        ),
        const SizedBox(height: 16.0),
        new Text(vendor.description, style: theme.vendorStyle),
      ],
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;
  final int quantity;
  final ValueChanged<int> onChanged;

  const _ProductItem(
      {Key key,
      @required this.product,
      @required this.quantity,
      @required this.onChanged})
      : assert(product != null),
        assert(quantity != null),
        assert(onChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShrineTheme theme = ShrineTheme.of(context);
    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Text(product.name, style: theme.featureTitleStyle),
        const SizedBox(
          height: 24.0,
        ),
        new Text(
          product.description,
          style: theme.featureStyle,
        ),
        const SizedBox(
          height: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 88.0),
          child: new DropdownButtonHideUnderline(
            child: new Container(
              decoration: new BoxDecoration(
                border: new Border.all(color: const Color(0xFFD9D9D9)),
              ),
              child: new DropdownButton<int>(
                items: <int>[0, 1, 2, 3, 4, 5].map((int value) {
                  return new DropdownMenuItem<int>(
                      value: value,
                      child: new Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: new Text('Quantity $value',
                              style: theme.quantityMenuStyle)));
                }).toList(),
                value: quantity,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeadingLayout extends MultiChildLayoutDelegate {
  _HeadingLayout();

  static const String image = 'image';
  static const String icon = 'icon';
  static const String product = 'product';
  static const String vendor = 'vendor';

  @override
  void performLayout(Size size) {
    const double margin = 56.0;
    const double imageY = 0.0;
    final bool landscape = size.width > size.height;
    final double imageWidth =
        (landscape ? size.width / 2.0 : size.width) - margin * 2.0;
    final BoxConstraints imageConstraints =
        new BoxConstraints(maxHeight: 224.0, maxWidth: imageWidth);
    final Size imageSize = layoutChild(image, imageConstraints);
    positionChild(image, const Offset(margin, imageY));

    final double productWidth =
        landscape ? size.width / 2.0 : size.width - margin;
    final BoxConstraints productConstraints =
        new BoxConstraints(maxWidth: productWidth);
    final Size productSize = layoutChild(product, productConstraints);
    final double productX = landscape ? size.width / 2.0 : margin;
    final double productY = landscape ? 0.0 : imageY + imageSize.height + 16.0;
    positionChild(product, new Offset(productX, productY));

    final Size iconSize = layoutChild(icon, new BoxConstraints.loose(size));
    positionChild(
        icon, new Offset(productX - iconSize.width - 16.0, productY + 8.0));

    final double vendorWidth = landscape ? size.width - margin : productWidth;
    layoutChild(vendor, new BoxConstraints(maxWidth: vendorWidth));
    final double vendorX = landscape ? margin : productX;
    final double vendorY = productY + productSize.height + 16.0;
    positionChild(vendor, new Offset(vendorX, vendorY));
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

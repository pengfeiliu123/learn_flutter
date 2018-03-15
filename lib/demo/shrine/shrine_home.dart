import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:learn_flutter/demo/shrine/shrine_data.dart';
import 'package:learn_flutter/demo/shrine/shrine_order.dart';
import 'package:learn_flutter/demo/shrine/shrine_page.dart';
import 'package:learn_flutter/demo/shrine/shrine_theme.dart';
import 'package:learn_flutter/demo/shrine/shrine_types.dart';
import 'package:meta/meta.dart';

const double unitSize = kToolbarHeight;

final List<Product> _products = new List<Product>.from(allProducts());
final Map<Product, Order> _shoppingCart = <Product, Order>{};

//const int _childrenPerBlock = 8;
//const int _rowsPerBlock = 5;
//
//int _minIndexInRow(int rowIndex) {
//  final int blockIndex = rowIndex ~/ _rowsPerBlock;
//  return const <int>[0, 2, 4, 6, 7][rowIndex % _rowsPerBlock] + blockIndex * _childrenPerBlock;
//}
//
//int _maxIndexInRow(int rowIndex) {
//  final int blockIndex = rowIndex ~/ _rowsPerBlock;
//  return const <int>[1, 3, 5, 6, 7][rowIndex % _rowsPerBlock] + blockIndex * _childrenPerBlock;
//}
//
//int _rowAtIndex(int index) {
//  final int blockCount = index ~/ _childrenPerBlock;
//  return const <int>[0, 0, 1, 1, 2, 2, 3, 4][index - blockCount * _childrenPerBlock] + blockCount * _rowsPerBlock;
//}
//
//int _columnAtIndex(int index) {
//  return const <int>[0, 1, 0, 1, 0, 1, 0, 0][index % _childrenPerBlock];
//}
//
//int _columnSpanAtIndex(int index) {
//  return const <int>[1, 1, 1, 1, 1, 1, 2, 2][index % _childrenPerBlock];
//}

const int _childrenPerBlock = 1;
const int _rowsPerBlock = 1;

int _minIndexInRow(int rowIndex) {
  final int blockIndex = rowIndex ~/ _rowsPerBlock;
  return const <int>[0][rowIndex % _rowsPerBlock] +
      blockIndex * _childrenPerBlock;
}

int _maxIndexInRow(int rowIndex) {
  final int blockIndex = rowIndex ~/ _rowsPerBlock;
  return const <int>[0][rowIndex % _rowsPerBlock] +
      blockIndex * _childrenPerBlock;
}

int _rowAtIndex(int index) {
  final int blockCount = index ~/ _childrenPerBlock;
  return const <int>[0][index - blockCount * _childrenPerBlock] +
      blockCount * _rowsPerBlock;
}

int _columnAtIndex(int index) {
  return const <int>[0][index % _childrenPerBlock];
}

int _columnSpanAtIndex(int index) {
  return const <int>[1][index % _childrenPerBlock];
}

class ShrineHome extends StatefulWidget {
  @override
  _ShrineHomeState createState() => new _ShrineHomeState();
}

class _ShrineHomeState extends State<ShrineHome> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'Shrine Home');

  static final _ShrineGridDelegate gridDelegate = new _ShrineGridDelegate();

  @override
  Widget build(BuildContext context) {
    final Product featured = _products
        .firstWhere((Product product) => product.featureDescription != null);
    return new ShrinePage(
      scafflodKey: _scaffoldKey,
      products: _products,
      shoppingCart: _shoppingCart,
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverToBoxAdapter(
            child: new _Heading(product: featured),
          ),
          new SliverSafeArea(
            top: false,
            left: true,
            right: true,
            bottom: true,
            minimum: const EdgeInsets.all(16.0),
            sliver: new SliverGrid(
              gridDelegate: gridDelegate,
              delegate: new SliverChildListDelegate(
                _products.map((Product product) {
                  return new _ProductItem(
                    product: product,
                    onPressed: () {
                      _showOrderPage(product);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderPage(Product product) async {
    final Order order = _shoppingCart[product] ?? new Order(product: product);
    final Order completedOrder = await Navigator.push(
        context,
        new ShrineOrderRoute(
            order: order,
            builder: (BuildContext context) {
              return new OrderPage(
                order: order,
                products: _products,
                shoppingCart: _shoppingCart,
              );
            }));

    assert(completedOrder.product != null);
    if (completedOrder.quantity == 0) {
      _shoppingCart.remove(completedOrder.product);
    }
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onPressed;

  const _ProductItem({
    Key key,
    @required this.product,
    this.onPressed,
  })
      : assert(product != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MergeSemantics(
      child: new Card(
        child: new Stack(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Align(
                  alignment: Alignment.centerRight,
                  child: new _ProductPriceItem(
                    product: product,
                  ),
                ),
                new Container(
                  width: 144.0,
                  height: 144.0,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: new Hero(
                      tag: product.tag,
                      child: new Image.asset(
                        product.imageAsset,
                        fit: BoxFit.contain,
                      )),
                ),
                new Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: new _VendorItem(vendor: product.vendor),
                ),
              ],
            ),
            new Material(
              type: MaterialType.transparency,
              child: new InkWell(
                onTap: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductPriceItem extends _PriceItem {
  const _ProductPriceItem({Key key, Product product})
      : super(key: key, product: product);

  @override
  Widget build(BuildContext context) {
    return buildItem(
      context,
      ShrineTheme.of(context).priceStyle,
      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    );
  }
}

abstract class _PriceItem extends StatelessWidget {
  final Product product;

  const _PriceItem({Key key, @required this.product})
      : assert(product != null),
        super(key: key);

  Widget buildItem(BuildContext context, TextStyle style, EdgeInsets padding) {
    BoxDecoration decoration;
    if (_shoppingCart[product] != null) {
      decoration =
          new BoxDecoration(color: ShrineTheme.of(context).priceHighlightColor);
    }
    return new Container(
      padding: padding,
      decoration: decoration,
      child: new Text(product.priceString, style: style),
    );
  }
}

class _ShrineGridDelegate extends SliverGridDelegate {
  static const double _kSpacing = 8.0;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
//    final double tileWidth = (constraints.crossAxisExtent - _kSpacing) / 2.0;
    final double tileWidth = (constraints.crossAxisExtent - _kSpacing);
    final double tileHeight = 40.0 + 144.0 + 40.0;
    // TODO: implement getLayout
    return new _ShrineGridLayout(
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      rowStride: tileHeight + _kSpacing,
      columnStride: tileWidth + _kSpacing,
    );
  }

  @override
  bool shouldRelayout(covariant SliverGridDelegate oldDelegate) {
    return false;
  }
}

class _ShrineGridLayout extends SliverGridLayout {
  final double rowStride;
  final double columnStride;
  final double tileHeight;
  final double tileWidth;

  const _ShrineGridLayout({
    @required this.rowStride,
    @required this.columnStride,
    @required this.tileHeight,
    @required this.tileWidth,
  });

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    return _maxIndexInRow(scrollOffset ~/ rowStride);
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    return _minIndexInRow(scrollOffset ~/ rowStride);
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final int row = _rowAtIndex(index);
    final int column = _columnAtIndex(index);
    final int columnSpan = _columnSpanAtIndex(index);
    return new SliverGridGeometry(
      scrollOffset: row * rowStride,
      crossAxisOffset: column * columnStride,
      mainAxisExtent: tileHeight,
      crossAxisExtent: tileWidth + (columnSpan - 1) * columnStride,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    if (childCount == 0) return 0.0;
    final int rowCount = _rowAtIndex(childCount - 1) + 1;
    final double rowSpacing = rowStride - tileHeight;
    return rowStride * rowCount - rowSpacing;
  }
}

class _Heading extends StatelessWidget {
  final Product product;

  _Heading({Key key, @required this.product})
      : assert(product != null),
        assert(product.featureTitle != null),
        assert(product.featureDescription != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final ShrineTheme theme = ShrineTheme.of(context);
    return new MergeSemantics(
      child: new SizedBox(
        height: screenSize.width > screenSize.height
            ? (screenSize.height - kToolbarHeight) * 0.85
            : (screenSize.height - kToolbarHeight) * 0.70,
        child: new Container(
          decoration: new BoxDecoration(
            color: theme.cardBackgroundColor,
            border:
                new Border(bottom: new BorderSide(color: theme.dividerColor)),
          ),
          child: new CustomMultiChildLayout(
            delegate: new _HeadingLayout(),
            children: <Widget>[
              new LayoutId(
                  id: _HeadingLayout.image,
                  child:
                      new Image.asset(product.imageAsset, fit: BoxFit.cover)),
              new LayoutId(
                  id: _HeadingLayout.price,
                  child: new _FeaturePriceItem(product: product)),
              new LayoutId(
                  id: _HeadingLayout.title,
                  child: new Text(
                    product.featureTitle,
                    style: theme.featureTitleStyle,
                  )),
              new LayoutId(
                  id: _HeadingLayout.description,
                  child: new Text(product.featureDescription,
                      style: theme.featureStyle)),
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
    return new SizedBox(
      height: 24.0,
      child: new Row(
        children: <Widget>[
          new SizedBox(
            width: 24.0,
            child: new ClipRRect(
              borderRadius: new BorderRadius.circular(12.0),
              child: new Image.asset(vendor.avatarAsset, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 8.0),
          new Expanded(
              child: new Text(vendor.name,
                  style: ShrineTheme.of(context).vendorItemStyle)),
        ],
      ),
    );
  }
}

class _FeaturePriceItem extends _PriceItem {
  const _FeaturePriceItem({Key key, Product product})
      : super(key: key, product: product);

  @override
  Widget build(BuildContext context) {
    return buildItem(context, ShrineTheme.of(context).featurePriceStyle,
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0));
  }
}

class _HeadingLayout extends MultiChildLayoutDelegate {
  _HeadingLayout();

  static const String price = 'price';
  static const String image = 'image';
  static const String title = 'title';
  static const String description = 'description';
  static const String vendor = 'vendor';

  @override
  void performLayout(Size size) {
    // image item
    final double halfWidth = size.width / 2.0;
    final double halfHeight = size.height / 2.0;
    final double halfUnit = unitSize / 2.0;
    final double margin = 16.0;

    final Size imageSize = layoutChild(image, new BoxConstraints.loose(size));
    final double imageX = imageSize.width < halfWidth - halfUnit
        ? halfWidth / 2.0 - imageSize.width / 2.0 - halfUnit
        : halfWidth - imageSize.width;
    positionChild(
        image, new Offset(imageX, halfHeight - imageSize.height / 2.0));

    //price item
    final Size priceSize = layoutChild(price, new BoxConstraints.loose(size));
    positionChild(price, new Offset(size.width - priceSize.width, 0.0));

    //title item
    final double maxTitleWidth = halfWidth + unitSize - margin;
    final BoxConstraints titleBoxConstraints =
        new BoxConstraints(maxWidth: maxTitleWidth);
    final Size titleSize = layoutChild(title, titleBoxConstraints);
    final double titleX = halfWidth - unitSize;
    final double titleY = halfHeight - titleSize.height;
    positionChild(title, new Offset(titleX, titleY));

    //description item
    final Size descriptionSize = layoutChild(description, titleBoxConstraints);
    final double descriptionY = titleY + titleSize.height + margin;
    positionChild(description, new Offset(titleX, descriptionY));

    //vendor item
    layoutChild(vendor, titleBoxConstraints);
    final double vendorY = descriptionY + descriptionSize.height + margin;
    positionChild(vendor, new Offset(titleX, vendorY));
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    // TODO: implement shouldRelayout
    return false;
  }
}

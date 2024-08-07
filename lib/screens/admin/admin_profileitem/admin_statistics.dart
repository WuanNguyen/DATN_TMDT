import 'package:doan_tmdt/model/classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminStatisticsScreen extends StatefulWidget {
  const AdminStatisticsScreen({super.key});

  @override
  _AdminStatisticsScreenState createState() => _AdminStatisticsScreenState();
}

class _AdminStatisticsScreenState extends State<AdminStatisticsScreen> {
  bool isLoading = true;
  Map<String, dynamic> stats = {};

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    try {
      Map<String, dynamic> statistics = await calculateStatistics();
      if (mounted) {
        // Kiểm tra widget đã mount
        setState(() {
          stats = statistics;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching statistics: $e');
      if (mounted) {
        // Kiểm tra widget đã mount
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    for (int month = 1; month <= 12; month++) {
      // MonthlyRevenue[month].clearValue(); // don dep value
      // MonthlySold[month].clearValue();
      MonthlyRevenue[month - 1].setSale(double.parse(stats['monthlyRevenue']
                  ?[month.toString().padLeft(2, '0')]
              ?.toStringAsFixed(2) ??
          '0.00'));
      MonthlySold[month - 1].setSale(double.parse(stats['monthlySold']
                  ?[month.toString().padLeft(2, '0')]
              ?.toStringAsFixed(2) ??
          '0.00'));
    }
    ;
    print(double.parse(stats['monthlySold']?[2.toString().padLeft(2, '0')]
            ?.toStringAsFixed(2) ??
        '0.00'));
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          title: const Text('Admin Statistics'),
          backgroundColor: Color.fromRGBO(201, 241, 248, 1),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.8, 1],
                colors: <Color>[
                  Color.fromRGBO(201, 241, 248, 1),
                  Color.fromRGBO(231, 230, 233, 1),
                  Color.fromRGBO(231, 227, 230, 1),
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    isLoading
                        ? Center(
                            heightFactor: 13,
                            child: Container(
                              width: 50,
                              height: 50,
                              child: const CircularProgressIndicator(),
                            ))
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    title: ChartTitle(text: 'Revenue'),
                                    legend: Legend(isVisible: true),
                                    tooltipBehavior:
                                        TooltipBehavior(enable: true),
                                    series: <ChartSeries<SalesData, String>>[
                                      ColumnSeries<SalesData, String>(
                                        dataSource: MonthlyRevenue,
                                        xValueMapper: (SalesData sales, _) =>
                                            sales.month,
                                        yValueMapper: (SalesData sales, _) =>
                                            sales.sales,
                                        name: 'Monthly \nRevenue',
                                        color: Colors.blue,
                                        dataLabelSettings:
                                            DataLabelSettings(isVisible: false),
                                      ),
                                    ],
                                  ),
                                  SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    title: ChartTitle(text: 'Sold'),
                                    legend: Legend(isVisible: true),
                                    tooltipBehavior:
                                        TooltipBehavior(enable: true),
                                    series: <ChartSeries<SalesData, String>>[
                                      ColumnSeries<SalesData, String>(
                                        dataSource: MonthlySold,
                                        xValueMapper: (SalesData sales, _) =>
                                            sales.month,
                                        yValueMapper: (SalesData sales, _) =>
                                            sales.sales,
                                        name: 'Monthly \nSold',
                                        color: Colors.blue,
                                        dataLabelSettings:
                                            DataLabelSettings(isVisible: false),
                                      ),
                                    ],
                                  ),
                                  SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    series: <ChartSeries>[
                                      LineSeries<SalesData, String>(
                                        dataSource: <SalesData>[
                                          SalesData('Jan', 35),
                                          SalesData('Feb', 28),
                                          SalesData('Mar', 34),
                                          SalesData('Apr', 32),
                                          SalesData('May', 40),
                                          SalesData('Jun', 38),
                                        ],
                                        xValueMapper: (SalesData sales, _) =>
                                            sales.month,
                                        yValueMapper: (SalesData sales, _) =>
                                            sales.sales,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ))
                  ],
                ))));
  }
}

//------------------------------------------------------
List<SalesData> MonthlyRevenue =
    List.generate(12, (index) => SalesData('T${index + 1}', 0));
List<SalesData> MonthlySold =
    List.generate(12, (index) => SalesData('T${index + 1}', 0));
//------------------------------------------------------

class SalesData {
  final String month;
  double sales;

  SalesData(this.month, this.sales);

  void addSale(double value) {
    sales += value;
  }

  void setSale(double value) {
    sales = value;
  }

  void clearValue() {
    sales = 0;
  }
}

//-------------------------------------------------------------------------------------
Future<Map<String, dynamic>> calculateStatistics() async {
  // Lấy danh sách sản phẩm
  List<Product> products = await fetchProducts();

  // Khởi tạo thống kê
  int totalProducts = products.length;
  double totalRevenue = 0;
  int totalStock = 0;
  Map<String, int> totalSold = {}; // Để lưu số lượng đã bán cho mỗi sản phẩm
  int totalSoldDamua =
      0; // Tổng số lượng sản phẩm đã bán với trạng thái 'damua'
  int totalSoldDahuy =
      0; // Tổng số lượng sản phẩm đã bán với trạng thái 'dahuy'

  // Tính doanh thu từ sản phẩm và số lượng tồn kho
  for (Product product in products) {
    ProductSize productSize = await fetchProductSize(product.ID_Product);

    // Tính tổng số lượng tồn kho
    if (productSize.S != null) {
      totalStock += productSize.S.Stock;
    }
    if (productSize.M != null) {
      totalStock += productSize.M.Stock;
    }
    if (productSize.L != null) {
      totalStock += productSize.L.Stock;
    }

    // Khởi tạo số lượng bán cho sản phẩm nếu chưa có
    totalSold[product.ID_Product] = 0;
  }

  // Tính doanh thu và số lượng đã bán từ các đơn hàng
  totalRevenue = await calculateOrderRevenue(totalSold);

  // Cập nhật tổng số lượng đã bán theo trạng thái đơn hàng
  totalSoldDamua = await calculateTotalSoldByStatus('dagiao');
  totalSoldDahuy = await calculateTotalSoldByStatus('dahuy');

  // Tính doanh thu và số lượng sản phẩm theo từng tháng
  Map<String, double> monthlyRevenue = await calculateMonthlyRevenue();
  Map<String, int> monthlySold = await calculateMonthlySold();

  return {
    'totalProducts': totalProducts,
    'totalRevenue': totalRevenue,
    'totalStock': totalStock,
    'totalSold': totalSold,
    'totalSoldDamua': totalSoldDamua,
    'totalSoldDahuy': totalSoldDahuy,
    'monthlyRevenue': monthlyRevenue,
    'monthlySold': monthlySold,
  };
}

Future<Map<String, double>> calculateMonthlyRevenue() async {
  Map<String, double> monthlyRevenue = _initializeMonthlyRevenueData();

  // Lấy danh sách đơn hàng
  List<Order> orders = await fetchOrders();

  for (Order order in orders) {
    String month = extractMonth(order.Order_Date);
    List<OrderDetail> orderDetails = await fetchOrderDetails(order.ID_Order);

    for (OrderDetail detail in orderDetails) {
      if (detail.price == null || detail.quantity == null) {
        continue;
      }

      monthlyRevenue[month] = (monthlyRevenue[month] ?? 0) +
          (detail.price ?? 0) * (detail.quantity ?? 0);
    }
  }

  return monthlyRevenue;
}

Future<Map<String, int>> calculateMonthlySold() async {
  Map<String, int> monthlySold = _initializeMonthlySoldData();

  // Lấy danh sách đơn hàng
  List<Order> orders = await fetchOrders();

  for (Order order in orders) {
    String month = extractMonth(order.Order_Date);
    List<OrderDetail> orderDetails = await fetchOrderDetails(order.ID_Order);

    for (OrderDetail detail in orderDetails) {
      if (detail.quantity == null) {
        continue;
      }

      monthlySold[month] = (monthlySold[month] ?? 0) + (detail.quantity ?? 0);
    }
  }

  return monthlySold;
}

Map<String, double> _initializeMonthlyRevenueData() {
  Map<String, double> monthlyData = {};
  for (int month = 1; month <= 12; month++) {
    String monthStr =
        month.toString().padLeft(2, '0'); // Đảm bảo định dạng '01', '02', ...
    monthlyData[monthStr] = 0.0; // Khởi tạo với giá trị mặc định là 0.0
  }
  return monthlyData;
}

Map<String, int> _initializeMonthlySoldData() {
  Map<String, int> monthlyData = {};
  for (int month = 1; month <= 12; month++) {
    String monthStr =
        month.toString().padLeft(2, '0'); // Đảm bảo định dạng '01', '02', ...
    monthlyData[monthStr] = 0; // Khởi tạo với giá trị mặc định là 0
  }
  return monthlyData;
}

String extractMonth(String date) {
  // Giả sử định dạng ngày tháng là 'dd/MM/yyyy'
  // Cắt chuỗi để lấy tháng
  return date.split('/').sublist(1, 2).join('/');
}

Future<int> calculateTotalSoldByStatus(String status) async {
  int totalSold = 0;

  // Lấy danh sách đơn hàng theo trạng thái
  List<Order> orders = await fetchOrdersByStatus(status);

  for (Order order in orders) {
    // Lấy chi tiết đơn hàng
    List<OrderDetail> orderDetails = await fetchOrderDetails(order.ID_Order);

    // Tính tổng số lượng sản phẩm
    for (OrderDetail detail in orderDetails) {
      totalSold += detail.quantity ?? 0;
    }
  }

  return totalSold;
}

Future<List<Order>> fetchOrdersByStatus(String status) async {
  DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('Order');
  DataSnapshot ordersSnapshot =
      await ordersRef.orderByChild('Order_Status').equalTo(status).get();

  List<Order> orders = [];
  for (var child in ordersSnapshot.children) {
    orders.add(Order.fromSnapshot(child));
  }
  return orders;
}

Future<double> calculateOrderRevenue(Map<String, int> totalSold) async {
  double totalRevenue = 0;

  // Lấy danh sách đơn hàng
  List<Order> orders = await fetchOrders();

  for (Order order in orders) {
    // Lấy chi tiết đơn hàng
    List<OrderDetail> orderDetails = await fetchOrderDetails(order.ID_Order);

    // Tính doanh thu từ chi tiết đơn hàng
    for (OrderDetail detail in orderDetails) {
      totalRevenue += (detail.price ?? 0) * (detail.quantity ?? 0);

      // Cập nhật số lượng bán của sản phẩm
      if (totalSold.containsKey(detail.idProduct)) {
        totalSold[detail.idProduct] =
            (totalSold[detail.idProduct] ?? 0) + (detail.quantity ?? 0);
      }
    }
  }

  return totalRevenue;
}

Future<List<Product>> fetchProducts() async {
  DatabaseReference productsRef =
      FirebaseDatabase.instance.ref().child('Products');
  DataSnapshot productsSnapshot = await productsRef.get();

  List<Product> products = [];
  for (var child in productsSnapshot.children) {
    products.add(Product.fromSnapshot(child));
  }
  return products;
}

Future<ProductSize> fetchProductSize(String productId) async {
  DatabaseReference productSizeRef =
      FirebaseDatabase.instance.ref().child('ProductSizes').child(productId);

  DataSnapshot productSizeSnapshot = await productSizeRef.get();
  return ProductSize.fromSnapshot(productSizeSnapshot);
}

Future<List<Order>> fetchOrders() async {
  DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('Order');
  DataSnapshot ordersSnapshot = await ordersRef.get();

  List<Order> orders = [];
  for (var child in ordersSnapshot.children) {
    orders.add(Order.fromSnapshot(child));
  }
  return orders;
}

Future<List<OrderDetail>> fetchOrderDetails(String orderId) async {
  DatabaseReference orderDetailsRef =
      FirebaseDatabase.instance.ref().child('OrderDetail').child(orderId);
  DataSnapshot orderDetailsSnapshot = await orderDetailsRef.get();

  List<OrderDetail> orderDetails = [];
  for (var child in orderDetailsSnapshot.children) {
    orderDetails.add(OrderDetail.fromSnapshot(child));
  }
  return orderDetails;
}

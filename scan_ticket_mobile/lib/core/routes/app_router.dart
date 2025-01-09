import 'package:flutter/material.dart';
import '../../features/receipt_scan/screens/home_screen.dart';
import '../../features/receipt_scan/screens/scan_screen.dart';
import '../../features/receipt_scan/screens/receipt_detail_screen.dart';
import '../../features/receipt_scan/screens/receipt_edit_screen.dart';
import '../../features/receipt_scan/screens/search_screen.dart';
import '../../features/receipt_scan/screens/statistics_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String scan = '/scan';
  static const String receiptDetail = '/receipt/detail';
  static const String receiptEdit = '/receipt/edit';
  static const String search = '/search';
  static const String statistics = '/statistics';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case scan:
        return MaterialPageRoute(
          builder: (_) => const ScanScreen(),
        );
      case receiptDetail:
        final String receiptId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ReceiptDetailScreen(receiptId: receiptId),
        );
      case receiptEdit:
        final String receiptId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ReceiptEditScreen(receiptId: receiptId),
        );
      case search:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
        );
      case statistics:
        return MaterialPageRoute(
          builder: (_) => const StatisticsScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

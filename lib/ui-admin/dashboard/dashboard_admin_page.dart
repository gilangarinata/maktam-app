import 'package:flutter/material.dart';
import 'package:maktampos/ui-admin/selling/selling_admin_page.dart';
import 'package:maktampos/ui/material/material_page.dart';
import 'package:maktampos/ui/profile_page.dart';
import 'package:maktampos/ui/stock/stock_page.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({Key? key}) : super(key: key);

  @override
  _DashboardAdminPageState createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: IndexedStack(
        children: <Widget>[
          SellingAdminPage(),
          StockPage(),
          MaterialDataPage(),
          ProfilePage(),
        ],
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        onTap: (value) {
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Penjualan',
            icon: Icon(Icons.sell),
          ),
          BottomNavigationBarItem(
            label: 'Stok',
            icon: Icon(Icons.all_inbox_sharp),
          ),
          BottomNavigationBarItem(
            label: 'Material',
            icon: Icon(Icons.view_in_ar),
          ),
          BottomNavigationBarItem(
            label: 'Profil',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}

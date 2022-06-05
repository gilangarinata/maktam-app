import 'package:flutter/material.dart';
import 'package:maktampos/ui-admin/components/side_menu.dart';
import 'package:maktampos/ui-admin/screens/dashboard/dashboard_screen.dart';
import 'package:maktampos/ui-admin/screens/email/email_screen.dart';

import '../../responsive.dart';


class AdminMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        // Let's work on our mobile part
        mobile: const DashboardScreen(),
        tablet: Row(
          children: const [
            Expanded(
              flex: 6,
              child: DashboardScreen(),
            ),
            Expanded(
              flex: 9,
              child: EmailScreen(),
            ),
          ],
        ),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 2 : 4,
              child: const SideMenu(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 3 : 5,
              child: const DashboardScreen(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 8 : 10,
              child: const EmailScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
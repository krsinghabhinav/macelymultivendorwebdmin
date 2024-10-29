import 'package:flutter/material.dart';

import 'widget/vendor_widget_with_model.dart';

class VendorScreen extends StatefulWidget {
  static const String routeName = '\VendorScreen';
  const VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  Widget _rowHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.all(2),
        height: 30,
        decoration: BoxDecoration(
          color: Colors.yellow.shade900,
          border: Border.all(color: Colors.grey.shade700),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: const Text(
              'Manage Vendor',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _rowHeader('LOGO', 1),
                _rowHeader('BUSSINESS NAME', 3),
                _rowHeader('CITY', 2),
                _rowHeader('STATE', 2),
                _rowHeader('ACTION', 1),
                _rowHeader('VIEW MORE', 1),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: VendorWidgets(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  static const String routeName = '\OrderScreen';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Widget _rowHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: Colors.yellow.shade900,
          border: Border.all(color: Colors.grey.shade700),
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        )),
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
              'Manage Order',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _rowHeader('IMAGE', 2),
                _rowHeader('FULL NAME', 3),
                _rowHeader('CITY', 2),
                _rowHeader('STATE', 2),
                _rowHeader('ACTION', 1),
                _rowHeader('VIEW MORE', 1),
              ],
            ),
          )
        ],
      ),
    );
  }
}

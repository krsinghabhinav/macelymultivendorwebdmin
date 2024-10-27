import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  static const String routeName = '\ProducScreen';
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Product',
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
                _rowHeader('NAME', 3),
                _rowHeader('PRICE', 2),
                _rowHeader('QUANTITY', 2),
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

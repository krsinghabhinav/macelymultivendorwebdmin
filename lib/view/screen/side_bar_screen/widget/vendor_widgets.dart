import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../models/vendorModel.dart';

class VendorWidgets extends StatefulWidget {
  @override
  State<VendorWidgets> createState() => _VendorWidgetsState();
}

class _VendorWidgetsState extends State<VendorWidgets> {
  final Stream<QuerySnapshot> _vendorStream =
      FirebaseFirestore.instance.collection('vendors').snapshots();

  Widget vendorData(int flex, Widget child) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _vendorStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.cyan,
          ));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No vendors found'));
        }

        List<VendorUserModel> vendors = snapshot.data!.docs
            .map((doc) =>
                VendorUserModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: vendors.length,
          itemBuilder: (context, index) {
            final vendor = vendors[index];
            return Row(
              children: [
                vendorData(
                  1,
                  Container(
                    height: 50,
                    width: 90,
                    child: vendor.image != null
                        ? Image.network(
                            vendor.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                          )
                        : Icon(Icons.image, size: 50),
                  ),
                ),
                vendorData(
                  3,
                  Text(vendor.bussinessName ?? 'No Name',
                      style: TextStyle(fontSize: 16)),
                ),
                vendorData(
                  2,
                  Text(vendor.cityValue ?? 'No City',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ),
                vendorData(
                  2,
                  Text(vendor.stateValue ?? 'No State',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ),
                vendorData(
                  1,
                  InkWell(
                    onTap: () {
                      // Add your reject logic here
                    },
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: Text(
                        'Reject',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )),
                    ),
                  ),
                ),
                vendorData(
                  1,
                  InkWell(
                    onTap: () {
                      // Add your view more logic here
                    },
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: Text(
                        'View More',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

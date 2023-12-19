import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market_app/constants/styles/text_widget.dart';
import 'package:market_app/features/app/widgets/payment.dart';
import 'package:market_app/firebase_helper/firestore/home_data.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  Stream? itemsStream;
  double total = 0;

  void startTimer() {
    Timer(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  onTheLoad() async {
    itemsStream = await HomeDataFirestore().getCartItems(user);
    setState(() {});
  }

  @override
  void initState() {
    onTheLoad();
    startTimer();
    super.initState();
  }

  Widget productsCart() {
    return SizedBox(
      //height: 280,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: itemsStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    total += (ds["total"] as num).toDouble();
                    // print(total);
                    return SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 10, bottom: 10),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10.0),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Container(
                                //   // margin: EdgeInsets.only(left: 20, right: 10, top: 25),
                                //   height: 70,
                                //   width: 30,
                                //   decoration: BoxDecoration(
                                //     border: Border.all(),
                                //     borderRadius: BorderRadius.circular(10),
                                //   ),
                                //   child: Center(
                                //       child: Text(ds["quantity"].toString())),
                                // ),
                                //const SizedBox(width: 20),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.network(
                                    ds["image"],
                                    height: 73,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  children: [
                                    Text(
                                      ds["name"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.currency_rupee),
                                        Text(
                                          ds["total"].toString(),
                                          style: AppWidget
                                              .semiBoldTextFieldStyle(),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(child: Text("Empty cart"));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              //elevation: 2.0,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: const Center(
                  child: Text(
                    "Your Cart",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: productsCart(),
            ),
            const Spacer(),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Price',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  const Icon(Icons.currency_rupee),
                  Text(
                    total.toString(),
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => PaymentScreen(
                          amount: total,
                          title: 'Cart',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "CheckOut",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

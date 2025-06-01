import 'package:flutter/material.dart';
import 'package:tubes_5_c_travel/common/models/User.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/widgets/app_bar.dart';

class DetailCustomer extends StatelessWidget {
  final User customer;

  const DetailCustomer({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Customer",
            showLeadingIcon: true,
            onLeadingIconPressed: () {
              Navigator.pop(context);
            },
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: customer.imageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            customer.imageUrl!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Icon(
                            Icons.person,
                            size: 60,
                          ),
                        ),
                ),
                const SizedBox(height: 20),

                // ID
                // _buildDetailField(context, "ID", customer.id),
                // const SizedBox(height: 16),

                _buildDetailField(context, "Username", customer.username!),
                const SizedBox(height: 16),
                _buildDetailField(
                    context, "Nomor Telepon", customer.nomorTelp!),
                const SizedBox(height: 16),
                _buildDetailField(context, "Email", customer.email!),
                const SizedBox(height: 16),
                _buildDetailField(context, "Password", customer.password!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField(BuildContext context, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(131, 180, 255, 1)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

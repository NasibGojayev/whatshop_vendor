import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:whatshop_vendor/bloc_management/vendor_bloc/vendor_bloc.dart';
import 'package:whatshop_vendor/tools/colors.dart';
import '../bloc_management/vendor_bloc/vendor_state.dart';


class VendorDashboardScreen extends StatelessWidget {
  const VendorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Vendor Paneli'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Open settings
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<VendorBloc,VendorState>(
          builder: (context,state) {
            if(state is VendorLoaded){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Section - Greeting and Summary
                  _buildHeaderSection(vendor : state.vendor),
                  SizedBox(height: 24),

                  // Main Action Buttons
                  _buildActionButtons(context),
                  SizedBox(height: 24),

                  // Recent Activity
                  _buildRecentActivitySection(products: state.preProducts),

                ],
              );
            }
            if(state is VendorLoading){
              return Center(child: CircularProgressIndicator());
            }
            else{
              return Center(child: Text('Vendor məlumatı alınmadı.$state'));
            }
          }
        ),
      ),
    );
  }

  Widget _buildHeaderSection({required Vendor vendor}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👋 Salam, ${vendor.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(Icon(Icons.inventory,color: mainBlue,size: 24,), 'Toplam: ${vendor.products.length}', 'məhsul'),
                _buildStatItem(Icon(Icons.inventory,color: CupertinoColors.activeGreen,size: 24,), 'Aktiv: ${vendor.activeProducts.length}', 'məhsul'),
                _buildStatItem(Icon(Icons.inventory,color: CupertinoColors.destructiveRed,size: 24,), 'Deaktiv: ${vendor.products.length - vendor.activeProducts.length}', 'məhsul'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(Widget icon, String value, String label) {
    return Column(
      children: [
        icon,
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(

            icon: Icon(Icons.add, size: 24),
            label: Text('Yeni Məhsul Əlavə Et', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: mainBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              context.push('/add_product_flow');
            },
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  icon: Icon(Icons.list_alt, size: 24),
                  label: Text('Məhsullarım', style: TextStyle(fontSize: 16)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: mainBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    context.push('/all_products');
                  },
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  icon: Icon(Icons.analytics, size: 24),
                  label: Text('Statistika', style: TextStyle(fontSize: 16)),
                  style: OutlinedButton.styleFrom(

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: null, // Disabled for now
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection({required List<PreProduct> products}) {


    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🕒 Son 5 məhsul',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  child: Text('Hamısına bax'),
                  onPressed: () {
                    // Navigate to all products
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Column(
              children:
                  products.map(
                    (product) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.shopping_bag, color: Colors.grey),
                  ),
                  title: Text(product.name),
                  trailing:
                  product.isActive
                      ? Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                      : Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }


}

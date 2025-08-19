import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items; // ✅ make non-nullable
  final String date;
  final String address;

  const OrderDetailsScreen({
    super.key,
    required this.items,
    required this.date,
    required this.address,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  // Example delivery location (New York)
  static const LatLng deliveryLocation = LatLng(40.7128, -74.0060);

  @override
  Widget build(BuildContext context) {
    final parsedDate = DateTime.tryParse(widget.date) ?? DateTime.now();
    final deliveryTime = DateFormat('hh:mm a, MMM d, yyyy').format(parsedDate);

    final items = widget.items; // ✅ guaranteed not null

    final subtotal = items.fold<double>(
      0,
          (sum, item) =>
      sum + ((item['price'] ?? 0) * (item['quantity'] ?? 1)),
    );

    const shipFee = 1.3;
    final total = subtotal + shipFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Information'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${widget.date.hashCode}'),
              const SizedBox(height: 16),

              const Text('Delivery to',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.address),
              const SizedBox(height: 16),

              // Google Map
              SizedBox(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: deliveryLocation,
                    zoom: 14,
                  ),
                  markers: {
                    const Marker(
                      markerId: MarkerId('delivery'),
                      position: deliveryLocation,
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: false,
                  zoomControlsEnabled: false,
                ),
              ),

              const SizedBox(height: 16),
              Text('Delivery Time: $deliveryTime'),
              const SizedBox(height: 16),

              // ✅ Safe item rendering
              if (items.isNotEmpty)
                Column(
                  children: items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${item['productName'] ?? 'Unnamed'} x${item['quantity'] ?? 1}'),
                          Text(
                              '\$${(item['price'] ?? 0) * (item['quantity'] ?? 1)}'),
                        ],
                      ),
                    );
                  }).toList(),
                )
              else
                const Text('No items found'),

              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal'),
                  Text('\$$subtotal'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Ship Fee (2.4km)'),
                  Text('\$1.3'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$$total',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),

              const SizedBox(height: 16),
              const Text('Note: Please call when you come. Thank you!'),

              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {}, // Rating logic
                      child: const Text('Rating'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {}, // Re-order logic
                      child: const Text('Re-order'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

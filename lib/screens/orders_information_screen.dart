import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

Future<LatLng> getCoordinatesFromAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      return LatLng(locations.first.latitude, locations.first.longitude);
    } else {
      return const LatLng(33.6797, 73.0479); // fallback
    }
  } catch (e) {
    print("Error converting address: $e");
    return const LatLng(33.6797, 73.0479); // fallback
  }
}

class OrderDetailsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String date;
  final String address;
  final String orderId;
  final String shippingMethod;
  final double shippingCost;
  final String paymentMethod;

  const OrderDetailsScreen({
    super.key,
    required this.items,
    required this.date,
    required this.address,
    required this.orderId,
    required this.shippingMethod,
    required this.shippingCost,
    required this.paymentMethod,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? deliveryLocation;

  @override
  void initState() {
    super.initState();
    _loadCoordinates();
  }

  void _loadCoordinates() async {
    LatLng coords = await getCoordinatesFromAddress(widget.address);
    setState(() {
      deliveryLocation = coords;
    });
  }

  @override
  Widget build(BuildContext context) {
    final parsedDate = DateTime.tryParse(widget.date) ?? DateTime.now();
    final deliveryTime = DateFormat('hh:mm a, MMM d, yyyy').format(parsedDate);
    final items = widget.items;

    // ✅ Safe subtotal calculation
    final subtotal = items.fold<double>(
      0,
          (sum, item) =>
      sum + ((item['price']?.toDouble() ?? 0) * (item['quantity']?.toInt() ?? 1)),
    );

    // ✅ Total includes shipping cost safely
    final total = subtotal + (widget.shippingCost);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Information'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: deliveryLocation == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${widget.orderId}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            const Text(
              'Delivery to',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.address),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: deliveryLocation!,
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('delivery'),
                    position: deliveryLocation!,
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                zoomControlsEnabled: false,
                myLocationEnabled: false,
              ),
            ),
            const SizedBox(height: 16),
            Text('Delivery Time: $deliveryTime'),
            const SizedBox(height: 16),

            const Text(
              'Order Summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (items.isNotEmpty)
              Column(
                children: items.map((item) {
                  final itemTotal =
                      (item['price']?.toDouble() ?? 0) *
                          (item['quantity']?.toInt() ?? 1);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${item['name'] ?? 'Item'} x${item['quantity'] ?? 1}'),
                        Text('Rs. ${itemTotal.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green)),
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
                Text('Rs. ${subtotal.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Shipping'),
                Text(
                  "${widget.shippingMethod} - Rs. ${widget.shippingCost.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Method'),
                Text(
                  widget.paymentMethod,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  'Rs. ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Note: Please call when you come. Thank you!'),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {}, // Rating
                    child: const Text('Rating'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {}, // Re-order
                    child: const Text('Re-order'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

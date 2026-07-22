import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';

import '../../data/models/address_model.dart';

class ChooseLocationPage extends StatefulWidget {
  const ChooseLocationPage({super.key});

  @override
  State<ChooseLocationPage> createState() => _ChooseLocationPageState();
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  LatLng _currentPosition = const LatLng(30.0444, 31.2357); // Cairo (Default)
  Set<Marker> _markers = {};
  AddressModel? _selectedAddress;

  bool _isLoading = false;
  bool _isAddressLoading = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    setState(() => _isLoading = true);

    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted && await Geolocator.isLocationServiceEnabled()) {
      try {
        final pos = await Geolocator.getCurrentPosition();
        final latLng = LatLng(pos.latitude, pos.longitude);
        _updateLocation(latLng);
      } catch (_) {}
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _searchLocation(String text) async {
    FocusScope.of(context).unfocus();
    if (text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final locations = await locationFromAddress(text);
      if (locations.isNotEmpty) {
        final latLng = LatLng(locations[0].latitude, locations[0].longitude);
        _updateLocation(latLng);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No results found")));
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _updateLocation(LatLng pos) async {
    setState(() {
      _currentPosition = pos;
      _markers = {Marker(markerId: const MarkerId('selected'), position: pos)};
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 15));
    _getAddressFromLatLng(pos);
  }

  Future<void> _getAddressFromLatLng(LatLng pos) async {
    setState(() => _isAddressLoading = true);
    try {
      final placeMarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      if (placeMarks.isNotEmpty) {
        final p = placeMarks.first;
        final street = [
          p.street,
          p.subLocality,
        ].where((s) => s != null && s.isNotEmpty).join(', ');

        if (mounted) {
          setState(() {
            _selectedAddress = AddressModel(
              latitude: pos.latitude,
              longitude: pos.longitude,
              address: street.isNotEmpty ? street : 'Selected Location',
              city: p.locality ?? p.administrativeArea ?? '',
            );
          });
        }
      }
    } catch (_) {}
    if (mounted) setState(() => _isAddressLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 14,
            ),
            markers: _markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onTap: _updateLocation,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: ColorManager.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        "Choose Location",
                        style: getSemiBoldStyle(
                          fontSize: 18.sp,
                          color: ColorManager.black,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(width: 40.w),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: const BoxDecoration(color: ColorManager.white),
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: _searchLocation,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: "Search area or street...",
                        border: InputBorder.none,
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.grey),
                          onPressed: () =>
                              _searchLocation(_searchController.text),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 220.h,
            right: 16.w,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: ColorManager.white,
              onPressed: _getUserLocation,
              child: const Icon(Icons.my_location, color: ColorManager.black),
            ),
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomPanel()),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 28.h),
      decoration: const BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isAddressLoading)
              const CircularProgressIndicator()
            else if (_selectedAddress != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.location_on,
                  color: ColorManager.black,
                  size: 30,
                ),
                title: Text(
                  _selectedAddress!.address,
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: 15.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(_selectedAddress!.city),
              )
            else
              const Text('Tap on the map to select location'),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.black,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onPressed: _selectedAddress != null && !_isAddressLoading
                    ? () => context.pop(_selectedAddress)
                    : null,
                child: Text(
                  "Confirm Location",
                  style: getBoldStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

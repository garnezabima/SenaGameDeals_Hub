import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';
import 'login_screen.dart';
import '../services/dashboard_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "User";
  
  // --- VARIABEL PENAMPUNG GAMBAR ---
  File? imageFile; 

  final DashboardService dashboardService = DashboardService();
  Map dashboardData = {};

  @override
  void initState() {
    super.initState();
    loadUser();
    loadDashboard();
    
    // --- LOAD FOTO SAAT HALAMAN DIBUKA ---
    loadProfileImage(); 
  }

  // --- FUNCTION LOAD GAMBAR DARI PENYIMPANAN LOKAL ---
  Future loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString("profile_image");

    if (imagePath != null) {
      setState(() {
        imageFile = File(imagePath);
      });
    }
  }

  Future loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
    });
  }

  Future loadDashboard() async {
    final data = await dashboardService.getDashboard();
    setState(() {
      dashboardData = data;
    });
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  // --- FUNCTION PILIH GAMBAR & SIMPAN PATH-NYA ---
  Future pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Simpan path ke memori
      await prefs.setString("profile_image", image.path);

      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  Widget statItem(String title, dynamic value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              
              // --- GANTI AVATAR PROFILE ---
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                  child: imageFile == null
                      ? const Icon(
                          Icons.person,
                          size: 50,
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 10),

              // --- TOMBOL GANTI FOTO ---
              TextButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.photo),
                label: const Text("Ganti Foto Profil"),
              ),

              const SizedBox(height: 10),

              Text(
                userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  statItem(
                    "Wishlist",
                    dashboardData['total_wishlist'] ?? 0,
                  ),
                  statItem(
                    "Review",
                    dashboardData['total_review'] ?? 0,
                  ),
                ],
              ),
              
              Row(
                children: [
                  statItem(
                    "Main",
                    dashboardData['sedang_main'] ?? 0,
                  ),
                  statItem(
                    "Tamat",
                    dashboardData['tamat'] ?? 0,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text("Dashboard Statistik"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DashboardScreen(
                        data: dashboardData,
                      ),
                    ),
                  );
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.info),
                title: const Text("Tentang Aplikasi"),
                subtitle: const Text("SenaGameDeals Hub v1.0"),
              ),

              const Divider(),

              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
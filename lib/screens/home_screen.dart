import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../services/cheapshark_service.dart';
import 'game_detail_screen.dart';
import 'wishlist_screen.dart';
import 'my_review_screen.dart';
import '../services/dashboard_service.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CheapSharkService service = CheapSharkService();
  final DashboardService dashboardService = DashboardService();

  
  List<GameModel> allGames = [];
  List<GameModel> filteredGames = [];
  List<GameModel> biggestDiscount = []; 
  List<GameModel> cheapestGames = []; 
  
  int page = 0;
  bool isLoading = false;
  bool hasMore = true;
  final ScrollController controller = ScrollController();

  
  String activeFilter = 'Semua';
  String currentKeyword = '';

  @override
  void initState() {
    super.initState();
    loadGames();

    controller.addListener(() {
      if (controller.position.pixels >= controller.position.maxScrollExtent - 200) {
        loadGames();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future loadGames() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final newGames = await service.getGames(page);

      setState(() {
        if (newGames.isEmpty) {
          hasMore = false;
        } else {
          allGames.addAll(newGames);
          page++;

          // Update List Diskon Terbesar
          biggestDiscount = List.from(allGames);
          biggestDiscount.sort((a, b) => double.parse(b.savings).compareTo(double.parse(a.savings)));
          biggestDiscount = biggestDiscount.take(10).toList();

          // Update List Game Termurah
          cheapestGames = List.from(allGames);
          cheapestGames.sort((a, b) => double.parse(a.salePrice).compareTo(double.parse(b.salePrice)));
          cheapestGames = cheapestGames.take(10).toList();

          _runFilterEngine();
        }
      });
    } catch (e) {
      print("Error loading games: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _runFilterEngine() {
    List<GameModel> temp = List.from(allGames);

    if (currentKeyword.isNotEmpty) {
      temp = temp.where((game) =>
          game.title.toLowerCase().contains(currentKeyword.toLowerCase())).toList();
    }

    if (activeFilter == '< \$5') {
      temp = temp.where((game) => double.parse(game.salePrice) <= 5.0).toList();
    } else if (activeFilter == '< \$10') {
      temp = temp.where((game) => double.parse(game.salePrice) <= 10.0).toList();
    } else if (activeFilter == '< \$20') {
      temp = temp.where((game) => double.parse(game.salePrice) <= 20.0).toList();
    } else if (activeFilter == '🏷️ Termurah') {
      temp.sort((a, b) => double.parse(a.salePrice).compareTo(double.parse(b.salePrice)));
      temp = temp.take(10).toList();
    } else if (activeFilter == '🔥 Diskon Terbesar') {
      temp.sort((a, b) => double.parse(b.savings).compareTo(double.parse(a.savings)));
      temp = temp.take(10).toList();
    }

    setState(() {
      filteredGames = temp;
    });
  }

  void searchGame(String keyword) {
    setState(() {
      currentKeyword = keyword;
      activeFilter = 'Semua';
      _runFilterEngine();
    });
  }

  void applyFilter(String filter) {
    setState(() {
      activeFilter = filter;
      _runFilterEngine();
    });
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: activeFilter == label,
        onSelected: (selected) {
          if (selected) {
            applyFilter(label);
          }
        },
      ),
    );
  }

  // --- HERO BANNER DESAIN STORE ---
  Widget buildHeroBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "🔥 Featured Deals",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Diskon hingga 95%\nuntuk game favoritmu",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    applyFilter('🔥 Diskon Terbesar');
                  },
                  child: const Text(
                    "Lihat Promo",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Transform.rotate(
            angle: -0.2,
            child: const Icon(
              Icons.sports_esports,
              size: 90,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBiggestDiscount() {
    if (biggestDiscount.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 5),
          child: Text(
            "🔥 Diskon Terbesar",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 240, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: biggestDiscount.length,
            itemBuilder: (context, index) {
              final game = biggestDiscount[index];

              return Container(
                width: 160, 
                margin: EdgeInsets.only(
                  left: index == 0 ? 16 : 12, 
                  right: index == biggestDiscount.length - 1 ? 16 : 0, 
                ),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => GameDetailScreen(game: game)),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          game.thumb,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                game.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${double.parse(game.savings).toStringAsFixed(0)}% OFF",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    "\$${game.salePrice}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildCheapestGames() {
    if (cheapestGames.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 5),
          child: Text(
            "💸 Game Termurah",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cheapestGames.length,
            itemBuilder: (context, index) {
              final game = cheapestGames[index];

              return Container(
                width: 160,
                margin: EdgeInsets.only(
                  left: index == 0 ? 16 : 12,
                  right: index == cheapestGames.length - 1 ? 16 : 0,
                ),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => GameDetailScreen(game: game)),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          game.thumb,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                game.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "\$${game.salePrice}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green, 
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Normal \$${game.normalPrice}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough, 
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Menaruh logo tepat di tengah tanpa teks pendamping
        centerTitle: true,
        title: Image.asset(
          "assets/images/sena.png", 
          width: 50,
        ),
        actions: [
          // Hanya menyisakan tombol Dashboard Statistik
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () async {
              final data = await dashboardService.getDashboard();
              if (!mounted) return;
              Navigator.push(context, MaterialPageRoute(builder: (_) => DashboardScreen(data: data)));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: controller, 
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Halo Gamer 👋",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Temukan game terbaik hari ini",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Cari game impianmu...",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.tune,
                                    ),
                                  ),
                                ),
                                onChanged: searchGame, 
                              ),
                            ),

                            buildHeroBanner(),
                            buildBiggestDiscount(),
                            buildCheapestGames(),

                            const SizedBox(height: 10),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Row(
                                children: [
                                  _buildFilterChip('Semua'),
                                  _buildFilterChip('< \$5'),
                                  _buildFilterChip('< \$10'),
                                  _buildFilterChip('< \$20'),
                                  _buildFilterChip('🏷️ Termurah'),
                                  _buildFilterChip('🔥 Diskon Terbesar'),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  activeFilter == 'Semua' 
                                    ? "🎮 Semua Game" 
                                    : (activeFilter.contains('🔥') || activeFilter.contains('🏷️') ? activeFilter : "🏷️ Di bawah $activeFilter"),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      filteredGames.isEmpty && isLoading
                          ? const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())))
                          : filteredGames.isEmpty
                              ? const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(20), child: Text("Game tidak ditemukan", style: TextStyle(fontSize: 16)))))
                              : SliverPadding(
                                  padding: const EdgeInsets.all(12),
                                  sliver: SliverGrid(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.65,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final game = filteredGames[index];
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => GameDetailScreen(game: game)));
                                          },
                                          child: Card(
                                            elevation: 6, 
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            clipBehavior: Clip.antiAlias,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Image.network(game.thumb, width: double.infinity, fit: BoxFit.cover),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(game.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                      const SizedBox(height: 6),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                                                        child: Text("${double.parse(game.savings).toStringAsFixed(0)}% OFF", style: const TextStyle(color: Colors.white, fontSize: 11)),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text("\$${game.salePrice}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      childCount: filteredGames.length,
                                    ),
                                  ),
                                ),
                                
                      if (isLoading && filteredGames.isNotEmpty)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
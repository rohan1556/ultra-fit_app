import 'package:flutter/material.dart';

void main() {
  runApp(const PulseFitApp());
}

class PulseFitApp extends StatelessWidget {
  const PulseFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PulseFit AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF070A12),
        primaryColor: const Color(0xFF00F2FE),
        cardColor: const Color(0xFF151C2C),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F2FE),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF151C2C),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // App State Metrics
  int steps = 7420;
  int heartRate = 72;
  int caloriesConsumed = 1240;
  int calorieGoal = 2200;
  int waterCurrent = 1750;
  int waterGoal = 2500;

  final List<Map<String, String>> meals = [
    {"name": "Oatmeal & Berries", "calories": "380 kcal", "time": "08:15 AM"},
    {"name": "Salmon Salad Bowl", "calories": "520 kcal", "time": "01:00 PM"},
  ];

  void _addWater(int amount) {
    setState(() {
      waterCurrent += amount;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Logged +${amount}ml Water!"),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  void _logMeal(String name, int cals) {
    setState(() {
      caloriesConsumed += cals;
      meals.insert(0, {
        "name": name,
        "calories": "$cals kcal",
        "time": "Just Now",
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Logged $name (+$cals kcal)!"),
        backgroundColor: Colors.emerald,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F19),
        title: Row(
          children: const [
            Icon(Icons.bolt, color: Color(0xFF00F2FE)),
            SizedBox(width: 8),
            Text(
              'PulseFit AI',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.cyan),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Watch Ultra Synced!')),
              );
            },
          )
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildOverviewTab(),
          _buildScannerTab(),
          _buildWaterTab(),
          _buildWorkoutsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0B0F19),
        selectedItemColor: const Color(0xFF00F2FE),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'AI Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Water'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workouts'),
        ],
      ),
    );
  }

  // --- TAB 1: OVERVIEW ---
  Widget _buildOverviewTab() {
    double calProgress = (caloriesConsumed / calorieGoal).clamp(0.0, 1.0);
    double waterProgress = (waterCurrent / waterGoal).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Live Watch Card
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Galaxy Watch Ultra", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Icon(Icons.watch, color: Colors.cyan),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _metricStat("Steps", "$steps", Icons.directions_walk, Colors.cyan),
                    _metricStat("Heart", "$heartRate BPM", Icons.favorite, Colors.redAccent),
                    _metricStat("Calories", "$caloriesConsumed", Icons.restaurant, Colors.emerald),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Calorie Goal Card
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Calorie Balance", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: calProgress,
                  color: Colors.emerald,
                  backgroundColor: Colors.grey[800],
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                Text("$caloriesConsumed / $calorieGoal kcal"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Water Card
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Hydration", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("$waterCurrent / $waterGoal ml", style: const TextStyle(color: Colors.cyan)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: waterProgress,
                  color: Colors.cyan,
                  backgroundColor: Colors.grey[800],
                  minHeight: 8,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _addWater(250),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan[800]),
                      child: const Text("+250ml"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _addWater(500),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan[800]),
                      child: const Text("+500ml"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- TAB 2: AI SCANNER ---
  Widget _buildScannerTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.emerald.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.camera_alt, size: 48, color: Colors.emerald),
                SizedBox(height: 8),
                Text("Scan Plate or Food Photo", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _logMeal("Grilled Chicken Bowl", 540),
            icon: const Icon(Icons.auto_awesome),
            label: const Text("Simulate AI Calorie Scan"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.emerald,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Today's Meals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: const Icon(Icons.fastfood, color: Colors.emerald),
                  title: Text(meals[i]["name"]!),
                  subtitle: Text(meals[i]["time"]!),
                  trailing: Text(meals[i]["calories"]!, style: const TextStyle(color: Colors.emerald, fontWeight: FontWeight.bold)),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // --- TAB 3: WATER ---
  Widget _buildWaterTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.water_drop, size: 80, color: Colors.cyan),
          const SizedBox(height: 16),
          Text("$waterCurrent / $waterGoal ml", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () => _addWater(250), child: const Text("+250 ml")),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: () => _addWater(500), child: const Text("+500 ml")),
            ],
          )
        ],
      ),
    );
  }

  // --- TAB 4: WORKOUTS ---
  Widget _buildWorkoutsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.directions_run, color: Colors.amber),
          title: Text("Outdoor Run"),
          subtitle: Text("25 mins • Galaxy Watch Ultra"),
          trailing: Text("280 kcal", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _metricStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

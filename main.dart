import 'package:flutter/material.dart';

void main() {
  runApp(LaserTherapyApp());
}

class LaserTherapyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laser Therapy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFF6F8FB),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _intensity = 50;
  int _frequency = 100;
  int _duration = 15;
  bool _isRunning = false;
  String _status = "Ready";

  final List<int> frequencies = [50, 100, 150];
  final List<int> durations = [5, 10, 15, 20];

  void _startTreatment() {
    setState(() {
      _isRunning = true;
      _status = "Running";
    });
  }

  void _pauseTreatment() {
    setState(() {
      _status = "Paused";
    });
  }

  void _stopTreatment() {
    setState(() {
      _isRunning = false;
      _status = "Stopped";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Laser Therapy", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            Text("Device ID: LT-2024-001", style: TextStyle(color: Colors.grey[600], fontSize: 14))
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.thermostat, color: Colors.green),
                SizedBox(width: 4),
                Text("37°C", style: TextStyle(color: Colors.black)),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Treatment Mode
            _buildModeCard(),
            SizedBox(height: 16),

            // Settings
            _buildSettingsCard(),
            SizedBox(height: 16),

            // Status
            _buildStatusCard(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info"),
        ],
      ),
    );
  }

  Widget _buildModeCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.grid_view, size: 64, color: Colors.blue),
            SizedBox(height: 8),
            Text("Laser Therapy", style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _startTreatment,
              child: Text("Start Treatment"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Treatment Settings", style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(Icons.settings)
              ],
            ),
            SizedBox(height: 16),

            Text("Laser Intensity"),
            Row(
              children: [
                IconButton(onPressed: () => setState(() => _intensity = (_intensity - 10).clamp(0, 100)), icon: Icon(Icons.remove_circle)),
                Expanded(
                  child: Slider(
                    value: _intensity.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 10,
                    onChanged: (value) => setState(() => _intensity = value.toInt()),
                  ),
                ),
                IconButton(onPressed: () => setState(() => _intensity = (_intensity + 10).clamp(0, 100)), icon: Icon(Icons.add_circle)),
              ],
            ),

            SizedBox(height: 8),
            Text("Frequency (Hz)"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: frequencies.map((f) => _buildChip(frequency: f)).toList(),
            ),

            SizedBox(height: 8),
            Text("Duration (Minutes)"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: durations.map((d) => _buildChip(duration: d)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({int? frequency, int? duration}) {
    final isSelected = (frequency != null && frequency == _frequency) ||
        (duration != null && duration == _duration);
    return ChoiceChip(
      label: Text((frequency ?? duration).toString()),
      selected: isSelected,
      onSelected: (_) => setState(() {
        if (frequency != null) _frequency = frequency;
        if (duration != null) _duration = duration;
      }),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Treatment Status", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(_status, style: TextStyle(color: Colors.green))
              ],
            ),
            SizedBox(height: 16),
            Center(child: Text("15:00", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _startTreatment,
                  icon: Icon(Icons.play_arrow),
                  label: Text("Start"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: _pauseTreatment,
                  icon: Icon(Icons.pause),
                  label: Text("Pause"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
                ElevatedButton.icon(
                  onPressed: _stopTreatment,
                  icon: Icon(Icons.stop),
                  label: Text("Stop"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(children: [Icon(Icons.thermostat, size: 16), Text(" Normal Temp")]),
                Row(children: [Icon(Icons.battery_charging_full, size: 16), Text(" Power OK")]),
                Row(children: [Icon(Icons.warning, size: 16), Text(" Standby")]),
              ],
            )
          ],
        ),
      ),
    );
  }
}

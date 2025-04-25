import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'bmi_calculator.dart';
import 'locale_notifier.dart';
import 'main.dart';

class BMIHistoryScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchBMIResults() async {
    User? user = _auth.currentUser;
    if (user == null) return [];

    try {
      final snapshot = await _firestore
          .collection('bmiResults')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching BMI results: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.bmiHistoryTitle,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[800]!, Colors.green[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, -3),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(-3, 0),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(3, 0),
              ),
            ],
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<Locale>(
            icon: Icon(Icons.translate, size: 26),
            onSelected: (Locale locale) {
              Provider.of<LocaleNotifier>(context, listen: false)
                  .setLocale(locale);
              context.findRootAncestorStateOfType<MyAppState>()?.refresh();
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: Locale('en'),
                child: Text('English', style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              PopupMenuItem(
                value: Locale('fr'),
                child: Text('Français', style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              PopupMenuItem(
                value: Locale('ar'),
                child: Text('العربية', style: TextStyle(fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchBMIResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(l10n.errorLoadingData));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(l10n.noResultsFound));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var data = snapshot.data![index];
              double bmi = (data['bmi'] is num) ? (data['bmi'] as num).toDouble() : 0.0;
              String resultKey = data['resultKey'] ?? '';
              String resultText = BMICalculator.getBMIResult(context, bmi);

              Timestamp? timestamp = data['timestamp'];
              String timeText = timestamp != null
                  ? timestamp.toDate().toString()
                  : l10n.unknownDate;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                child: ListTile(
                  title: Text("${l10n.bmi}: ${bmi.toStringAsFixed(2)}"),
                  subtitle: Text("${l10n.result}: $resultText"),
                  trailing: Text(
                    timeText,
                    style: TextStyle(fontSize: 12),
                  ),
                  tileColor: BMICalculator.getBMIColor(bmi).withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
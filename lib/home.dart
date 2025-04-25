import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'bmi_calculator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'bmi_history.dart';
import 'locale_notifier.dart';
import 'main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController controlWeight = TextEditingController();
  final TextEditingController controlHeight = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _info = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _info = AppLocalizations.of(context)!.reportData;
  }

  void _resetFields() {
    controlHeight.text = "";
    controlWeight.text = "";
    setState(() {
      _info = AppLocalizations.of(context)!.reportData;
    });
  }

  Future<void> _calculate() async {
    if (_formKey.currentState!.validate()) {
      double weight = double.parse(controlWeight.text);
      double height = double.parse(controlHeight.text) / 100;
      double bmi = BMICalculator.calculateBMI(weight, height);

      setState(() {
        _info = BMICalculator.getBMIResult(context, bmi);
      });

      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('bmiResults').add({
          'userId': user.uid,
          'bmi': bmi,
          'resultKey': BMICalculator.getBMIResultKey(bmi),
          'timestamp': DateTime.now(),
        });
      }
    }
  }

  void _signOut() async {
    try {
      await _auth.signOut();
      if (mounted) {
        context.pushReplacement('/sign-in');
      }
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushReplacement('/sign-in');
      });
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
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
          IconButton(
            icon: Icon(Icons.refresh, size: 26),
            onPressed: _resetFields,
          ),
          IconButton(
            icon: Icon(Icons.logout, size: 26),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, -3),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(-3, 0),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(3, 0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(Icons.speed, size: 120, color: Colors.green),
                ),
                SizedBox(height: 30),

                TextFormField(
                  controller: controlWeight,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.weightLabel,
                    prefixIcon: Icon(Icons.scale, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return l10n.insertWeightError;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                TextFormField(
                  controller: controlHeight,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.heightLabel,
                    prefixIcon: Icon(Icons.straighten, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return l10n.insertHeightError;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(l10n.calculateButton,
                      style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 20),

                Text(
                  _info,
                  style: TextStyle(
                    fontSize: 22,
                    color: _info == l10n.reportData
                        ? Colors.green
                        : BMICalculator.getBMIColor(
                      controlWeight.text.isEmpty || controlHeight.text.isEmpty
                          ? 0
                          : BMICalculator.calculateBMI(
                        double.parse(controlWeight.text),
                        double.parse(controlHeight.text) / 100,
                      ),
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: () => context.push('/history'),
                  icon: Icon(Icons.analytics),
                  label: Text(l10n.viewHistory),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../locale_notifier.dart';
import '../../main.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        context.go('/');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "An unknown error occurred";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.appTitle,
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
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(36.0),
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Grand icône d'utilisateur
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.green[100],
                      child: Icon(
                        Icons.person_outline,
                        size: 60,
                        color: Colors.green[800],
                      ),
                    ),
                  ),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  // Champ Email avec BoxShadow
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: localization.emailLabel,
                        labelStyle: TextStyle(color: Colors.green[700]),
                        prefixIcon: Icon(Icons.email, color: Colors.green),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                      value == null || value.isEmpty
                          ? localization.emailRequiredError
                          : null,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Champ Password avec BoxShadow
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: localization.passwordLabel,
                        labelStyle: TextStyle(color: Colors.green[700]),
                        prefixIcon: Icon(Icons.lock, color: Colors.green),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      obscureText: true,
                      validator: (value) =>
                      value == null || value.isEmpty
                          ? localization.passwordRequiredError
                          : null,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(localization.signInButton),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      context.go('/sign-up');
                    },
                    child: Text(localization.signUpPrompt),
                  ),

                  TextButton(
                    onPressed: () {
                      context.go('/forgot-password');
                    },
                    child: Text(localization.forgotPassword),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
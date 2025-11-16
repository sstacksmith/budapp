import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        if (e.toString().contains('EMAIL_NOT_VERIFIED')) {
          _showEmailNotVerifiedDialog();
        } else {
          _showErrorSnackBar(e.toString());
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showEmailNotVerifiedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Email nie zweryfikowany'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Musisz zweryfikować swój adres email przed zalogowaniem.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Sprawdź swoją skrzynkę pocztową i kliknij link weryfikacyjny.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    
    // Dynamiczne skalowanie bazujące na wysokości ekranu
    // Małe ekrany (< 600): scale 0.85, Średnie (600-750): scale 1.0, Duże (> 750): scale 1.15
    final heightScale = screenHeight < 600 ? 0.85 : (screenHeight < 750 ? 1.0 : 1.15);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // 5% szerokości jako padding
            vertical: screenHeight * 0.015, // 1.5% wysokości jako padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dynamiczny spacing
              SizedBox(height: screenHeight * 0.015),

              // Header z logo
              _buildHeader(loc, screenHeight, heightScale),
              
              SizedBox(height: screenHeight * 0.02),
              
              // Formularz logowania
              _buildLoginForm(loc, screenHeight, screenWidth, heightScale),
              
              SizedBox(height: screenHeight * 0.015),
              
              // Linki
              _buildForgotPassword(loc, heightScale),
              SizedBox(height: screenHeight * 0.008),
              _buildRegisterLink(loc, heightScale),
              
              SizedBox(height: screenHeight * 0.02),
              
              // Przycisk gościa
              _buildGuestLogin(loc, screenHeight, heightScale),
              
              SizedBox(height: screenHeight * 0.015),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations loc, double screenHeight, double scale) {
    // Responsywne logo - 8-10% wysokości ekranu
    final containerSize = (screenHeight * 0.09 * scale).clamp(50.0, 100.0);
    final titleSize = (20.0 * scale).clamp(16.0, 26.0);
    final subtitleSize = (13.0 * scale).clamp(11.0, 16.0);
    
    return Column(
      children: [
        Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(containerSize / 2),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(containerSize / 2),
            child: Image.asset(
              'photos/budapplogo.png',
              width: containerSize,
              height: containerSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.012),
        Text(
          loc.welcomeBack,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: screenHeight * 0.004),
        Text(
          loc.loginToContinue,
          style: TextStyle(
            fontSize: subtitleSize,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(AppLocalizations loc, double screenHeight, double screenWidth, double scale) {
    // Responsywne rozmiary formularza
    final cardPadding = (screenWidth * 0.04).clamp(12.0, 20.0);
    final fieldSpacing = (screenHeight * 0.012).clamp(8.0, 14.0);
    final titleSpacing = (screenHeight * 0.015).clamp(10.0, 16.0);
    final fontSize = (14.0 * scale).clamp(12.0, 17.0);
    final buttonHeight = (screenHeight * 0.018).clamp(10.0, 16.0);
    
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.login,
                style: TextStyle(
                  fontSize: (18.0 * scale).clamp(15.0, 22.0),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: titleSpacing),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: fontSize),
                decoration: InputDecoration(
                  labelText: loc.email,
                  labelStyle: TextStyle(fontSize: fontSize),
                  hintText: loc.enterEmail,
                  hintStyle: TextStyle(fontSize: fontSize - 1),
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: cardPadding * 0.8,
                    vertical: (screenHeight * 0.012).clamp(8.0, 14.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.pleaseEnterEmail;
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return loc.pleaseEnterValidEmail;
                  }
                  return null;
                },
              ),
              SizedBox(height: fieldSpacing),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(fontSize: fontSize),
                decoration: InputDecoration(
                  labelText: loc.password,
                  labelStyle: TextStyle(fontSize: fontSize),
                  hintText: loc.enterPassword,
                  hintStyle: TextStyle(fontSize: fontSize - 1),
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: cardPadding * 0.8,
                    vertical: (screenHeight * 0.012).clamp(8.0, 14.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.pleaseEnterPassword;
                  }
                  if (value.length < 6) {
                    return loc.passwordTooShort;
                  }
                  return null;
                },
              ),
              SizedBox(height: titleSpacing),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: buttonHeight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        loc.login,
                        style: TextStyle(
                          fontSize: (15.0 * scale).clamp(13.0, 18.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword(AppLocalizations loc, double scale) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ForgotPasswordScreen(),
          ),
        );
      },
      child: Text(
        loc.forgotPassword,
        style: TextStyle(
          fontSize: (14.0 * scale).clamp(12.0, 16.0),
          color: Colors.blue[600],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRegisterLink(AppLocalizations loc, double scale) {
    final textSize = (14.0 * scale).clamp(12.0, 16.0);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          loc.dontHaveAccount,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: textSize,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          },
          child: Text(
            loc.register,
            style: TextStyle(
              fontSize: textSize,
              color: Colors.blue[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestLogin(AppLocalizations loc, double screenHeight, double scale) {
    final labelSize = (12.0 * scale).clamp(10.0, 14.0);
    final buttonTextSize = (14.0 * scale).clamp(12.0, 17.0);
    final iconSize = (20.0 * scale).clamp(18.0, 24.0);
    final noteSize = (11.0 * scale).clamp(9.0, 13.0);
    final buttonPadding = (screenHeight * 0.015).clamp(10.0, 16.0);
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[400], thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'lub',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: labelSize,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[400], thickness: 1)),
          ],
        ),
        SizedBox(height: screenHeight * 0.012),
        OutlinedButton.icon(
          onPressed: () {
            // Kontynuuj jako gość - przejdź do HomePage bez logowania
            Navigator.of(context).pushReplacementNamed('/home');
          },
          icon: Icon(Icons.person_outline, size: iconSize),
          label: Text(
            'Kontynuuj jako gość',
            style: TextStyle(
              fontSize: buttonTextSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: buttonPadding,
              horizontal: 20,
            ),
            side: BorderSide(color: Colors.blue[600]!, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            foregroundColor: Colors.blue[600],
          ),
        ),
        SizedBox(height: screenHeight * 0.006),
        Text(
          'Ograniczona funkcjonalność bez konta',
          style: TextStyle(
            fontSize: noteSize,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'dart:async';

/// Splash Screen z background loading
/// Ładuje zasoby aplikacji w tle podczas pokazywania logo
class SplashScreen extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onInit;
  
  const SplashScreen({
    Key? key, 
    required this.child,
    this.onInit,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // Animacja fade in/out
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _controller.forward();
    
    // Background loading
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Minimum splash time (żeby użytkownik zobaczył logo)
      final minimumSplashTime = Future.delayed(const Duration(seconds: 2));
      
      // Initialize app resources
      final initFuture = widget.onInit?.call() ?? Future.value();
      
      // Czekaj na oba (minimum 2s + init)
      await Future.wait([minimumSplashTime, initFuture]);
      
      // Fade out animation
      await _controller.reverse();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading) {
      return widget.child;
    }

    // Wrap Scaffold with Directionality to fix the error
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
      backgroundColor: Colors.blue[700],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo aplikacji
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.construction,
                  size: 60,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 24),
              
              // Nazwa aplikacji
              const Text(
                'BudApp',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              
              // Tagline
              Text(
                'Twój Asystent Budowlany',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 48),
              
              // Loading indicator
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
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



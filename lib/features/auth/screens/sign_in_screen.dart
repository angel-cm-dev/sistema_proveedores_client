import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide Image;
import '../../../core/assets.dart';
import '../widgets/sign_in_form.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  bool _isFormVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuart,
      ),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const RepaintBoundary(
            child: RiveAnimation.asset(RiveAssets.shapes, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              // ignore: deprecated_member_use
              child: Container(color: Colors.black.withOpacity(0.02)),
            ),
          ),
          IgnorePointer(
            ignoring: _isFormVisible,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: _buildWelcomeBody(),
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: _buildGlassPanel(size),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            const Text(
              "Connexa",
              style: TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.w900,
                color: Color(0xFF17203A),
                height: 1.1,
              ),
            ),
            const Text(
              "App para Clientes",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF77D8E),
              ),
            ),
            const Spacer(flex: 2),
            _buildStartButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() => GestureDetector(
        onTap: () {
          setState(() => _isFormVisible = true);
          _animationController.forward();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF77D8E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_forward_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text(
                "COMENZAR",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildGlassPanel(Size size) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            height: size.height * 0.92,
            width: double.infinity,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.4),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(40),
              ),
              border: Border.all(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                _buildHeader(),
                const Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: SignInForm(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                _animationController.reverse().then(
                      (_) => setState(() => _isFormVisible = false),
                    );
              },
              child: CircleAvatar(
                radius: 20,
                // ignore: deprecated_member_use
                backgroundColor: Colors.white.withOpacity(0.5),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF17203A),
                  size: 18,
                ),
              ),
            ),
            Container(
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      );
}

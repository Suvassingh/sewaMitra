
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sewamitra/homeScreen.dart'; // Added for Firebase initialization

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.blue[800],
      ),
      routes: {
        '/role_selection': (context) => const RoleSelectionScreen(),
        '/user_login': (context) => const LoginScreen( isProvider: false ),
        '/provider_login': (context) => const LoginScreen(isProvider: true),
        '/user_signup': (context) => const SignupScreen(isProvider: false),
        '/provider_signup': (context) => const SignupScreen(isProvider: true),
        '/home': (context) => const HomeScreen(),
      },
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _waveAnimation;
  bool _showSkipButton = false;
  bool _showProgress = true;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _waveAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showSkipButton = true);
    });

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() => _showProgress = false);
        Navigator.pushReplacementNamed(context, '/role_selection');
      }
    });
  }

  void _skipSplash() {
    if (mounted) {
      setState(() => _showProgress = false);
      Navigator.pushReplacementNamed(context, '/role_selection');
    }
  }

  void _toggleDarkMode() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _isDarkMode
        ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
        : [const Color(0xFF5D69BE), const Color(0xFFC89FEB)];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _waveAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: WavePainter(
                      waveValue: _waveAnimation.value,
                      isDarkMode: _isDarkMode,
                    ),
                  );
                },
              ),
            ),

            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'app-logo',
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 150,
                          height: 150,
                          color: _isDarkMode ? Colors.white : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'HomeServe',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Book services at your doorstep',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 40),
                      if (_showProgress)
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _isDarkMode ? Colors.blue[200]! : Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            if (_showSkipButton)
              Positioned(
                top: 50,
                right: 20,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: OutlinedButton(
                    onPressed: _skipSplash,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Skip'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double waveValue;
  final bool isDarkMode;

  WavePainter({required this.waveValue, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode
          ? const Color(0xFF0F3460).withOpacity(0.5)
          : Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 30.0;
    final waveLength = size.width / 1.5;
    final offset = waveValue * waveLength;

    path.moveTo(0, size.height);

    for (double i = 0; i <= size.width; i++) {
      final y = waveHeight * sin((i + offset) * math.pi / waveLength) + size.height - 100;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final secondPaint = paint..color = paint.color.withOpacity(0.3);
    final secondPath = Path();
    secondPath.moveTo(0, size.height);

    for (double i = 0; i <= size.width; i++) {
      final y = waveHeight * 0.6 * sin((i + offset * 1.5) * math.pi / (waveLength * 0.8)) + size.height - 130;
      secondPath.lineTo(i, y);
    }

    secondPath.lineTo(size.width, size.height);
    secondPath.close();
    canvas.drawPath(secondPath, secondPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

double sin(double x) => math.sin(x);

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDarkMode
        ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
        : [const Color(0xFF5D69BE), const Color(0xFFC89FEB)];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'app-logo',
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Continue as',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                _buildRoleButton(
                  context: context,
                  title: 'User',
                  subtitle: 'Book home services',
                  icon: Icons.person,
                  isDarkMode: isDarkMode,
                  route: '/user_login',
                ),
                const SizedBox(height: 25),
                _buildRoleButton(
                  context: context,
                  title: 'Service Provider',
                  subtitle: 'Offer your services',
                  icon: Icons.handyman,
                  isDarkMode: isDarkMode,
                  route: '/provider_login',
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/user_login');
                  },
                  child: Text(
                    'Continue as User',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
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

  Widget _buildRoleButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDarkMode,
    required String route,
  }) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isDarkMode ? Colors.black : Colors.white,
        backgroundColor: isDarkMode ? Colors.blue[200] : Colors.white.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        elevation: 0,
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: isDarkMode ? Colors.black : Colors.white),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.black87 : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward, color: isDarkMode ? Colors.black : Colors.white),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final bool isProvider;

  const LoginScreen({super.key, required this.isProvider});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;

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
      _errorMessage = null;
    });

    try {
      final auth = FirebaseAuth.instance;
      final credential = await auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (credential.user?.emailVerified == false) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please verify your email first';
        });
        return;
      }

      // Check user exists in database
      final database = FirebaseDatabase.instance.ref();
      final rolePath = widget.isProvider ? 'providers' : 'users';
      final snapshot = await database.child(rolePath).child(credential.user!.uid).get();

      if (!snapshot.exists) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'User data not found. Please sign up.';
        });
        return;
      }

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message ?? 'Authentication failed';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDarkMode
                  ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                  : [const Color(0xFF5D69BE), const Color(0xFFC89FEB)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'app-logo',
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.isProvider ? 'Service Provider Login' : 'User Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.isProvider
                    ? 'Access your provider account'
                    : 'Login to book services',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField(
                      hint: 'Email',
                      icon: Icons.email_outlined,
                      isDarkMode: isDarkMode,
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      isDarkMode: isDarkMode,
                      controller: _passwordController,
                      isPassword: true,
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isDarkMode ? Colors.black : Colors.white,
                    backgroundColor: isDarkMode ? Colors.blue[200] : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  )
                      : Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.black : const Color(0xFF5D69BE),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        widget.isProvider ? '/provider_signup' : '/user_signup',
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  final bool isProvider;

  const SignupScreen({super.key, required this.isProvider});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final auth = FirebaseAuth.instance;
      final credential = await auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await credential.user?.sendEmailVerification();

      final database = FirebaseDatabase.instance.ref();
      final userData = {
        'uid': credential.user?.uid,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'role': widget.isProvider ? 'provider' : 'user',
        'createdAt': ServerValue.timestamp,
      };

      final rolePath = widget.isProvider ? 'providers' : 'users';
      await database.child(rolePath).child(credential.user!.uid).set(userData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification email sent to ${_emailController.text}'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacementNamed(
        context,
        widget.isProvider ? '/provider_login' : '/user_login',
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message ?? 'Authentication error';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDarkMode
                  ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                  : [const Color(0xFF5D69BE), const Color(0xFFC89FEB)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'app-logo',
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.isProvider ? 'Service Provider Sign Up' : 'User Sign Up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.isProvider
                    ? 'Create your provider account'
                    : 'Sign up to book services',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField(
                      hint: 'Full Name',
                      icon: Icons.person_outline,
                      isDarkMode: isDarkMode,
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      hint: 'Email',
                      icon: Icons.email_outlined,
                      isDarkMode: isDarkMode,
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      hint: 'Phone Number',
                      icon: Icons.phone_outlined,
                      isDarkMode: isDarkMode,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      isDarkMode: isDarkMode,
                      controller: _passwordController,
                      isPassword: true,
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      hint: 'Confirm Password',
                      icon: Icons.lock_reset_outlined,
                      isDarkMode: isDarkMode,
                      controller: _confirmPasswordController,
                      isPassword: true,
                      obscureText: !_isConfirmPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isDarkMode ? Colors.black : Colors.white,
                    backgroundColor: isDarkMode ? Colors.blue[200] : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  )
                      : Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.black : const Color(0xFF5D69BE),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        widget.isProvider ? '/provider_login' : '/user_login',
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}








// class LoginScreen extends StatefulWidget {
//   final bool isProvider;
//
//   const LoginScreen({super.key, required this.isProvider});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _phoneController = TextEditingController();
//   final _otpController = TextEditingController();
//   bool _isLoading = false;
//   String? _errorMessage;
//   String? _verificationId;
//   bool _otpSent = false;
//   int? _resendToken;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _otpController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _verifyPhoneNumber() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: _phoneController.text.trim(),
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await _signInWithPhoneCredential(credential);
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           setState(() {
//             _isLoading = false;
//             _errorMessage = e.message ?? 'Verification failed';
//           });
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() {
//             _isLoading = false;
//             _otpSent = true;
//             _verificationId = verificationId;
//             _resendToken = resendToken;
//           });
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           setState(() {
//             _verificationId = verificationId;
//           });
//         },
//         timeout: const Duration(seconds: 60),
//         forceResendingToken: _resendToken,
//       );
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'An unexpected error occurred';
//       });
//     }
//   }
//
//   Future<void> _resendOTP() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: _phoneController.text.trim(),
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await _signInWithPhoneCredential(credential);
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           setState(() {
//             _isLoading = false;
//             _errorMessage = e.message ?? 'Verification failed';
//           });
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() {
//             _isLoading = false;
//             _verificationId = verificationId;
//             _resendToken = resendToken;
//           });
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           setState(() {
//             _verificationId = verificationId;
//           });
//         },
//         timeout: const Duration(seconds: 60),
//         forceResendingToken: _resendToken,
//       );
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'An unexpected error occurred';
//       });
//     }
//   }
//
//   Future<void> _verifyOTP() async {
//     if (_verificationId == null || _otpController.text.isEmpty) {
//       setState(() {
//         _errorMessage = 'Please enter the OTP';
//       });
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: _otpController.text.trim(),
//       );
//
//       await _signInWithPhoneCredential(credential);
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = e.message ?? 'Verification failed';
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'An unexpected error occurred';
//       });
//     }
//   }
//
//   Future<void> _signInWithPhoneCredential(PhoneAuthCredential credential) async {
//     try {
//       final UserCredential userCredential =
//       await _auth.signInWithCredential(credential);
//
//       // Check if user exists in database
//       final database = FirebaseDatabase.instance.ref();
//       final rolePath = widget.isProvider ? 'providers' : 'users';
//       final snapshot = await database.child(rolePath).child(userCredential.user!.uid).get();
//
//       if (!snapshot.exists) {
//         // New user - create account
//         await _createNewUser(userCredential.user!);
//       }
//
//       Navigator.pushReplacementNamed(context, '/home');
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = e.message ?? 'Authentication failed';
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'An unexpected error occurred';
//       });
//     }
//   }
//
//   Future<void> _createNewUser(User user) async {
//     final database = FirebaseDatabase.instance.ref();
//     final rolePath = widget.isProvider ? 'providers' : 'users';
//
//     final userData = {
//       'uid': user.uid,
//       'phone': user.phoneNumber,
//       'role': widget.isProvider ? 'provider' : 'user',
//       'createdAt': ServerValue.timestamp,
//     };
//
//     await database.child(rolePath).child(user.uid).set(userData);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(30),
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: isDarkMode
//                   ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
//                   : [const Color(0xFF5D69BE), const Color(0xFFC89FEB)],
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Hero(
//                 tag: 'app-logo',
//                 child: Image.asset(
//                   'assets/images/logo.png',
//                   width: 150,
//                   height: 150,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 widget.isProvider ? 'Service Provider Login' : 'User Login',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 widget.isProvider
//                     ? 'Access your provider account'
//                     : 'Login to book services',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white70,
//                 ),
//               ),
//               const SizedBox(height: 30),
//
//               if (_errorMessage != null)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 20),
//                   child: Text(
//                     _errorMessage!,
//                     style: const TextStyle(color: Colors.red, fontSize: 16),
//                   ),
//                 ),
//
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     // Phone number field
//                     _buildPhoneInputField(isDarkMode),
//                     const SizedBox(height: 20),
//
//                     // OTP field (only visible after OTP is sent)
//                     if (_otpSent) ...[
//                       _buildOTPInputField(isDarkMode),
//                       const SizedBox(height: 20),
//                     ],
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//
//               // Send OTP / Verify OTP button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _isLoading
//                       ? null
//                       : _otpSent ? _verifyOTP : _verifyPhoneNumber,
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: isDarkMode ? Colors.black : Colors.white,
//                     backgroundColor: isDarkMode ? Colors.blue[200] : Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 5,
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(strokeWidth: 3),
//                   )
//                       : Text(
//                     _otpSent ? 'Verify OTP' : 'Send OTP',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: isDarkMode ? Colors.black : const Color(0xFF5D69BE),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Resend OTP button
//               if (_otpSent) ...[
//                 const SizedBox(height: 15),
//                 TextButton(
//                   onPressed: _isLoading ? null : _resendOTP,
//                   child: Text(
//                     'Resend OTP',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//
//               const SizedBox(height: 25),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Don't have an account?",
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       // Since we're using phone auth, signup is handled automatically
//                       // Clear the form and reset state
//                       setState(() {
//                         _otpSent = false;
//                         _phoneController.clear();
//                         _otpController.clear();
//                       });
//                     },
//                     child: Text(
//                       'Sign In',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPhoneInputField(bool isDarkMode) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TextFormField(
//         controller: _phoneController,
//         keyboardType: TextInputType.phone,
//         style: const TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           prefixIcon: const Icon(Icons.phone, color: Colors.white70),
//           hintText: 'Phone Number (e.g. +919876543210)',
//           hintStyle: const TextStyle(color: Colors.white54),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter your phone number';
//           }
//           if (!RegExp(r'^\+[1-9]\d{1,14}$').hasMatch(value)) {
//             return 'Please enter a valid phone number with country code';
//           }
//           return null;
//         },
//       ),
//     );
//   }
//
//   Widget _buildOTPInputField(bool isDarkMode) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TextFormField(
//         controller: _otpController,
//         keyboardType: TextInputType.number,
//         style: const TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
//           hintText: 'Enter OTP',
//           hintStyle: const TextStyle(color: Colors.white54),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter the OTP';
//           }
//           if (value.length != 6) {
//             return 'OTP must be 6 digits';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
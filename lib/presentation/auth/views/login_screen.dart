import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/presentation/auth/controllers/login_controller.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      wrapWithAnnotatedRegion: true,
      value: SystemUiOverlayStyle.dark,
      showGradients: false,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(
              painter: _LoginMockupBackgroundPainter(),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalMargin =
                    math.max(24.0, constraints.maxWidth * 0.085);
                final logoWidth = math.min(250.0, constraints.maxWidth * 0.57);

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    horizontalMargin,
                    34,
                    horizontalMargin,
                    42,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 76,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.035),
                        Image.asset(
                          'assets/images/icon.png',
                          width: logoWidth,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: constraints.maxHeight * 0.055),
                        _LoginCard(controller: controller),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({required this.controller});

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 430),
      padding: const EdgeInsets.fromLTRB(28, 30, 28, 28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C81).withOpacity(0.12),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: FormBuilder(
        key: controller.formKey,
        clearValueOnUnregister: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back! \u{1F44B}',
              style: context.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF159B4C),
                fontSize: 19,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Log In',
              style: context.textTheme.displayLarge?.copyWith(
                color: const Color(0xFF020A24),
                fontSize: 45,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                height: 0.96,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Enter your email and password to continue',
              style: context.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF697387),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 34),
            _LoginInputField(
              name: 'email',
              label: 'Email Address',
              hint: 'Enter your email',
              icon: Icons.email_outlined,
              iconBackground: const Color(0xFF075BEE),
              keyboardType: TextInputType.emailAddress,
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ],
              ),
            ),
            const SizedBox(height: 27),
            ValueListenableBuilder<bool>(
              valueListenable: controller.passwordVisibility,
              builder: (context, value, child) {
                return _LoginInputField(
                  name: 'password',
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock_outline,
                  iconBackground: const Color(0xFF159B4C),
                  obscureText: value,
                  suffix: IconButton(
                    splashRadius: 22,
                    onPressed: () => controller.onPasswordToggle(),
                    icon: Icon(
                      value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF748094),
                      size: 25,
                    ),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.toNamed(AppPages.forgetPassword),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Forgot Password?',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF005DEA),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            _GradientLoginButton(
              onTap: () {
                controller.onLoginPress().then((value) {
                  final isDone = value.isDone;
                  final message = value.message;
                  if (isDone) {
                    Get.offAllNamed(AppPages.bottomNav);
                  } else {
                    if (message.isEmpty) return;
                    FlushSnackbar.showSnackBar(message);
                  }
                });
              },
            ),
            const SizedBox(height: 29),
            const _LoginDivider(),
            const SizedBox(height: 24),
            AuthWidgetSpanBuilder(
              firstTitle: "Don't have an account? ",
              secondTitle: 'Sign Up',
              onTap: () => Get.toNamed(AppPages.signUp),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginInputField extends StatelessWidget {
  const _LoginInputField({
    required this.name,
    required this.label,
    required this.hint,
    required this.icon,
    required this.iconBackground,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.validator,
  });

  final String name;
  final String label;
  final String hint;
  final IconData icon;
  final Color iconBackground;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF030A28),
            fontSize: 15.5,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        FormBuilderTextField(
          name: name,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          style: const TextStyle(
            color: Color(0xFF020A24),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF758196),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            errorStyle: const TextStyle(
              fontSize: 11,
              fontFamily: 'Poppins',
              height: 1.1,
            ),
            filled: true,
            fillColor: Colors.white,
            isDense: false,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 16, 10),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: iconBackground.withOpacity(0.24),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 72,
              minHeight: 62,
            ),
            suffixIcon: suffix,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 52,
              minHeight: 52,
            ),
            border: _fieldBorder(const Color(0xFFDDE4EE), 1.2),
            enabledBorder: _fieldBorder(const Color(0xFFDDE4EE), 1.2),
            focusedBorder: _fieldBorder(const Color(0xFFB9C7DA), 1.4),
            errorBorder: _fieldBorder(Colors.redAccent, 1.2),
            focusedErrorBorder: _fieldBorder(Colors.redAccent, 1.4),
          ),
        ),
      ],
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, double width) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(15),
    );
  }
}

class _GradientLoginButton extends StatelessWidget {
  const _GradientLoginButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF168BFF),
            Color(0xFF0047D8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF005DEA).withOpacity(0.28),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(width: 22),
              Text(
                'Log In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginDivider extends StatelessWidget {
  const _LoginDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(0xFFDDE4EE),
            thickness: 1,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'OR',
            style: context.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF697387),
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(0xFFDDE4EE),
            thickness: 1,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _LoginMockupBackgroundPainter extends CustomPainter {
  const _LoginMockupBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.white,
    );

    _drawSoftBlueSweep(canvas, size);
    _drawTopRightFlagSweep(canvas, size);
    _drawBottomFlagSweep(canvas, size);
    _drawDotPattern(canvas, size);
  }

  void _drawSoftBlueSweep(Canvas canvas, Size size) {
    final paleBlue = Paint()..color = const Color(0xFFEAF3FF);
    final paleBlue2 = Paint()..color = const Color(0xFFDDEBFC);

    final leftRibbon = Path()
      ..moveTo(0, size.height * 0.29)
      ..cubicTo(
        size.width * 0.16,
        size.height * 0.15,
        size.width * 0.07,
        size.height * 0.03,
        size.width * 0.34,
        -size.height * 0.02,
      )
      ..lineTo(size.width * 0.47, 0)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.08,
        size.width * 0.15,
        size.height * 0.2,
        0,
        size.height * 0.38,
      )
      ..close();
    canvas.drawPath(leftRibbon, paleBlue);

    final lowerRibbon = Path()
      ..moveTo(size.width, size.height * 0.86)
      ..cubicTo(
        size.width * 0.77,
        size.height * 0.91,
        size.width * 0.72,
        size.height * 0.98,
        size.width * 0.42,
        size.height,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(lowerRibbon, paleBlue2);
  }

  void _drawTopRightFlagSweep(Canvas canvas, Size size) {
    final yellow = Paint()..color = const Color(0xFFF2D30A);
    final green = Paint()..color = const Color(0xFF078E43);

    final yellowPath = Path()
      ..moveTo(size.width * 0.66, 0)
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.015,
        size.width * 0.91,
        size.height * 0.08,
        size.width,
        size.height * 0.185,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(yellowPath, yellow);

    final greenPath = Path()
      ..moveTo(size.width * 0.7, 0)
      ..cubicTo(
        size.width * 0.83,
        size.height * 0.025,
        size.width * 0.93,
        size.height * 0.09,
        size.width,
        size.height * 0.155,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(greenPath, green);

    final darkPath = Path()
      ..moveTo(size.width * 0.84, 0)
      ..cubicTo(
        size.width * 0.9,
        size.height * 0.02,
        size.width * 0.96,
        size.height * 0.06,
        size.width,
        size.height * 0.11,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(
      darkPath,
      Paint()..color = const Color(0xFF006C39).withOpacity(0.35),
    );

    final goldRim = Path()
      ..moveTo(size.width * 0.66, 0)
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.015,
        size.width * 0.91,
        size.height * 0.08,
        size.width,
        size.height * 0.185,
      );
    canvas.drawPath(
      goldRim,
      Paint()
        ..color = const Color(0xFFFFE873)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawBottomFlagSweep(Canvas canvas, Size size) {
    final yellow = Paint()..color = const Color(0xFFF2D30A);
    final green = Paint()..color = const Color(0xFF048F48);
    final blue = Paint()..color = const Color(0xFF0055DD);

    final yellowPath = Path()
      ..moveTo(0, size.height * 0.85)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.98,
        size.width * 0.43,
        size.height,
        size.width * 0.64,
        size.height * 0.94,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(yellowPath, yellow);

    final greenPath = Path()
      ..moveTo(0, size.height * 0.875)
      ..cubicTo(
        size.width * 0.19,
        size.height * 0.995,
        size.width * 0.43,
        size.height * 0.99,
        size.width * 0.62,
        size.height * 0.94,
      )
      ..cubicTo(
        size.width * 0.45,
        size.height * 1.02,
        size.width * 0.17,
        size.height,
        0,
        size.height * 0.93,
      )
      ..close();
    canvas.drawPath(greenPath, green);

    final darkGreenPath = Path()
      ..moveTo(0, size.height * 0.91)
      ..cubicTo(
        size.width * 0.14,
        size.height * 0.99,
        size.width * 0.36,
        size.height,
        size.width * 0.52,
        size.height * 0.97,
      )
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      darkGreenPath,
      Paint()..color = const Color(0xFF006E47).withOpacity(0.46),
    );

    final bluePath = Path()
      ..moveTo(size.width * 0.41, size.height)
      ..cubicTo(
        size.width * 0.55,
        size.height * 0.95,
        size.width * 0.61,
        size.height * 0.91,
        size.width * 0.75,
        size.height * 0.95,
      )
      ..cubicTo(
        size.width * 0.84,
        size.height * 0.98,
        size.width * 0.91,
        size.height * 0.99,
        size.width,
        size.height,
      )
      ..close();
    canvas.drawPath(bluePath, blue);

    final deepBluePath = Path()
      ..moveTo(size.width * 0.54, size.height)
      ..cubicTo(
        size.width * 0.64,
        size.height * 0.955,
        size.width * 0.75,
        size.height * 0.96,
        size.width,
        size.height,
      )
      ..close();
    canvas.drawPath(
      deepBluePath,
      Paint()..color = const Color(0xFF003EB8).withOpacity(0.45),
    );

    final goldRim = Path()
      ..moveTo(0, size.height * 0.85)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.98,
        size.width * 0.43,
        size.height,
        size.width * 0.64,
        size.height * 0.94,
      );
    canvas.drawPath(
      goldRim,
      Paint()
        ..color = const Color(0xFFFFE873)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawDotPattern(Canvas canvas, Size size) {
    final dotPaint = Paint()..color = Colors.white.withOpacity(0.55);
    final startX = size.width * 0.84;
    final startY = size.height * 0.035;

    for (var row = 0; row < 5; row++) {
      for (var col = 0; col < 7; col++) {
        canvas.drawCircle(
          Offset(startX + col * 11, startY + row * 15),
          2,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AuthWidgetSpanBuilder extends StatelessWidget {
  const AuthWidgetSpanBuilder({
    super.key,
    required this.firstTitle,
    required this.secondTitle,
    this.onTap,
  });

  final String firstTitle;
  final String secondTitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: firstTitle,
              style: context.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF020A24),
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: InkWell(
                splashColor: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(3),
                onTap: onTap,
                child: Text(
                  secondTitle,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF005DEA),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderSide side;
  final double buttonBorderRadius;

  /// .h is internaly used
  final double height;
  final double? width;
  final double? fontSize;
  const AppButton({
    super.key,
    required this.title,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.side = BorderSide.none,
    this.buttonBorderRadius = 19,
    this.height = 6.9,
    this.fontSize,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.width,
      height: height.h,
      child: TextButton(
        style: TextButton.styleFrom(
          disabledBackgroundColor: Colors.black12.withOpacity(0.1),
          backgroundColor: backgroundColor ?? const Color(0xFF4791CE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
            side: side,
          ),
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: textColor ?? const Color(0xFFFFF9FF),
            fontSize: fontSize ?? 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

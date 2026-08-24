import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/presentation/auth/controllers/signup_controller.dart';
import 'package:straight_to_yard/presentation/auth/views/login_screen.dart';
import 'package:straight_to_yard/presentation/auth/widgets/drop_down.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

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
              painter: _SignupMockupBackgroundPainter(),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalMargin =
                    math.max(20.0, constraints.maxWidth * 0.048);
                final logoWidth = math.min(185.0, constraints.maxWidth * 0.35);

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    horizontalMargin,
                    24,
                    horizontalMargin,
                    40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _SignupTopBar(logoWidth: logoWidth),
                      const SizedBox(height: 40),
                      const _SignupHeader(),
                      const SizedBox(height: 24),
                      _SignupCard(controller: controller),
                      const SizedBox(height: 24),
                      const _RoundDivider(),
                      const SizedBox(height: 22),
                      AuthWidgetSpanBuilder(
                        firstTitle: 'Already have an account? ',
                        secondTitle: 'Log In  ->',
                        onTap: () => Get.offAllNamed(AppPages.login),
                      ),
                    ],
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

class _SignupTopBar extends StatelessWidget {
  const _SignupTopBar({required this.logoWidth});

  final double logoWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F4C81).withOpacity(0.1),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Get.offAllNamed(AppPages.login),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF078E31),
                  size: 24,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Image.asset(
              'assets/images/icon.png',
              width: logoWidth,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignupHeader extends StatelessWidget {
  const _SignupHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Create ',
                  style: _headlineStyle(const Color(0xFF020A24)),
                ),
                TextSpan(
                  text: 'Account',
                  style: _headlineStyle(const Color(0xFF078E31)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Fill in your details to get started',
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF6E7480),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: 64,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF078E31),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ],
    );
  }

  static TextStyle _headlineStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 40,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w800,
      height: 1.05,
    );
  }
}

class _SignupCard extends StatelessWidget {
  const _SignupCard({required this.controller});

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 620),
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C81).withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: FormBuilder(
        key: controller.formKey,
        clearValueOnUnregister: true,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<SignUpController>(
              id: 'managers',
              builder: (_) {
                if (_.managers.managers.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    _SignupDropdown<OutLetPair>(
                      name: 'managerId',
                      label: 'Managers (Optional)',
                      hint: 'Select Manager',
                      icon: Icons.supervisor_account_outlined,
                      validator: FormBuilderValidators.compose([]),
                      onChanged: (e) {},
                      items: controller.managers.managers
                          .map(
                            (e) => OutLetPair(
                              key: e.id.toString(),
                              value: e.name,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 22),
                  ],
                );
              },
            ),
            GetBuilder<SignUpController>(
              id: 'outLet',
              builder: (_) {
                return _SignupDropdown<OutLetPair>(
                  name: 'outletId',
                  label: 'Outlet',
                  hint: 'Select Outlet',
                  icon: Icons.storefront_outlined,
                  onChanged: (e) {},
                  items: controller.outLet.outLets
                      .map(
                        (e) => OutLetPair(
                          key: e.outletId,
                          value: e.outletName,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 22),
            _SignupDropdown<NormalString>(
              name: 'userType',
              label: 'User Type',
              hint: 'Select User Type',
              icon: Icons.person_outline_rounded,
              onChanged: (e) {
                controller.onUserTypeSelect(e?.key ?? 'Personal');
              },
              items: const ['Personal', 'Business']
                  .map((e) => NormalString(key: e, value: e))
                  .toList(),
            ),
            const SizedBox(height: 26),
            const _FormSectionDivider(),
            const SizedBox(height: 26),
            LayoutBuilder(
              builder: (context, constraints) {
                final useTwoColumns = constraints.maxWidth >= 410;

                if (!useTwoColumns) {
                  return Column(
                    children: [
                      _SignupTextField(
                        name: 'firstName',
                        label: 'First Name',
                        hint: 'Enter first name',
                        icon: Icons.person_outline_rounded,
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                      const SizedBox(height: 22),
                      _SignupTextField(
                        name: 'lastName',
                        label: 'Last Name',
                        hint: 'Enter last name',
                        icon: Icons.person_outline_rounded,
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _SignupTextField(
                        name: 'firstName',
                        label: 'First Name',
                        hint: 'Enter first name',
                        icon: Icons.person_outline_rounded,
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                    ),
                    const SizedBox(width: 22),
                    Expanded(
                      child: _SignupTextField(
                        name: 'lastName',
                        label: 'Last Name',
                        hint: 'Enter last name',
                        icon: Icons.person_outline_rounded,
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 22),
            _SignupTextField(
              name: 'email',
              label: 'Email',
              hint: 'Enter email address',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _SignupTextField(
              name: 'confirm_email',
              label: 'Confirm Email',
              hint: 'Confirm email address',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                  (value) {
                    final email = controller
                        .formKey.currentState?.instantValue['email'] as String?;
                    return value?.toLowerCase() == email?.toLowerCase()
                        ? null
                        : 'Emails do not match';
                  },
                ],
              ),
            ),
            const SizedBox(height: 22),
            ValueListenableBuilder<bool>(
              valueListenable: controller.passwordVisibility,
              builder: (context, value, child) {
                return _SignupTextField(
                  name: 'password',
                  label: 'Password',
                  hint: 'Enter password',
                  icon: Icons.lock_outline_rounded,
                  obscureText: value,
                  suffix: IconButton(
                    splashRadius: 22,
                    onPressed: () => controller.onPasswordToggle(),
                    icon: Icon(
                      value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF5D6575),
                      size: 23,
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
            const SizedBox(height: 22),
            ValueListenableBuilder<bool>(
              valueListenable: controller.confirmPasswordVisibility,
              builder: (context, value, child) {
                return _SignupTextField(
                  name: 'confirm_password',
                  label: 'Re-type Password',
                  hint: 'Confirm password',
                  icon: Icons.lock_outline_rounded,
                  obscureText: value,
                  suffix: IconButton(
                    splashRadius: 22,
                    onPressed: () => controller.onConfirmPasswordToggle(),
                    icon: Icon(
                      value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF5D6575),
                      size: 23,
                    ),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                      (value) {
                        final pwd = controller.formKey.currentState
                            ?.instantValue['password'] as String?;
                        return value?.toLowerCase() == pwd?.toLowerCase()
                            ? null
                            : 'Passwords do not match';
                      },
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 22),
            _SignupTextField(
              name: 'phone',
              label: 'Phone (Optional)',
              hint: 'Phone #',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: FormBuilderValidators.compose(
                [FormBuilderValidators.numeric()],
              ),
            ),
            const SizedBox(height: 22),
            _SignupTextField(
              name: 'address1',
              label: 'Address 1 (Optional)',
              hint: 'Address 1',
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 26),
            const _SecureInfoBanner(),
            const SizedBox(height: 22),
            const _CreateAccountButton(),
          ],
        ),
      ),
    );
  }
}

class _SignupDropdown<T extends Pair> extends StatelessWidget {
  const _SignupDropdown({
    required this.name,
    required this.label,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  final String name;
  final String label;
  final String hint;
  final IconData icon;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SignupLabel(label),
        const SizedBox(height: 12),
        FormBuilderDropdown<T>(
          name: name,
          validator: validator ??
              FormBuilderValidators.compose(
                [FormBuilderValidators.required()],
              ),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF020A24),
            size: 30,
          ),
          decoration: _SignupFieldDecoration(
            hint: hint,
            icon: icon,
          ),
          dropdownColor: Colors.white,
          style: _inputTextStyle(),
          onChanged: onChanged,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    item.value,
                    overflow: TextOverflow.ellipsis,
                    style: _inputTextStyle().copyWith(
                      color: const Color(0xFF020A24),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SignupTextField extends StatelessWidget {
  const _SignupTextField({
    required this.name,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.validator,
  });

  final String name;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SignupLabel(label),
        const SizedBox(height: 12),
        FormBuilderTextField(
          name: name,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          style: _inputTextStyle().copyWith(
            color: const Color(0xFF020A24),
          ),
          decoration: _SignupFieldDecoration(
            hint: hint,
            icon: icon,
            suffix: suffix,
          ),
        ),
      ],
    );
  }
}

class _SignupLabel extends StatelessWidget {
  const _SignupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF020A24),
        fontSize: 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
    );
  }
}

class _SignupFieldDecoration extends InputDecoration {
  _SignupFieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) : super(
          hintText: hint,
          hintStyle: _inputTextStyle(),
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
            padding: const EdgeInsets.fromLTRB(13, 10, 15, 10),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF8EC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF078E31),
                size: 24,
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 70,
            minHeight: 64,
          ),
          suffixIcon: suffix,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 52,
            minHeight: 52,
          ),
          border: _border(const Color(0xFFDCE3ED), 1.1),
          enabledBorder: _border(const Color(0xFFDCE3ED), 1.1),
          focusedBorder: _border(const Color(0xFFB9C7DA), 1.35),
          errorBorder: _border(Colors.redAccent, 1.1),
          focusedErrorBorder: _border(Colors.redAccent, 1.35),
        );

  static OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(15),
    );
  }
}

TextStyle _inputTextStyle() {
  return const TextStyle(
    color: Color(0xFF858895),
    fontSize: 15.5,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
}

class _FormSectionDivider extends StatelessWidget {
  const _FormSectionDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(0xFFE1E6EE),
            thickness: 1,
            height: 1,
          ),
        ),
        Container(
          width: 86,
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF078E31),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(0xFFE1E6EE),
            thickness: 1,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _SecureInfoBanner extends StatelessWidget {
  const _SecureInfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFDCE3ED),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFFEAF8EC).withOpacity(0.72),
            Colors.white,
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF078E31),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your information is secure with us',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF020A24),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'We never share your details with anyone',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF5D6575),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateAccountButton extends GetView<SignUpController> {
  const _CreateAccountButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
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
          onTap: () => controller.onSignUpPress(),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_add_alt_1_outlined,
                  color: Colors.white,
                  size: 29,
                ),
                const SizedBox(width: 18),
                const Flexible(
                  child: Text(
                    'Create Account',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF005DEA),
                    size: 22,
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

class _RoundDivider extends StatelessWidget {
  const _RoundDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(0xFFDCE3ED),
            thickness: 1,
            height: 1,
            indent: 72,
          ),
        ),
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.84),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFDCE3ED)),
          ),
          child: Text(
            'OR',
            style: context.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF020A24),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(0xFFDCE3ED),
            thickness: 1,
            height: 1,
            endIndent: 72,
          ),
        ),
      ],
    );
  }
}

class _SignupMockupBackgroundPainter extends CustomPainter {
  const _SignupMockupBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFFDFEFF),
    );

    _drawSoftWashes(canvas, size);
    _drawLineArcs(canvas, size);
    _drawDots(canvas, size);
  }

  void _drawSoftWashes(Canvas canvas, Size size) {
    final green = Paint()..color = const Color(0xFFE4F7E8);
    final blue = Paint()..color = const Color(0xFF69A9FF).withOpacity(0.78);

    final topRight = Path()
      ..moveTo(size.width * 0.86, 0)
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.06,
        size.width * 0.9,
        size.height * 0.09,
        size.width,
        size.height * 0.12,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(topRight, green);

    final lowerLeft = Path()
      ..moveTo(0, size.height * 0.84)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.87,
        size.width * 0.1,
        size.height * 0.95,
        size.width * 0.18,
        size.height,
      )
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(lowerLeft, green);

    final lowerRight = Path()
      ..moveTo(size.width, size.height * 0.86)
      ..cubicTo(
        size.width * 0.83,
        size.height * 0.91,
        size.width * 0.78,
        size.height * 0.96,
        size.width * 0.74,
        size.height,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(lowerRight, blue);
  }

  void _drawLineArcs(Canvas canvas, Size size) {
    final greenStroke = Paint()
      ..color = const Color(0xFF79D88B).withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final blueStroke = Paint()
      ..color = const Color(0xFF5CA7FF).withOpacity(0.62)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 0; i < 7; i++) {
      canvas.drawArc(
        Rect.fromLTWH(
          size.width * 0.86 + i * 9,
          -58 + i * 8,
          160 + i * 16,
          160 + i * 16,
        ),
        math.pi * 0.62,
        math.pi * 0.96,
        false,
        greenStroke,
      );

      canvas.drawArc(
        Rect.fromLTWH(
          -130 - i * 8,
          size.height * 0.28 + i * 16,
          230 + i * 26,
          230 + i * 26,
        ),
        -math.pi * 0.35,
        math.pi * 0.9,
        false,
        blueStroke,
      );

      canvas.drawArc(
        Rect.fromLTWH(
          size.width * 0.74 + i * 12,
          size.height * 0.66 + i * 17,
          240 + i * 24,
          240 + i * 24,
        ),
        math.pi * 0.92,
        math.pi * 0.8,
        false,
        blueStroke,
      );
    }
  }

  void _drawDots(Canvas canvas, Size size) {
    final dotPaint = Paint()..color = const Color(0xFF078E31).withOpacity(0.7);
    final startX = size.width * 0.86;
    final startY = size.height * 0.145;

    for (var row = 0; row < 5; row++) {
      for (var col = 0; col < 5; col++) {
        canvas.drawCircle(
          Offset(startX + col * 15, startY + row * 15),
          2.1,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

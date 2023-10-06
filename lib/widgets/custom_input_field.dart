import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';

class CustomInputField extends StatefulWidget {
  final void Function(String)? onChanged;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onSubmitted;
  final bool obscurable;
  final String? initialData;
  final TextEditingController? controller;

  const CustomInputField({
    super.key,
    this.hintText,
    this.onChanged,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.onSubmitted,
    this.obscurable = false,
    this.initialData,
    this.controller,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;
  final bool _obscured = true;
  bool _validatorFailed = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_listenToFocusNode);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_listenToFocusNode);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: SizedBox(
              height: _validatorFailed ? 52.0 : 42.2,
              child: TextFormField(
                initialValue: widget.initialData,
                focusNode: _focusNode,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: widget.textInputAction,
                keyboardType: widget.keyboardType,
                cursorColor: CustomColors.of(context).primary,
                onChanged: (text) {
                  if (_hasText && text.isEmpty) _toggleHasText();
                  if (!_hasText && text.isNotEmpty) _toggleHasText();

                  if (text.isNotEmpty && widget.validator != null) {
                    final valid = widget.validator!(text) == null;
                    if (valid) {
                      _formKey.currentState?.validate();
                    }
                  }
                  if (widget.onChanged != null) widget.onChanged!(text);
                },
                onFieldSubmitted: (value) {
                  if (widget.onSubmitted != null) widget.onSubmitted!();
                },
                validator: (value) {
                  if (widget.validator != null) {
                    final isValid = widget.validator!(value);
                    if (isValid != null) {
                      setState(() {
                        _validatorFailed = true;
                      });
                    } else {
                      setState(() {
                        _validatorFailed = false;
                      });
                    }
                    return isValid;
                  } else {
                    _validatorFailed = false;
                    return null;
                  }
                },
                style: CustomTextStyles.of(context).medium24.copyWith(height: 1.4),
                obscureText: widget.obscurable ? _obscured : false,
                maxLines: 1,
                decoration: InputDecoration(
                  isDense: true,
                  // prefixIconConstraints: const BoxConstraints(maxWidth: 48, maxHeight: 36, minWidth: 48, minHeight: 36),
                  contentPadding: EdgeInsets.only(
                    left: 6,
                    bottom: _validatorFailed ? -14 : -2,
                    top: _validatorFailed ? 11 : 0,
                    right: 6,
                  ),
                  hintText: widget.hintText,
                  hintStyle: CustomTextStyles.of(context).light24Opacity,
                  errorStyle: CustomTextStyles.of(context).light12.copyWith(
                        color: CustomColors.of(context).errorColor,
                        height: 0.3,
                      ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.of(context).borderColor, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.of(context).borderColor, width: 1.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.of(context).borderColor, width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.of(context).borderColor, width: 1.0),
                  ),
                ),
              ),
            ),
          ),
          // if (widget.obscurable)
          //   Positioned(
          //     right: 0,
          //     bottom: 6,
          //     top: 0,
          //     child: Container(
          //       alignment: Alignment.bottomCenter,
          //       padding: const EdgeInsets.only(right: 12, bottom: 22),
          //       child: GestureDetector(
          //         onTap: () => setState(() => _obscured = !_obscured),
          //         child: Image.asset(
          //           !_obscured ? 'assets/icon/icon_eye_open.png' : 'assets/icon/icon_eye_closed.png',
          //           height: 28,
          //           width: 28,
          //           fit: BoxFit.fill,
          //           color: CustomColors.of(context).borderColor,
          //         ),
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }

  void _toggleHasText() {
    _hasText = !_hasText;
    setState(() {});
  }

  void _listenToFocusNode() {
    if (_focusNode.hasFocus == false) {
      _formKey.currentState?.validate();
    }
  }
}

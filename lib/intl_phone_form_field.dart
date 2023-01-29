library intl_phone_form_field;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl_phone_form_field/src/utils/phone_number.dart';

import 'src/intl_form_country.dart';
import 'src/utils/countries.dart';

class IntlPhoneFormField extends FormBuilderField<String> {
  final String? initalCountryCode;
  final String? selectTitle;
  final TextStyle? selectTitleStyle;
  final bool showFlag;
  final TextEditingController? controller;
  IntlPhoneFormField({
    Key? key,
    required String name,
    InputDecoration decoration = const InputDecoration(),
    String? initialValue,
    FormFieldValidator<String>? validator,
    this.initalCountryCode,
    this.selectTitle,
    this.selectTitleStyle,
    this.showFlag = false,
    this.controller,
  }) : super(
            key: key,
            name: name,
            initialValue: controller?.text,
            validator: validator,
            builder: (FormFieldState<String?> field) {
              final state = field as _IntlPhoneFormFieldState;
              return TextField(
                controller: state._effectiveController,
                decoration: decoration.copyWith(
                  prefixIcon: state._buildFlagButton(),
                ),
              );
            });


  
  @override
  FormBuilderFieldState<FormBuilderField<String>, String>
      createState() => _IntlPhoneFormFieldState();
}

class _IntlPhoneFormFieldState
    extends FormBuilderFieldState<IntlPhoneFormField, String> {
  late Country _selectedCountry;
  late List<Country> _countryList;
  late String _initalCountryCode;
  TextEditingController? get _effectiveController => widget.controller??_controller;
  TextEditingController? _controller;
  

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: value);
    _controller?.addListener(_handleControllerChanged);
    _countryList = countries;
    _initalCountryCode = widget.initalCountryCode ?? "1";
    _selectedCountry = _countryList.firstWhere(
        (country) =>
            _initalCountryCode.toLowerCase() == country.dialCode.toLowerCase(),
        orElse: () => _countryList.first);
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleControllerChanged);
    if(null == widget.controller){
      _controller?.dispose();
    }
    super.dispose();
  }
  @override
  void didChange(String? value) {
    super.didChange("${_selectedCountry.dialCode}$value");
    if(_effectiveController?.text != value){
      _effectiveController?.text = value??"";
    }
  }
  Widget _buildFlagButton() {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_drop_down),
            if (widget.showFlag) ...[
              Image.asset(
                'assets/flags/${_selectedCountry.code.toLowerCase()}.png',
                package: 'intl_phone_form_field',
                width: 30,
                height: 20,
              ),
              const SizedBox(width: 8),
            ],
            Text("+${_selectedCountry.dialCode}"),
          ],
        ),
        onTap: () async {
          final country = await Navigator.of(context).push<Country>(
            MaterialPageRoute(
              builder: (context) => IntlFormContry(
                titelTextStyle: widget.selectTitleStyle,
                title: widget.selectTitle,
              ),
            ),
          );
          if (country != null) {
            setState(() {
              _selectedCountry = country;
              didChange(_effectiveController?.text);
            });
          }
        },
      ),
    );
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController!.text != (value ?? '')) {
      didChange(_effectiveController?.text);
    }
  }
}

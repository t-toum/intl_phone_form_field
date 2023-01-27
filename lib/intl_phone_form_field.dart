library intl_phone_form_field;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl_phone_form_field/src/utils/phone_number.dart';

import 'src/intl_form_country.dart';
import 'src/utils/countries.dart';

class IntlPhoneFormField extends FormBuilderField<PhoneNumber> {
  final String? initalCountryCode;
  final PhoneNumber? initalPhoneNumber;
  final String? selectTitle;
  final TextStyle? selectTitleStyle;

  IntlPhoneFormField({
    Key? key,
    required String name,
    this.initalCountryCode,
    this.initalPhoneNumber,
    this.selectTitle,
    this.selectTitleStyle,
  }) : super(
            key: key,
            name: name,
            initialValue: initalPhoneNumber,
            builder: (FormFieldState<PhoneNumber> field) {
              final state = field as _IntlPhoneFormFieldState;
              return TextField(
                decoration: state.decoration.copyWith(
                    prefixIcon: state._buildFlagButton(),
                    border: OutlineInputBorder()),
              );
            });
  @override
  FormBuilderFieldState<FormBuilderField<PhoneNumber>, PhoneNumber>
      createState() => _IntlPhoneFormFieldState();
}

class _IntlPhoneFormFieldState
    extends FormBuilderFieldState<IntlPhoneFormField, PhoneNumber> {
  late Country _selectedCountry;
  late List<Country> _countryList;
  late String _initalCountryCode;
  late PhoneNumber _phoneNumber;
  @override
  void initState() {
    super.initState();
    _countryList = countries;
    _initalCountryCode = widget.initalCountryCode ?? "US";
    _selectedCountry = _countryList.firstWhere(
        (country) =>
            _initalCountryCode.toLowerCase() == country.code.toLowerCase(),
        orElse: () => _countryList.first);

    //Phone number
    _phoneNumber = PhoneNumber(
      countryCode: _selectedCountry.dialCode,
      countryISOCode: _selectedCountry.code,
      number: "",
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChange(PhoneNumber? value) {
    // TODO: implement didChange
    super.didChange(value);
  }

  Widget _buildFlagButton() {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_drop_down),
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
              // didChange(_phoneNumber);
            });
          }
        },
      ),
    );
  }
}

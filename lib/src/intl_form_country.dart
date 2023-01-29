import 'package:flutter/material.dart';

import 'utils/countries.dart';

class IntlFormContry extends StatefulWidget {
  final String? title;
  final TextStyle? titelTextStyle;
  final String hintText;
  const IntlFormContry({
    super.key,
    this.title,
    this.titelTextStyle,
    this.hintText = "Search",
  });

  @override
  State<IntlFormContry> createState() => _IntlFormContryState();
}

class _IntlFormContryState extends State<IntlFormContry> {
  late TextEditingController _controller;
  late List<Country> _countriesList;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _countriesList = countries;
    _controller.addListener(() {
      searchCountry();
    });
  }

  void searchCountry() {
    setState(() {
      if (_controller.text.isEmpty) {
        _countriesList = countries;
      } else {
        _countriesList = countries
            .where(
              (country) =>
                  country.name
                      .toLowerCase()
                      .contains(_controller.text.toLowerCase()) ||
                  country.code
                      .toLowerCase()
                      .contains(_controller.text.toLowerCase()) ||
                  country.dialCode
                      .toLowerCase()
                      .contains(_controller.text.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? '',
          style: widget.titelTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                suffixIcon:const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _countriesList.map((country) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 8,
                          dense: true,
                          leading: Text(
                            country.flag,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.black),
                          ),
                          title: Text(country.name,
                              style: Theme.of(context).textTheme.bodyLarge),
                          trailing: Text("+${country.dialCode}"),
                          onTap: () {
                            Navigator.of(context).pop<Country>(country);
                          },
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

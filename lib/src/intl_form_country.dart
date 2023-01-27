import 'package:flutter/material.dart';

import 'utils/countries.dart';

class IntlFormContry extends StatelessWidget {
  final String? title;
  final TextStyle? titelTextStyle;
  const IntlFormContry({
    super.key,
    this.title,
    this.titelTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title ?? '',
          style: titelTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Search"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: countries
                      .map((country) => ListTile(
                            leading: Text(country.flag),
                            title: Text(country.name),
                            trailing: Text("+${country.dialCode}"),
                            onTap: () {
                              Navigator.of(context).pop<Country>(country);
                            },
                          ))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

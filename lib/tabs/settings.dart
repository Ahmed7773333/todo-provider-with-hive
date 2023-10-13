import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../app_theme.dart';
import '../widgets/back_ground.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';
import '../providers/bottom_sheet.dart';
import '../providers/l_d_mode.dart';
import '../providers/language.dart';
import '../widgets/bottom_sheet.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> languages = ['English', 'عربي', 'Deutsch', 'Français'];
    String? selectedLanguage = languages[0];
    String light = 'Light';
    String dark = 'Dark';
    List<String> mode = [
      light,
      dark,
    ];
    final bottomSheetProvider = Provider.of<BottomSheetProvider>(context);
    String? selectedMode = mode[0];

    return Background(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * (60 / 870),
            right: MediaQuery.of(context).size.width * (37 / 412),
            left: MediaQuery.of(context).size.width * (37 / 412),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (15 / 412),
                ),
                child: Text(
                  AppLocalizations.of(context)!.settings,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (150 / 870),
              ),
              Text(
                AppLocalizations.of(context)!.language,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (17 / 870)),
              DropDownMenu22(
                (value) {
                  final languageProvider =
                      Provider.of<LanguageProvider>(context, listen: false);
                  switch (value) {
                    case 'English':
                      languageProvider.changeLanguage(const Locale('en'));
                      break;
                    case 'عربي':
                      languageProvider.changeLanguage(const Locale('ar'));
                      break;
                    case 'Deutsch':
                      languageProvider.changeLanguage(const Locale('de'));
                      break;
                    case 'Français':
                      languageProvider.changeLanguage(const Locale('fr'));
                      break;
                    default:
                      break;
                  }
                  selectedLanguage = value.toString();
                },
                languages,
                selectedLanguage,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (19 / 870),
              ),
              Text(
                AppLocalizations.of(context)!.mode,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (17 / 870)),
              DropDownMenu22(
                (value) {
                  var themeProvider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  if (value == 'Light') {
                    themeProvider.setTheme(AppTheme.lightTheme);
                  } else if (value == 'Dark') {
                    themeProvider.setTheme(AppTheme.darkTheme);
                  }
                  selectedMode = value.toString();
                },
                mode,
                selectedMode,
              ),
            ],
          ),
        ),
        bottomSheet: bottomSheetProvider.isBottomSheetVisible
            ? const BottomModelProvider()
            : null,
      ),
    );
  }
}

// ignore: must_be_immutable
class DropDownMenu22 extends StatelessWidget {
  List<String> items;
  String? selectedValue;
  Function(String?) onChanged;
  DropDownMenu22(this.onChanged, this.items, this.selectedValue, {super.key});

  @override
  Widget build(BuildContext context) {
    Color fillColor = Provider.of<ThemeProvider>(context, listen: false).mode ==
            AppTheme.darkTheme
        ? AppTheme.blackColor
        : Colors.white;

    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.blueColor, width: 2),
        ),
        enabled: false,
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      hint: Text(
        selectedValue ?? '',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: AppTheme.blueColor,
            ),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: AppTheme.blueColor,
                      ),
                ),
              ))
          .toList(),
      onChanged: onChanged,
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.blueColor,
          ),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}

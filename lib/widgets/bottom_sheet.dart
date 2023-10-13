import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/l_d_mode.dart';
import '../providers/language.dart';

class BottomModelProvider extends StatelessWidget {
  static final TextEditingController titleController = TextEditingController();
  static final TextEditingController detailsController =
      TextEditingController();
  static final formKey = GlobalKey<FormState>();

  const BottomModelProvider({super.key});

  static void clearControllers() {
    titleController.clear();
    detailsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * (360 / 870),
      color: Colors.transparent,
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.add,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * (16 / 870)),
            TextFiild(
              hint: AppLocalizations.of(context)!.taskTitle,
              control: titleController,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * (16 / 870)),
            TextFiild(
              hint: AppLocalizations.of(context)!.taskDetails,
              control: detailsController,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * (16 / 870)),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  showDatePicker(
                    locale: languageProvider.appLocale,
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(
                      const Duration(days: 365),
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.time,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: themeProvider.mode == AppTheme.darkTheme
                            ? AppTheme.grayColor
                            : Colors.black45,
                      ),
                ),
              ),
            ),
            Text(
              DateFormat('y-M-d').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 18,
                    color: themeProvider.mode == AppTheme.darkTheme
                        ? AppTheme.grayColor
                        : Colors.black45,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TextFiild extends StatelessWidget {
  String hint;
  TextEditingController control = TextEditingController();
  TextFiild({super.key, required this.hint, required this.control});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color textColor = themeProvider.mode == AppTheme.darkTheme
        ? AppTheme.grayColor
        : Colors.black45;
    return TextFormField(
      style: Theme.of(context).textTheme.bodyMedium,
      controller: control,
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return AppLocalizations.of(context)!.requiredFieldError;
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor),
      ),
    );
  }
}

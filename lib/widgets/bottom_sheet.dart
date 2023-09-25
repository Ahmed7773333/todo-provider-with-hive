import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../app_theme.dart';
import '../providers/calender.dart';
import '../providers/l_d_mode.dart';
import '../providers/language.dart';

class BottomModelProvider extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void clearControllers() {
    titleController.clear();
    detailsController.clear();
  }

  Widget buildBottomSheet(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final calendarProvider = Provider.of<CalendarProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * (360 / 870),
      color: Colors.transparent,
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context,
                                void Function(void Function()) setState) =>
                            AlertDialog(
                          backgroundColor: themeProvider.isDarkMode
                              ? AppTheme.blackColor
                              : Colors.white,
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height *
                                (520 / 870),
                            width:
                                MediaQuery.of(context).size.width * (390 / 412),
                            child: Column(
                              children: [
                                TableCalendar(
                                  daysOfWeekHeight:
                                      MediaQuery.of(context).size.height *
                                          (28 / 870),
                                  firstDay: DateTime.utc(2010, 10, 16),
                                  lastDay: DateTime.utc(2030, 3, 14),
                                  availableGestures: AvailableGestures.all,
                                  headerStyle: const HeaderStyle(
                                      formatButtonVisible: false,
                                      titleCentered: true),
                                  selectedDayPredicate: (day) {
                                    return isSameDay(
                                        day, calendarProvider.focusedDay);
                                  },
                                  focusedDay: calendarProvider.focusedDay,
                                  locale:
                                      (languageProvider.appLocale).toString(),
                                  onDaySelected: (day, focusedDay) {
                                    setState(() =>
                                        calendarProvider.setFocusedDay(day));
                                  },
                                  onPageChanged: (focusedDay) {
                                    calendarProvider.setFocusedDay(focusedDay);
                                  },
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      (20 / 870),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.blueColor,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text('ok'),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.time,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: themeProvider.isDarkMode
                            ? AppTheme.grayColor
                            : Colors.black45,
                      ),
                ),
              ),
            ),
            Text(
              DateFormat('y-M-d').format(calendarProvider.focusedDay),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 18,
                    color: themeProvider.isDarkMode
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
  TextFiild({required this.hint, required this.control, super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color textColor =
        themeProvider.isDarkMode ? AppTheme.grayColor : Colors.black45;
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

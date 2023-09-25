import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../app_theme.dart';
import '../providers/database.dart';
import '../task.dart';
import '../widgets/back_ground.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/calender.dart';
import '../providers/l_d_mode.dart';
import '../providers/language.dart';

class TaskDetailsProvider extends ChangeNotifier {
  int _index = 0;
  int get currentIndex => _index;
  void setIndex(int index) {
    _index = index;

    notifyListeners();
  }

  final formKey2 = GlobalKey<FormState>();

  Widget buildEditScreen(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final calendarProvider = Provider.of<CalendarProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    String title = taskProvider.tasks[_index].title;
    String detail = taskProvider.tasks[_index].detail;
    final TextEditingController titleControl =
        TextEditingController(text: title);

    final TextEditingController detailControl =
        TextEditingController(text: detail);
    bool done = taskProvider.tasks[_index].done;
    calendarProvider.setFocusedDay(taskProvider.tasks[_index].time);
    Color cardColor =
        themeProvider.isDarkMode ? AppTheme.blackColor : AppTheme.lightColor;
    return Background(
      child: Padding(
        padding:
            EdgeInsets.all(MediaQuery.of(context).size.height * (12 / 870)),
        child: Card(
          color: cardColor,
          elevation: 18,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide()),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * (800 / 870),
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.edit,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * (16 / 870)),
                  TextFiild(
                    hint: AppLocalizations.of(context)!.taskTitle,
                    control: titleControl,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * (16 / 870)),
                  TextFiild(
                    hint: AppLocalizations.of(context)!.taskDetails,
                    control: detailControl,
                    lines: 10,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * (16 / 870)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                      void Function(void Function())
                                          setState) =>
                                  AlertDialog(
                                backgroundColor: themeProvider.isDarkMode
                                    ? AppTheme.blackColor
                                    : Colors.white,
                                content: SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      (520 / 870),
                                  width: MediaQuery.of(context).size.width *
                                      (390 / 412),
                                  child: Column(
                                    children: [
                                      TableCalendar(
                                        daysOfWeekHeight:
                                            MediaQuery.of(context).size.height *
                                                (28 / 870),
                                        firstDay: DateTime.utc(2010, 10, 16),
                                        lastDay: DateTime.utc(2030, 3, 14),
                                        availableGestures:
                                            AvailableGestures.all,
                                        headerStyle: const HeaderStyle(
                                            formatButtonVisible: false,
                                            titleCentered: true),
                                        selectedDayPredicate: (day) {
                                          return isSameDay(
                                              day, calendarProvider.focusedDay);
                                        },
                                        focusedDay: calendarProvider.focusedDay,
                                        locale: (languageProvider.appLocale)
                                            .toString(),
                                        onDaySelected: (day, focusedDay) {
                                          setState(() => calendarProvider
                                              .setFocusedDay(day));
                                        },
                                        onPageChanged: (focusedDay) {
                                          calendarProvider
                                              .setFocusedDay(focusedDay);
                                        },
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                : Colors.black45),
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('y-M-d').format(calendarProvider.focusedDay),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                        color: themeProvider.isDarkMode
                            ? AppTheme.grayColor
                            : Colors.black45),
                  ),
                  const Spacer(
                    flex: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.donee,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: AppTheme.greenColor),
                      ),
                      const Spacer(
                        flex: 5,
                      ),
                      InkWell(
                        onTap: () {
                          done
                              ? taskProvider.updateTask(
                                  _index,
                                  Task(
                                      title: title,
                                      detail: detail,
                                      time: calendarProvider.focusedDay,
                                      done: false))
                              : taskProvider.updateTask(
                                  _index,
                                  Task(
                                      title: title,
                                      detail: detail,
                                      time: calendarProvider.focusedDay,
                                      done: true));
                        },
                        child: Icon(
                          done
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color:
                              done ? AppTheme.greenColor : AppTheme.blueColor,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey2.currentState?.validate() ?? false) {
                        String titleTask = titleControl.text;
                        String detailTask = detailControl.text;
                        DateTime time = calendarProvider.focusedDay;
                        Task task = Task(
                            title: titleTask,
                            detail: detailTask,
                            time: time,
                            done: done);
                        taskProvider.updateTask(_index, task);
                        calendarProvider.setFocusedDay(DateTime.now());
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.save,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TextFiild extends StatelessWidget {
  String hint;
  int lines;

  TextEditingController control = TextEditingController();
  TextFiild(
      {required this.hint, this.lines = 1, required this.control, super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color textColor =
        themeProvider.isDarkMode ? AppTheme.grayColor : Colors.black45;
    return TextFormField(      style: Theme.of(context).textTheme.bodyMedium,

      controller: control,
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return AppLocalizations.of(context)!.requiredFieldError;
        }
        return null;
      },
      maxLines: lines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor),
      ),
    );
  }
}

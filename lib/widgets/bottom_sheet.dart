import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todoo_app/providers/bottom_sheet.dart';
import '../app_theme.dart';
import '../providers/l_d_mode.dart';
import '../providers/language.dart';

class AddTaskBottomSheet extends StatefulWidget {
  static final TextEditingController titleController = TextEditingController();
  static final TextEditingController detailsController =
      TextEditingController();
  static final formKey = GlobalKey<FormState>();

  const AddTaskBottomSheet({super.key});

  static void clearControllers() {
    titleController.clear();
    detailsController.clear();
  }

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  static DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final bottomSheetProvider = Provider.of<BottomSheetProvider>(context);

    return Container(
      width: 1.sw,
      height: 360.h,
      color: Colors.transparent,
      padding: const EdgeInsets.all(16).w,
      child: Form(
        key: AddTaskBottomSheet.formKey,
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
            SizedBox(height: 16.h),
            TextFiild(
              hint: AppLocalizations.of(context)!.taskTitle,
              control: AddTaskBottomSheet.titleController,
            ),
            SizedBox(height: 16.h),
            TextFiild(
              hint: AppLocalizations.of(context)!.taskDetails,
              control: AddTaskBottomSheet.detailsController,
            ),
            SizedBox(height: 16.h),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () async {
                  DateTime? chosenDate = await showDatePicker(
                      locale: languageProvider.appLocale,
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)));

                  if (chosenDate == null) return;
                  selectedDate = chosenDate;
                  bottomSheetProvider.setTime(selectedDate);
                  setState(() {});
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
              DateFormat('y-M-d').format(selectedDate),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 18.sp,
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

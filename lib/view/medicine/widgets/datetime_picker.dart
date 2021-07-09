import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/core.dart';

extension dateTime on DateTime {
  DateTime copywith({int? year, int? month, int? day, int? hour, int? minute}) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      this.second,
      this.millisecond,
      this.microsecond,
    );
  }
}

class DateTimePickerWidget extends StatelessWidget {
  final Function(DateTime newDateTime) onDateTimeSelected;
  final DateTime currentDateTime;
  const DateTimePickerWidget({
    required this.onDateTimeSelected,
    required this.currentDateTime,
  });

  @override
  Widget build(BuildContext context) {
    DateTime newDatetime;
    Future _selectDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentDateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        newDatetime = currentDateTime.copywith(
          day: picked.day,
          month: picked.month,
          year: picked.year,
        );
        onDateTimeSelected(newDatetime);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Expiration Date',
          style: AppTextStyles.body(
            fontWeight: FontWeight.bold,
            textColor: AppColors.black,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.kPrimaryColor),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(
                Icons.date_range_rounded,
                color: Theme.of(context).iconTheme.color,
                size: 25,
              ),
              TextButton(
                onPressed: () => _selectDate(),
                child: Text(
                  DateFormat.yMMMEd().format(currentDateTime),
                  style: AppTextStyles.inputStyle(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

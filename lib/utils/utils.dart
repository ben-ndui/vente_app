
import 'package:intl/intl.dart';

class Utils{

  static String toDateTime(DateTime dateTime){
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  static String toDate(DateTime dateTime){

    final date1 = DateFormat.yMMMEd('fr').format(dateTime).substring(0, 1).toUpperCase();
    final date2 = DateFormat.yMMMEd('fr').format(dateTime).substring(1, DateFormat.yMMMEd('fr').format(dateTime).length);
    final date = date1 + date2;

    return date;

  }

  static String toMonthAndYear(DateTime dateTime){

    final date1 = DateFormat.yMMM('fr').format(dateTime).substring(0, 1).toUpperCase();
    final date2 = DateFormat.yMMMEd('fr').format(dateTime).substring(1, DateFormat.yMMMEd('fr').format(dateTime).length);
    final date = date1 + date2;

    return date;

  }

  static String toTime(DateTime dateTime){
    final time = DateFormat.Hm().format(dateTime);

    return time;
  }

}
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class FunctionHelper {
  Future<String> formatedDate(timestamp) async {
    String result = "";
    await initializeDateFormatting();
    DateTime dateTime = DateTime.parse(timestamp);
    DateTime dateNow = DateTime.now();
    String year = DateFormat.y('id_ID').format(dateTime).toString();
    String yearNow = DateFormat.y('id_ID').format(dateNow).toString();
    String monthDay = DateFormat.MMMMd('id_ID').format(dateTime).toString();
    String monthDayNow = DateFormat.MMMMd('id_ID').format(dateNow).toString();
    if (monthDay == monthDayNow && year == yearNow) {
      result = DateFormat.Hm('id_ID').format(dateTime).toString();
    } else if (year == yearNow) {
      result = DateFormat.MMMMd('id_ID').format(dateTime).toString();
    } else {
      result = DateFormat.yMMMMd('id_ID').format(dateTime).toString();
    }
    return result;
  }
}

var functionHelper = FunctionHelper();

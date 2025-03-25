import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import '../data/models/contact_model.dart';
import 'package:path_provider/path_provider.dart';

class ExportHelper {
  static Future<File> exportToPdf(List<ContactModel> contacts) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return pw.Text('${contacts[index].name} - ${contacts[index].phone}');
        },
      );
    }));

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/contacts.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<File> exportToExcel(List<ContactModel> contacts) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Contacts'];

    sheetObject.appendRow(['Name', 'Phone', 'Email']);
    for (var contact in contacts) {
      sheetObject.appendRow([contact.name, contact.phone, contact.email]);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/contacts.xlsx');
    await file.writeAsBytes(excel.encode()!);
    return file;
  }
}

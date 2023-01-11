import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf_generator/shared/data.dart';
import 'package:pdf_generator/widgets/pdf_doc.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollbarTheme = ScrollbarThemeData(
      thumbVisibility: MaterialStateProperty.all(true),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(scrollbarTheme: scrollbarTheme),
      darkTheme: ThemeData.dark().copyWith(scrollbarTheme: scrollbarTheme),
      title: 'Flutter PDF Demo',
      home: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  PrintingInfo? printingInfo;
  PdfPageFormat? format;
  final _data = const CustomData();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter PDF Demo'),
      ),
      body: PdfPreview(
        canChangeOrientation: false,
        canDebug: false,
        //maxPageWidth: 700,
        build: (format) => generatePdfDoc(format, _data),
      ),
    );
  }
}

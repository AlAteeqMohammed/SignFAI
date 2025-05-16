import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/styles/colors.dart';

Widget buildButton(
        {double? height,
        double? width,
        double? fontSize,
        double? radius,
        required String text,
        required Color backgroundColor,
        required Color foregroundColor,
        required Color borderColor,
        required Function function}) =>
    ElevatedButton(
      style: OutlinedButton.styleFrom(
          elevation: 0,
          side: BorderSide(width: 2, color: borderColor),
          fixedSize: Size(width ?? 100, height ?? 45),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 10))),
      onPressed: () {
        function();
      },
      child: Text(text,
          style:
              TextStyle(fontSize: fontSize ?? 20, fontWeight: FontWeight.bold)),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String hint,
  required IconData prefix,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  String? Function(String?)? validate,
  bool isPassword = false,
  IconData? suffix,
  void Function()? suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        errorStyle: const TextStyle(height: 0.3),
        isDense: false,
        filled: true,
        fillColor: const Color.fromARGB(255, 228, 228, 228),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        hintText: hint,
        hintStyle:
            const TextStyle(color: thirdColor, fontWeight: FontWeight.w600),
        prefixIcon: Icon(
          prefix,
          color: thirdColor,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                  color: thirdColor,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: forthColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: forthColor,
            width: 2.0,
          ),
        ),
      ),
    );

Widget defaultDropdownButton(
        {double? height,
        double? width,
        double? fontSize,
        double? radius,
        required BuildContext context,
        required String? choice,
        required String label,
        required List<String> list,
        required Function(String?)? onChange}) =>
    Theme(
      data: Theme.of(context).copyWith(),
      child: Container(
          height: height ?? 40,
          width: width ?? 105,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius ?? 7),
              border: Border.all(
                  color: thirdColor, width: 1.5, style: BorderStyle.solid)),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
            isExpanded: true,
            hint: Text(label),
            style: TextStyle(
              fontFamily: GoogleFonts.openSans().fontFamily,
              color: Colors.black,
              fontSize: fontSize ?? 14,
            ),
            iconEnabledColor: thirdColor,
            icon: const Icon(
              Icons.arrow_drop_down,
            ),
            items: list
                .map((v) => DropdownMenuItem(
                      value: v,
                      child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            v,
                            textAlign: TextAlign.center,
                          )),
                    ))
                .toList(),
            onChanged: onChange,
            value: choice,
          ))),
    );

Widget defaultChoiceChip(
        {required double width,
        required String label,
        required variable,
        required Function(bool)? onSelected}) =>
    ChoiceChip(
        label: SizedBox(
          width: width,
          height: 40,
          child: Center(
            child: Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
        selected: variable == label,
        onSelected: onSelected,
        selectedColor: primaryColor,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)));

void showSnackBar({
  required BuildContext context,
  required String message,
  required int duration,
  IconData? icon,
}) {
  final snackBar = SnackBar(
    duration: Duration(seconds: duration),
    content: Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Flexible
        (child: Text(message))
      ],
    ),
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

circularProgress(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
              strokeWidth: 8, backgroundColor: thirdColor, color: primaryColor),
        );
      });
}

Future<String?> locationDialog(BuildContext context) async {
  String? location;
  await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
              title: const Text("أدخل رقم المركز", textAlign: TextAlign.center),
              titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              content: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.black87,
                          width: 1.2,
                          style: BorderStyle.solid)),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    isExpanded: true,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    hint: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "اختر المركز",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    iconEnabledColor: primaryColor,
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    items: ['300', '320', '350', '360', '370', '380', '390']
                        .map((v) => DropdownMenuItem(
                              value: v,
                              child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    v,
                                    textAlign: TextAlign.center,
                                  )),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        location = val.toString();
                      });
                    },
                    value: location,
                  ))),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButtonTheme(
                        data: ElevatedButtonThemeData(
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.resolveWith<OutlinedBorder>(
                                    (_) {
                              return const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)));
                            }),
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            location = null;
                            Navigator.pop(context);
                          },
                          child: const Text('إلغاء',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        )),
                    ElevatedButtonTheme(
                        data: ElevatedButtonThemeData(
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.resolveWith<OutlinedBorder>(
                                    (_) {
                              return const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)));
                            }),
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('موافق',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        )),
                  ],
                ),
              ]);
        });
      });
  return location;
}

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

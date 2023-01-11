import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

import '../../flutter_zxing.dart';

/// Widget to create a code from a text and barcode format
class WriterWidgetBinary extends StatefulWidget {
  const WriterWidgetBinary({
    super.key,
    this.text,
    this.format = Format.aztec,
    this.height = 120, // Width is calculated from height and format ratio
    this.margin = 0,
    this.eccLevel = EccLevel.low,
    this.messages = const Messages(),
    this.onSuccess,
    this.onError,
  });

  final String? text;
  final int format;
  final int height;
  final int margin;
  final EccLevel eccLevel;
  final Messages messages;
  final Function(Encode result, Uint8List? bytes)? onSuccess;
  final Function(String error)? onError;

  @override
  State<WriterWidgetBinary> createState() => _WriterWidgetBinaryState();
}

class _WriterWidgetBinaryState extends State<WriterWidgetBinary>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _marginController = TextEditingController();

  bool isAndroid() => Theme.of(context).platform == TargetPlatform.android;

  final List<int> _supportedFormats = CodeFormat.supportedEncodeFormats;

  int _codeFormat = Format.qrCode;
  EccLevel _eccLevel = EccLevel.low;

  Messages get messages => widget.messages;
  Map<EccLevel, String> get _eccTitlesMap => <EccLevel, String>{
        EccLevel.low: messages.lowEccLevel,
        EccLevel.medium: messages.mediumEccLevel,
        EccLevel.quartile: messages.quartileEccLevel,
        EccLevel.high: messages.highEccLevel,
      };

  @override
  void initState() {
    _codeFormat = widget.format;
    _eccLevel = widget.eccLevel;
    _textController.text = widget.text ?? _codeFormat.demoText;
    _widthController.text =
        (widget.height * _codeFormat.ratio).round().toString();
    _heightController.text = widget.height.toString();
    _marginController.text = widget.margin.toString();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _marginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const SizedBox(height: 20),
              // Input multiline text
              TextFormField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: _codeFormat.maxTextLength,
                onChanged: (String value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  labelText: messages.textLabel,
                  counterText:
                      '${_textController.value.text.length} / ${_codeFormat.maxTextLength}',
                ),
                validator: (String? value) {
                  if (value?.isEmpty ?? false) {
                    return messages.invalidText;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Format DropDown button
              Row(
                children: <Widget>[
                  Flexible(
                    child: DropdownButtonFormField<int>(
                      value: _codeFormat,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        filled: true,
                        labelText: messages.formatLabel,
                      ),
                      items: _supportedFormats
                          .map((int format) => DropdownMenuItem<int>(
                                value: format,
                                child: Text(zx.barcodeFormatName(format)),
                              ))
                          .toList(),
                      onChanged: (int? format) {
                        setState(() {
                          _codeFormat = format ?? Format.qrCode;
                          _textController.text = _codeFormat.demoText;
                          _heightController.text = widget.height.toString();
                          _widthController.text =
                              (widget.height * _codeFormat.ratio)
                                  .round()
                                  .toString();
                        });
                      },
                    ),
                  ),
                  if (_codeFormat.isSupportedEccLevel) ...<Widget>[
                    const SizedBox(width: 10),
                    Flexible(
                      child: DropdownButtonFormField<EccLevel>(
                        value: _eccLevel,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          filled: true,
                          labelText: messages.eccLevelLabel,
                        ),
                        items: _eccTitlesMap.entries
                            .map((MapEntry<EccLevel, String> entry) =>
                                DropdownMenuItem<EccLevel>(
                                  value: entry.key,
                                  child: Text(entry.value),
                                ))
                            .toList(),
                        onChanged: (EccLevel? ecc) {
                          setState(() {
                            _eccLevel = ecc ?? EccLevel.low;
                          });
                        },
                      ),
                    ),
                  ]
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      controller: _widthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: messages.widthLabel,
                      ),
                      validator: (String? value) {
                        final int? width = int.tryParse(value ?? '');
                        if (width == null) {
                          return messages.invalidWidth;
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        // use format ratio to calculate height
                        final int? width = int.tryParse(value);
                        if (width != null) {
                          final int height =
                              (width / _codeFormat.ratio).round();
                          _heightController.text = height.toString();
                        }
                      },
                    ),
                  ),
                  // const SizedBox(width: 8),
                  Flexible(
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: messages.heightLabel,
                      ),
                      validator: (String? value) {
                        final int? width = int.tryParse(value ?? '');
                        if (width == null) {
                          return messages.invalidHeight;
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        // use format ratio to calculate width
                        final int? height = int.tryParse(value);
                        if (height != null) {
                          final int width =
                              (height * _codeFormat.ratio).round();
                          _widthController.text = width.toString();
                        }
                      },
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _marginController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: messages.marginLabel,
                      ),
                      validator: (String? value) {
                        final int? width = int.tryParse(value ?? '');
                        if (width == null) {
                          return messages.invalidMargin;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Write button
              ElevatedButton(
                onPressed: createBarcodeBinary,
                child: Text(messages.createButton),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  String base64BinaryString(String string, {Allocator allocator = malloc}) {
    final units = base64Url.decode(base64Url.normalize(string));
    final Pointer<Uint8> result = allocator<Uint8>(units.length);
    final Uint8List base64Bytes = result.asTypedList(units.length);

    base64Bytes.setAll(0, units);

    debugPrint("base64BinaryString: " + base64Bytes.toString());
    return base64Bytes.toString();
  }

  void createBarcodeBinary() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      FocusScope.of(context).unfocus();
      final String text = _textController.value.text;
      final int width = int.parse(_widthController.value.text);
      final int height = int.parse(_heightController.value.text);
      final int margin = int.parse(_marginController.value.text);
      final EccLevel ecc = _eccLevel;
      final Encode result = zx.encodeBarcodeBinary(
        //contents: base64BinaryString(text),
        /*contents: base64BinaryString(
            "eNplkj-IE0EUxomW_gEFJYdwHhaC4CazMzvZZG1uD2PheSJEMBeRY-btJDcm2V12JktULHIWJxY2J1hvlFhdc7axsbCxExtLa73mGsXKSYgnXIaZx_B9vPd-b5ghi9ePjZ_VP74D1mmJag3TEoh-HGOEMaKI3kVlRB3aAMn0P9H5L8qAYxfaMuiLTa1j5RWLOmGhknqzx612ainNWjJsFVLW6-gCe9xLRCEUutgWj1SRR9ySSvVEYinZCkVSdB0BlNPAISXmoDKp2JzaFAMnLiHYRdCVKStByJtzMOu5vczADEYBbHSD5xnEgRr08yXsYkKA2dxxnSZ3OUNB4Ajb-J1QqNSqVTNosuQNsK5eONsF6CVQq65CyvRC7kIGOobBEIBpxsDMlssgSSXcsa8by8w9axBUSMUlUKaYceHYNghjR3KOMgMVpXOqQdbQv4mJt2SOEpMOwqtgunR5Kugo9u67DposYl-d3Sh9YPzlo8WKhs0UTLu5SQynUeeC2LzKEDqiNRgBS5J-fpJnIWpNMz3b9RAqmKoNCER81J3smRtGepv7Pver3L_N_Xu8eovfWOGraxDFAohNQOl4Sx7SykNaUCmAGQpikE1lfkVH1Je39lH9bbb9BL59dd_v_1g8dXHn05_PGwcPn77YOf_r4PiHc7X8q73Xl37j0e7aeDF7yU-fvPbzy-74SiM5c-K7z9IVZv8FdrvqmQ"),
        */
        /* contents: base64BinaryString(
            "eNplks9rE0EUx11FPNiLPbVVJOCvi5vdndkfyR5KUxsPpoqQgm20yMzbSTIk2R12JkvqQYhFKngTRBA8JErtxYvgzZOeBD34Dwj-AR70IHpzEtqIZph5DN8v773PG2ZIxMbht9vr714CaTdYuYo8H1hPCGQjZBcdd81BKMCoBpyoAxH_FXlEUQAtHvVYUykhQ8tSKYklV80uNVuZKRVp8LiRz0i3rfLkTjdl-Zgpq8W2pEUTanIpuyw1JW_ELLUCl4FHvcjFPnHtAi461HM8BBQHGKPAhg7PiA8xrU_BbBivBxqmvxvB7U70YAAikv3enI-RHQSIFj3fRj6rM9_Xkke1346ZzMxqeQB1kj4H0lHzsx2AbgrVcgUyouaNkwNQAvpDAKIIAT2bMYA043DdWdGWnnu_AXYDgj0H6prc9QsFSrSd8CnKAcgkm1I1soLeFYTDnD6SjTqwsOh7ufNjQSUivBm49ng5F_dv2NnU_tL_xSzNpgtmHWMU43FURiT0qwyhzRr9XSBp2psb5Zl20XS8NScIbb3tvK5ag4iJf10_9LyJGydqh5ZKtFSmpWu0dIOWV-nlZVq5ColggB0MUol7fELLJ7QgMwA9FAjgdal_RZutL114unXm0MytyjfjyfvC6ulL21_foLu_jx5bPL73-cSjc8bDnbPoR-7U9xc_P26-uv_h8ZfawrNPTWtmce_Ir9mVBYtky8T5Ayal470"),

        */
        contents: base64BinaryString(
            "eNptUj1oFEEYJdHSTpGkUI4YrLJ3OzszO7uHQi7mRIyKJEHzg8rMt7OXJXe7y87cclp5GDDaKIhYyp2YWFlZWalglUYFmxR2EkVIYWfnXExOMA7Mx8d7fN97b5guT-cPHL0z924deL0mqzMOdUG20tSxHQchB88iQojtLUDE9R7o_AWjQDgMlqOgJZe0TlW5VNIZj1Wkl5rCWs4tpXktimvFnDfrushvNTNZjKUuLcubqiQSYUVKNWVmqagWy6zEiAQqaECwy40C9pGgiDogMMPYYTY0opy7EItwn5n5wUMdY6a9FsCNRnCvA2mg2q0hFzOQtsOYZNIloe-6HiZAqeHrsVS5NVPtQMizZ8Abenh0E6CZwUx1CnKuhwfdDugU2l0ArjkHk22gA1kewWU0aSiTe1cAe2A0XOQjH3uYUd8zdBLtc9kBleT_QXUWtUYZER5BzLE8l4BFREgtQSSxOA2l5wgPMRmadBpa1x1cLpirZM-MLPsIFU7uADpJy4uM2DuHjv3pKPX7nTu2x6JrZmZ81wuZtQlFtr1QMtGMSN4Y6NV4p-qBIDWP2oW6rLXXhQY4P10FnmWtod64hZDVW0DLxCvbdtHsXoBApv-yCPXZONF3RaUiKlVRuSQqV0X1gjg7IaYuQpJKwAiD0ulK1A8S9YP0O7fPIlA5gHkDSCEKlflvdTk3_vbTo--Hz9x_-u1N8uXcldXFx2vTW2sfJuY2R1Ze_Tj48_Sx1eNfX24X9O2Rh6-3Jx_8KrwovP_YfXJqgz3_vHXkxAbPJzj6DczbAps"),

        params: EncodeParams(
          format: _codeFormat,
          width: width,
          height: height,
          margin: margin,
          eccLevel: ecc,
        ),
      );
      String? error;
      if (result.isValid && result.data != null) {
        try {
          final imglib.Image img = imglib.Image.fromBytes(
            width,
            height,
            result.data!,
          );
          final Uint8List encodedBytes = Uint8List.fromList(
            imglib.encodeJpg(img),
          );
          widget.onSuccess?.call(result, encodedBytes);
        } catch (e) {
          error = e.toString();
        }
      } else {
        error = result.error;
      }
      if (error != null) {
        widget.onError?.call(error);
      }
    }
  }
}

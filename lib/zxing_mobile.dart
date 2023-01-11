import 'dart:typed_data';

import 'package:camera/camera.dart';

import 'flutter_zxing.dart';
import 'src/logic/zxing.dart';

export 'generated_bindings.dart';
export 'src/logic/zxing.dart';
export 'src/models/models.dart';
export 'src/utils/extentions.dart';
export 'src/utils/image_converter.dart';

Zxing getZxing() => ZxingMobile();

class ZxingMobile implements Zxing {
  ZxingMobile();

  @override
  String version() => zxingVersion();

  @override
  void setLogEnabled(bool enabled) => setZxingLogEnabled(enabled);

  @override
  String barcodeFormatName(int format) => zxingBarcodeFormatName(format);

  @override
  Encode encodeBarcode({
    required String contents,
    required EncodeParams params,
  }) =>
      zxingEncodeBarcode(contents: contents, params: params);

  @override
  Encode encodeBarcodeBinary({
    required String contents,
    required EncodeParams params,
  }) =>
      zxingEncodeBarcodeBinary(contents: contents, params: params);

  @override
  Future<void> startCameraProcessing() => zxingStartCameraProcessing();

  @override
  void stopCameraProcessing() => zxingStopCameraProcessing();

  @override
  Future<Code> processCameraImage(
    CameraImage image, {
    DecodeParams? params,
  }) =>
      zxingProcessCameraImage(image, params: params);

  @override
  Future<Code?> readBarcodeImagePathString(
    String path, {
    DecodeParams? params,
  }) =>
      zxingReadBarcodeImagePathString(path, params: params);

  @override
  Future<Code?> readBarcodeImagePath(
    XFile path, {
    DecodeParams? params,
  }) =>
      zxingReadBarcodeImagePath(path, params: params);

  @override
  Future<Code?> readBarcodeImageUrl(
    String url, {
    DecodeParams? params,
  }) =>
      zxingReadBarcodeImageUrl(url, params: params);

  @override
  Code readBarcode(
    Uint8List bytes, {
    required int width,
    required int height,
    DecodeParams? params,
  }) =>
      zxingReadBarcode(bytes, width: width, height: height, params: params);

  @override
  Future<List<Code>> readBarcodesImagePathString(
    String path, {
    DecodeParams? params,
  }) =>
      zxingReadBarcodesImagePathString(path, params: params);

  @override
  Future<List<Code>> readBarcodesImagePath(
    XFile path, {
    DecodeParams? params,
  }) =>
      zxingReadBarcodesImagePath(path, params: params);

  @override
  Future<List<Code>> readBarcodesImageUrl(
    String url, {
    DecodeParams? params,
  }) =>
      zxingReadBarcodesImageUrl(url, params: params);

  @override
  List<Code> readBarcodes(
    Uint8List bytes, {
    required int width,
    required int height,
    DecodeParams? params,
  }) =>
      zxingReadBarcodes(bytes, width: width, height: height, params: params);
}

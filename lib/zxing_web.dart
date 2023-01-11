import 'dart:typed_data';

import 'package:camera/camera.dart';

import 'flutter_zxing.dart';

Zxing getZxing() => ZxingWeb();

class ZxingWeb implements Zxing {
  ZxingWeb();

  @override
  String version() => 'Unsupported';

  @override
  void setLogEnabled(bool enabled) {}

  @override
  String barcodeFormatName(int format) => 'Unsupported';

  @override
  Encode encodeBarcodeBinary({
    required String contents,
    required EncodeParams params,
  }) =>
      throw UnimplementedError();

  @override
  Encode encodeBarcode({
    required String contents,
    required EncodeParams params,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> startCameraProcessing() => throw UnimplementedError();

  @override
  void stopCameraProcessing() => throw UnimplementedError();

  @override
  Future<Code> processCameraImage(
    CameraImage image, {
    DecodeParams? params,
  }) =>
      throw UnimplementedError();

  @override
  Future<Code?> readBarcodeImagePathString(
    String path, {
    DecodeParams? params,
  }) =>
      throw UnimplementedError();

  @override
  Future<Code?> readBarcodeImagePath(
    XFile path, {
    DecodeParams? params,
  }) =>
      throw UnimplementedError();

  @override
  Future<Code?> readBarcodeImageUrl(
    String url, {
    DecodeParams? params,
  }) =>
      throw UnimplementedError();

  @override
  Code readBarcode(
    Uint8List bytes, {
    required int width,
    required int height,
    DecodeParams? params,
  }) =>
      throw UnimplementedError();

  @override
  Future<List<Code>> readBarcodesImagePathString(
    String path, {
    DecodeParams? params,
  }) =>
      throw UnimplementedError();

  @override
  Future<List<Code>> readBarcodesImagePath(
    XFile path, {
    DecodeParams? params,
  }) =>
      throw UnimplementedError();

  @override
  Future<List<Code>> readBarcodesImageUrl(
    String url, {
    DecodeParams? params,
  }) =>
      throw UnimplementedError();

  @override
  List<Code> readBarcodes(
    Uint8List bytes, {
    required int width,
    required int height,
    DecodeParams? params,
  }) =>
      throw UnimplementedError();
}

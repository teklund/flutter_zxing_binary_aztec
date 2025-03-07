# Changelog

## 1.0.0-beta.2

* minor improvements

## 1.0.0-beta.1

* Updated zxing-cpp to v2.0.0
* Added support for macOS, Linux, and Windows
* Added support for micro QR codes
* Zxing-cpp is now included as a submodule instead of a deep copy

## 0.10.0

* added `EncodeParams`
* replaced `int` type with `EccLevel` enum for error correction level
* added `ratio`, `maxTextLength`, and `isSupportedEccLevel` to Format for encoding barcodes
* renamed `Params` to `DecodeParams`
* fixed issue where images were being inverted when using `zx` methods

## 0.9.1

* fixed memory leaks

## 0.9.0

Breaking changes

* fixed compilation errors on web
* added 'Params' class for using one parameters instead of many
* use 'zx' prefix for all functions

## 0.8.5

* added 'tryInverted' and 'tryHarder' parameters to the `ReaderWidget`

## 0.8.4

* added 'bytes' parameter content without any modifications to the scan result

## 0.8.3

* bug fixes

## 0.8.2

* bug fixes

## 0.8.1

* bug fixes
  
## 0.8.0

* added ability to set localization messages for `writer_widget`
* fixed bug where iOS crashes when creating a new barcode

## 0.7.4

* updated readme

## 0.7.3

* encodeBarcode method now uses the named parameters instead of positional parameters

## 0.7.2

* fixed case sensitive folder name issue in CMakeLists.txt (thanks to [@softkot](https://github.com/softkot))

## 0.7.1

* updated dependencies to the latest version

## 0.7.0

* added barcode result point detection
* added tryHarder and tryRotate arguments to the readers

## 0.6.0

* updated zxing-cpp to v1.4.0

## 0.5.0

* fixed Chinese support for iOS (thanks to [@aqiu202](https://github.com/aqiu202))

## 0.4.0

Breaking changes

* removed `FlutterZxing` class, call all methods directly
* added read multiple barcodes methods

## 0.3.2

* fixed enabling/disabling of the logger

## 0.3.1

* fixed Chinese support

## 0.3.0

* added processCameraImage function
* added pinch to zoom sopport
* added flash sopport
* added custom scanner overlay support

## 0.2.0

* added 'readImagePath' function
* added 'readImagePathString' function
* added 'readImageUrl' function

## 0.1.3

* minor improvements

## 0.1.2

* minor fixes for analyzer options

## 0.1.1

* renamed 'ZxingReaderWidget' to 'ReaderWidget'
* renamed 'ZxingWriterWidget' to 'WriterWidget'

## 0.1.0

* renamed 'zxingRead' to 'readBarcode'
* renamed 'zxingEncode' to 'encodeBarcode'
* updated example project

## 0.0.2

* added ability to set the code format for reader

## 0.0.1

* Initial barcode scanner release.

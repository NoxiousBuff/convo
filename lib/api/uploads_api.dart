import 'dart:developer';
import 'package:flutter/cupertino.dart';

abstract class UploadsAPI extends ChangeNotifier {
  /// Total number of byte Data
  int get totalBytesData;

  /// get the total bytes transffering of files
  int get bytesProgress;

  /// total number bytes tranffered
  int get transfferingBytes;

  /// show the total number of bytes transffered
  int get tranfferedBytes;

  /// get the transffered byteData
  void getTransfferingBytes(int bytes);

  /// get the total number of bytes transfferes
  void getTransfferedBytes(int bytes);

  /// get the total byte data
  void getTotalByteData(int byteData);

  /// remove the all bytes which was get
  void clearAllBytes();
}

class UploadsAPIImplimentation extends UploadsAPI {
  /// Total number of byte Data
  int _totalBytesData = 0;

  /// get the total progress of bytes transffering
  final int _bytesProgress = 0;

  /// get the number of bytes currently transffering
  int _transfferingBytes = 0;

  /// get the total number of bytes transffered
  int _tranfferedBytes = 0;

  @override
  int get totalBytesData => _totalBytesData;

  @override
  int get bytesProgress => _bytesProgress;

  @override
  int get transfferingBytes => _transfferingBytes;

  @override
  int get tranfferedBytes => _tranfferedBytes;

  @override
  void getTransfferingBytes(int bytes) {
    _transfferingBytes = bytes;
    notifyListeners();
    log('TransfferingBytes:$_transfferingBytes');
  }

  @override
  void getTransfferedBytes(int bytes) {
    _tranfferedBytes = bytes;
    notifyListeners();
    log('TransfferedBytes:$_tranfferedBytes');
  }

  @override
  void getTotalByteData(int byteData) {
    _totalBytesData = byteData;
    notifyListeners();
    log('TotalBytesData:$_totalBytesData');
  }

  @override
  void clearAllBytes() {
    _totalBytesData = 0;
    _tranfferedBytes = 0;
    _transfferingBytes = 0;
    notifyListeners();
    log('clear all bytes');
  }
}

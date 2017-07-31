import React, { Component } from 'react';
import {
  NativeModules,
  DeviceEventEmitter,
  Platform,
  NativeAppEventEmitter
} from 'react-native';
const CPSDK = Platform.OS === 'ios'?NativeModules.ChinaPay:NativeModules.YinlianPayModule;
module.exports = CPSDK;
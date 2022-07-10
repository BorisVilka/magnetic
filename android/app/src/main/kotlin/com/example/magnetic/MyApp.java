package com.example.magnetic;

import com.wonderpush.sdk.flutter.WonderPushPlugin;

import io.flutter.app.FlutterApplication;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class MyApp extends FlutterApplication {

    @Override
    public void onCreate() {
        WonderPushPlugin.getInstance().subscribeToNotifications();
        WonderPushPlugin.setupWonderPushDelegate();
        super.onCreate();
    }
}

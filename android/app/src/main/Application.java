package com.example.smartgarden; // Replace with your actual package name

import android.content.Context;
import androidx.multidex.MultiDex;

import io.flutter.app.FlutterApplication;

public class Application extends FlutterApplication {
    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }
}

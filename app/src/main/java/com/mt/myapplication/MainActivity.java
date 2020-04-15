package com.mt.myapplication;

import androidx.appcompat.app.AppCompatActivity;
import io.flutter.embedding.android.FlutterFragment;

import android.os.Bundle;

public class MainActivity extends AppCompatActivity {

    private FlutterFragment flutterFragment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        flutterFragment = new FlutterFragment.NewEngineFragmentBuilder().initialRoute("route_contact").build();
        getSupportFragmentManager().beginTransaction().replace(R.id.content, flutterFragment).commit();
    }
}

package com.mt.myapplication;

import androidx.appcompat.app.AppCompatActivity;
import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.android.FlutterView;

import com.mt.myapplication.FlutterPlugin;
import android.os.Bundle;

public class MainActivity extends AppCompatActivity {

    private FlutterFragment flutterFragment;
    protected FlutterPlugin plugin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        flutterFragment = new FlutterFragment.NewEngineFragmentBuilder().initialRoute("route_contact").build();
        getSupportFragmentManager().beginTransaction().replace(R.id.content, flutterFragment).commit();

        FlutterFragment flutterFragment2 = new FlutterFragment.NewEngineFragmentBuilder().initialRoute("route_flutter").build();
        getSupportFragmentManager().beginTransaction().replace(R.id.flutter_2, flutterFragment2).commit();
    }

    @Override
    protected void onResume() {
        super.onResume();
        plugin = FlutterPlugin.registerPlugin(flutterFragment);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        plugin.unregisterListener();
    }
}

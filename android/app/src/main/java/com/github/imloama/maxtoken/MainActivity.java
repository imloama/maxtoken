package com.github.imloama.maxtoken;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity implements KeystoreStorage{
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    WalletManager.storage = this;
    WalletManager.scanWallets();
  }

   public File getKeystoreDir() {
        return this.getFilesDir();
    }

}

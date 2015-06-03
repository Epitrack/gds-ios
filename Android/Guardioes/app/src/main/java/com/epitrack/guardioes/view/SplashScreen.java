package com.epitrack.guardioes.view.view;

import android.os.Bundle;
import android.view.View;

import com.epitrack.guardioes.R;

public class SplashScreen extends BaseActivity {

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.splash_screen);
    }

    public void onEnter(final View view) {
        navigateTo(LoginScreen.class);
    }
}

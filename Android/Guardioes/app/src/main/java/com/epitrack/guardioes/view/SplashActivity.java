package com.epitrack.guardioes.view;

import android.os.Bundle;
import android.view.View;

import com.epitrack.guardioes.R;

public class SplashActivity extends BaseActivity {

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.splash_activity);
    }

    public void onEnter(final View view) {
        navigateTo(LoginActivity.class);
    }
}

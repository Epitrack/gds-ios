package com.epitrack.guardioes.view.view;

import android.os.Bundle;
import android.view.View;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.view.BaseActivity;
import com.epitrack.guardioes.view.view.CreateAccountScreen;

public class LoginScreen extends BaseActivity {

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.login_screen);

    }

    public void navigateToCreateAccount(final View view) {
        navigateTo(CreateAccountScreen.class);
    }
}

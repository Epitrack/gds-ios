package com.epitrack.guardioes.view;

import android.os.Bundle;
import android.view.View;

import com.epitrack.guardioes.R;

public class LoginActivity extends BaseActivity {

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.login_activity);

    }

    public void navigateToCreateAccount(final View view) {
        navigateTo(CreateAccountActivity.class);
    }

    public void navigateToMainScreen(final View view) {
        navigateTo(MainActivity.class);
    }
}

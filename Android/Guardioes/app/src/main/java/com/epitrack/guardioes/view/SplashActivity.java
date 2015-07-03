package com.epitrack.guardioes.view;

import android.content.Intent;
import android.os.Bundle;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.manager.PrefManager;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.view.account.CreateAccountActivity;

import butterknife.ButterKnife;
import butterknife.OnClick;

public class SplashActivity extends BaseActivity {

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        if (new PrefManager(this).get(Constants.Pref.USER) == null) {
            setContentView(R.layout.splash_activity);

            ButterKnife.inject(this);

        } else {

            navigateTo(MainActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                           Intent.FLAG_ACTIVITY_NEW_TASK);
        }
    }

    @OnClick(R.id.splash_activity_button_enter)
    public void onEnter() {
        navigateTo(CreateAccountActivity.class);
    }
}

package com.epitrack.guardioes.view;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.manager.PrefManager;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.view.survey.SelectParticipantActivity;
import com.epitrack.guardioes.view.survey.StateActivity;
import com.epitrack.guardioes.view.survey.SymptomActivity;

public class SplashActivity extends BaseActivity implements Runnable {

    private static final long WAIT_TIME = 1500;

    private final Handler handler = new Handler();

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.splash_activity);

        handler.postDelayed(this, WAIT_TIME);
    }

    @Override
    protected void onPause() {
        super.onPause();

        handler.removeCallbacks(this);
    }

    @Override
    public void run() {

        if (new PrefManager(this).get(Constants.Pref.USER) == null) {
            navigateTo(SymptomActivity.class);

        } else {

            navigateTo(MainActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                           Intent.FLAG_ACTIVITY_NEW_TASK);
        }
    }
}

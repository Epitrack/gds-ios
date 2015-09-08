package com.epitrack.guardioes.view;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.manager.PrefManager;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.view.base.BaseActivity;
import com.epitrack.guardioes.view.welcome.WelcomeActivity;

/**
 * @author Igor Morais
 */
public class SplashActivity extends BaseActivity implements Runnable {

    private static final long WAIT_TIME = 1500;

    private final Handler handler = new Handler();

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.splash);

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
            navigateTo(WelcomeActivity.class);

        } else {

            navigateTo(HomeActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                           Intent.FLAG_ACTIVITY_NEW_TASK);
        }
    }
}

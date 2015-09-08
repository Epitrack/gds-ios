package com.epitrack.guardioes.view.base;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;

import com.epitrack.guardioes.view.Navigate;
import com.epitrack.guardioes.view.ViewListener;
import com.facebook.appevents.AppEventsLogger;

import butterknife.ButterKnife;

/**
 * @author Igor Morais
 */
public class BaseActivity extends Activity implements ViewListener, Navigate {

    @Override
    protected void onResume() {
        super.onResume();

        AppEventsLogger.activateApp(this);
    }

    @Override
    protected void onPause() {
        super.onPause();

        AppEventsLogger.deactivateApp(this);
    }

    @Override
    public void setContentView(final int layout) {
        super.setContentView(layout);

        onSetContentView();
    }

    @Override
    public void setContentView(final View view) {
        super.setContentView(view);

        onSetContentView();
    }

    @Override
    public void setContentView(final View view, final ViewGroup.LayoutParams layoutParam) {
        super.setContentView(view, layoutParam);

        onSetContentView();
    }

    @Override
    public void onSetContentView() {
        ButterKnife.bind(this);
    }

    @Override
    public void navigateTo(final Class<? extends Activity> activityClass) {
        startActivity(new Intent(this, activityClass));
    }

    @Override
    public void navigateTo(final Class<? extends Activity> activityClass, final int flags) {

        final Intent intent = new Intent(this, activityClass);
        intent.setFlags(flags);

        startActivity(intent);
    }

    @Override
    public void navigateTo(final Class<? extends Activity> activityClass, final Bundle bundle) {

        final Intent intent = new Intent(this, activityClass);
        intent.putExtras(bundle);

        startActivity(intent);
    }

    @Override
    public void navigateTo(final Class<? extends Activity> activityClass, final int flags, final Bundle bundle) {

        final Intent intent = new Intent(this, activityClass);
        intent.setFlags(flags);
        intent.putExtras(bundle);

        startActivity(intent);
    }

    @Override
    public void navigateForResult(final Class<? extends Activity> activityClass, final int requestCode) {
        startActivityForResult(new Intent(this, activityClass), requestCode);
    }

    @Override
    public void navigateForResult(final Class<? extends Activity> activityClass, final int requestCode,
                                  final int flags) {

        final Intent intent = new Intent(this, activityClass);
        intent.setFlags(flags);

        startActivityForResult(intent, requestCode);
    }

    @Override
    public void navigateForResult(final Class<? extends Activity> activityClass, final int requestCode,
                                  final Bundle bundle) {

        final Intent intent = new Intent(this, activityClass);
        intent.putExtras(bundle);

        startActivityForResult(intent, requestCode);
    }

    @Override
    public void navigateForResult(final Class<? extends Activity> activityClass, final int requestCode,
                                  final int flags, final Bundle bundle) {

        final Intent intent = new Intent(this, activityClass);
        intent.setFlags(flags);
        intent.putExtras(bundle);

        startActivityForResult(intent, requestCode);
    }
}

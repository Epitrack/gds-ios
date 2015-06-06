package com.epitrack.guardioes.view;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.ViewPager;
import android.view.View;

import com.epitrack.guardioes.R;
import com.viewpagerindicator.CirclePageIndicator;

import butterknife.ButterKnife;
import butterknife.InjectView;

public class WelcomeActivity extends FragmentActivity {

    @InjectView(R.id.welcome_activity_view_pager_indicator)
    CirclePageIndicator pageIndicator;

    @InjectView(R.id.welcome_activity_view_pager)
    ViewPager viewPager;

    @Override
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.welcome_activity);

        ButterKnife.inject(this);

        viewPager.setAdapter(new WelcomePagerAdapter(getSupportFragmentManager(), this));

        pageIndicator.setViewPager(viewPager);
    }

    public void onRegister(final View view) {
        startActivity(new Intent(this, CreateAccountActivity.class));
    }

    public void onEnter(final View view) {
        startActivity(new Intent(this, LoginActivity.class));
    }
}

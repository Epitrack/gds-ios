package com.epitrack.guardioes.view.welcome;

import android.os.Bundle;
import android.support.v4.view.ViewPager;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseFragmentActivity;
import com.epitrack.guardioes.view.account.CreateAccountActivity;
import com.epitrack.guardioes.view.account.LoginActivity;
import com.viewpagerindicator.CirclePageIndicator;

import butterknife.Bind;
import butterknife.OnClick;

/**
 * @author Igor Morais
 */
public class WelcomeActivity extends BaseFragmentActivity {

    @Bind(R.id.page_indicator)
    CirclePageIndicator pageIndicator;

    @Bind(R.id.view_pager)
    ViewPager viewPager;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.welcome);

        viewPager.setAdapter(new WelcomePagerAdapter(getSupportFragmentManager(), this, Welcome.values()));

        pageIndicator.setViewPager(viewPager);
    }

    @OnClick(R.id.button_login)
    public void onLogin() {
        navigateTo(LoginActivity.class);
    }

    @OnClick(R.id.button_create_account)
    public void onCreateAccount() {
        navigateTo(CreateAccountActivity.class);
    }
}

package com.epitrack.guardioes.view.menu.help;

import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;
import com.epitrack.guardioes.view.base.BaseFragmentActivity;
import com.epitrack.guardioes.view.welcome.Welcome;
import com.epitrack.guardioes.view.welcome.WelcomePagerAdapter;
import com.viewpagerindicator.CirclePageIndicator;

import butterknife.Bind;

/**
 * @author Miquéias Lopes
 */
public class TutorialActivity extends BaseFragmentActivity {

    @Bind(R.id.page_indicator)
    CirclePageIndicator pageIndicator;

    @Bind(R.id.view_pager)
    ViewPager viewPager;

    @Bind(R.id.button_login)
    Button buttonLogin;

    @Bind(R.id.button_create_account)
    Button buttonCreateAccount;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.welcome);

        viewPager.setAdapter(new WelcomePagerAdapter(getSupportFragmentManager(), this, Welcome.values()));

        pageIndicator.setViewPager(viewPager);

        buttonLogin.setVisibility(View.INVISIBLE);
        buttonCreateAccount.setVisibility(View.INVISIBLE);
    }

    /*@Override
    public boolean onOptionsItemSelected(final MenuItem item) {

        if (item.getItemId() == android.R.id.home) {
            onBackPressed();

        } else {
            super.onOptionsItemSelected(item);
        }
        return true;
    }*/

}

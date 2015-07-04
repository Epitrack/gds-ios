package com.epitrack.guardioes.view;

import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.design.widget.NavigationView.OnNavigationItemSelectedListener;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.menu.Menu;

import java.util.HashMap;
import java.util.Map;

import butterknife.ButterKnife;
import butterknife.InjectView;

public class MainActivity extends AppCompatActivity implements OnNavigationItemSelectedListener {

    private static final Class<? extends Fragment> MAIN_FRAGMENT = MainFragment.class;

    @InjectView(R.id.toolbar)
    Toolbar toolbar;

    @InjectView(R.id.main_activity_navigation_view_main_menu)
    NavigationView navigationView;

    @InjectView(R.id.main_activity_drawer_layout)
    DrawerLayout drawerLayout;

    private ActionBarDrawerToggle drawerToggle;

    private final Map<String, Fragment> fragmentMap = new HashMap<>();

    @Override
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.main_activity);

        ButterKnife.inject(this);

        setupViews();
    }

    private void setupViews() {

        setSupportActionBar(toolbar);

        getSupportActionBar().setDisplayShowTitleEnabled(false);

        drawerToggle = new ActionBarDrawerToggle(this, drawerLayout, toolbar, R.string.app_name, R.string.app_name) {

            @Override
            public void onDrawerOpened(final View drawerView) {
                super.onDrawerOpened(drawerView);

                //getSupportActionBar().setTitle(R.string.app_name);
            }

            @Override
            public void onDrawerClosed(final View drawerView) {
                super.onDrawerClosed(drawerView);

//                final String tag = getCurrentFragment().getTag();
//
//                if (tag.equals(Menu.PROFILE.getTag())) {
//                    getSupportActionBar().setTitle(R.string.profile);
//
//                } else if (tag.equals(Menu.SETTINGS.getTag())) {
//                    getSupportActionBar().setTitle(R.string.settings);
//
//                } else if (tag.equals(Menu.ABOUT.getTag())) {
//                    getSupportActionBar().setTitle(R.string.about);
//
//                } else if (tag.equals(Menu.HELP.getTag())) {
//                    getSupportActionBar().setTitle(R.string.help);
//                }
            }
        };

        drawerLayout.setDrawerListener(drawerToggle);

        navigationView.setNavigationItemSelectedListener(this);

        addFragment(MAIN_FRAGMENT,
                MAIN_FRAGMENT.getSimpleName());
    }

    @Override
    protected void onPostCreate(final Bundle bundle) {
        super.onPostCreate(bundle);

        drawerToggle.syncState();
    }

    @Override
    public boolean onOptionsItemSelected(final MenuItem menuItem) {
        return drawerToggle.onOptionsItemSelected(menuItem) || super.onOptionsItemSelected(menuItem);
    }

    @Override
    public void onBackPressed() {

        if (drawerLayout.isDrawerOpen(GravityCompat.START)) {
            drawerLayout.closeDrawer(GravityCompat.START);

        } else if (getCurrentFragment().getTag().equals(MAIN_FRAGMENT.getSimpleName())) {

            super.onBackPressed();

        } else {

            replaceFragment(MAIN_FRAGMENT,
                            MAIN_FRAGMENT.getSimpleName());
        }
    }

    @Override
    public boolean onNavigationItemSelected(final MenuItem menuItem) {

        drawerLayout.closeDrawer(GravityCompat.START);

        final Menu menu = Menu.getBy(menuItem);

        if (menu.isDialog()) {


        } else if (menu.isFragment()) {

            if (!menu.getTag().equals(getCurrentFragment().getTag())) {

                replaceFragment(menu.getMenuClass(), menu.getTag());
            }

        } else if (menu.isActivity()) {
            startActivity(new Intent(this, menu.getMenuClass()));
        }

        menuItem.setCheckable(true);

        return true;
    }

    private Fragment getCurrentFragment() {
        return getFragmentManager().findFragmentById(R.id.main_activity_frame_layout_fragment_container);
    }

    private void addFragment(final Class<? extends Fragment> fragmentClass, final String tag) {

        final Fragment fragment = Fragment.instantiate(this, fragmentClass.getName());

        getFragmentManager().beginTransaction()
                            .add(R.id.main_activity_frame_layout_fragment_container, fragment, tag)
                            .commit();

        fragmentMap.put(tag, fragment);
    }

    private void replaceFragment(final Class<?> fragmentClass, final String tag) {

        Fragment fragment = fragmentMap.get(tag);

        if (fragment == null) {

            fragment = Fragment.instantiate(this, fragmentClass.getName());

            fragmentMap.put(tag, fragment);
        }

        getFragmentManager().beginTransaction()
                            .replace(R.id.main_activity_frame_layout_fragment_container, fragment, tag)
                            .commit();
    }
}

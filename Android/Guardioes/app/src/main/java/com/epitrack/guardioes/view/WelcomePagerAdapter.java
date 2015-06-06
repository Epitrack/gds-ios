package com.epitrack.guardioes.view;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

public class WelcomePagerAdapter extends FragmentPagerAdapter {

    private final Context context;

    public WelcomePagerAdapter(FragmentManager fragmentManager, Context context) {
        super(fragmentManager);

        this.context = context;
    }

    @Override
    public int getCount() {
        return 5;
    }

    @Override
    public Fragment getItem(int position) {
        return Fragment.instantiate(context, WelcomePageFragment.class.getName());
    }
}

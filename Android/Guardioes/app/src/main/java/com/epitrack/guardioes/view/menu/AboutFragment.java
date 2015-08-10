package com.epitrack.guardioes.view.menu;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseFragment;

public class AboutFragment extends BaseFragment {

    @Override
    public void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        getSupportActionBar().setTitle(R.string.about);
    }

    @Nullable
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup viewGroup, final Bundle bundle) {
        return inflater.inflate(R.layout.about, viewGroup, false);
    }
}

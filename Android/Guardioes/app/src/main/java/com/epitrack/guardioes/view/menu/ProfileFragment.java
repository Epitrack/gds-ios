package com.epitrack.guardioes.view.menu;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseFragment;

public class ProfileFragment extends BaseFragment {

    @Override
    public void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        getSupportActionBar().setTitle(R.string.profile);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup viewGroup, Bundle bundle) {
        return inflater.inflate(R.layout.profile, viewGroup, false);
    }
}

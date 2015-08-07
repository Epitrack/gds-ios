package com.epitrack.guardioes.view.menu;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseFragment;

import butterknife.Bind;
import butterknife.ButterKnife;

public class SettingFragment extends BaseFragment {

    @Bind(R.id.setting_fragment_list_view)
    ListView listView;

    @Override
    public void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        getSupportActionBar().setTitle(R.string.menu_main_setting);
    }

    @Nullable
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup viewGroup, final Bundle bundle) {

        final View view = inflater.inflate(R.layout.settings_fragment, viewGroup, false);

        ButterKnife.bind(this, view);

        listView.setAdapter(new SettingAdapter(getActivity(), Setting.values()));

        return view;
    }
}

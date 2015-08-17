package com.epitrack.guardioes.view.menu.profile;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseFragment;

import butterknife.Bind;
import butterknife.ButterKnife;

public class ProfileFragment extends BaseFragment implements AdapterView.OnItemClickListener {

    @Bind(R.id.list_view)
    ListView listView;

    @Override
    public void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        getSupportActionBar().setTitle(R.string.profile);
    }

    @Nullable
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup viewGroup, final Bundle bundle) {

        final View view = inflater.inflate(R.layout.profile_fragment, viewGroup, false);

        ButterKnife.bind(this, view);

        listView.setAdapter(new ProfileAdapter(getActivity(), Profile.values()));
        listView.setOnItemClickListener(this);

        return view;
    }

    @Override
    public void onItemClick(final AdapterView<?> adapterView, final View view, final int position, final long id) {

        final Profile profile = (Profile) adapterView.getItemAtPosition(position);

        if (profile == Profile.PROFILE) {
            navigateTo(ProfileActivity.class);

        } else if (profile == Profile.INTEREST) {
            navigateTo(InterestActivity.class);
        }
    }
}
package com.epitrack.guardioes.view.menu.help;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseFragment;
import com.epitrack.guardioes.view.IMenu;
import com.epitrack.guardioes.view.MenuListener;
import com.epitrack.guardioes.view.menu.help.HelpAdapter;
import com.epitrack.guardioes.view.menu.help.HelpContact;
import com.epitrack.guardioes.view.menu.help.HelpOption;

import butterknife.Bind;
import butterknife.ButterKnife;

public class HelpFragment extends BaseFragment implements MenuListener {

    @Bind(R.id.list_view_option)
    ListView listViewOption;

    @Bind(R.id.list_view_contact)
    ListView listViewContact;

    @Override
    public void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        getSupportActionBar().setTitle(R.string.help);
    }

    @Nullable
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup viewGroup, final Bundle bundle) {

        final View view = inflater.inflate(R.layout.help, viewGroup, false);

        ButterKnife.bind(this, view);

        listViewOption.setAdapter(new HelpAdapter(getActivity(), this, HelpOption.values()));

        listViewContact.setAdapter(new HelpAdapter(getActivity(), this, HelpContact.values()));

        return view;
    }

    @Override
    public void onMenuSelect(IMenu menu) {

    }
}

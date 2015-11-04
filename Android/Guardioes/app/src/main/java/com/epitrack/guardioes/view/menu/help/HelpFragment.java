package com.epitrack.guardioes.view.menu.help;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.base.BaseFragment;
import com.epitrack.guardioes.view.IMenu;
import com.epitrack.guardioes.view.MenuListener;
import com.epitrack.guardioes.view.welcome.WelcomeActivity;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * @author Igor Morais
 */
public class HelpFragment extends BaseFragment implements MenuListener {

    @Bind(R.id.list_view_option)
    ListView listViewOption;

    @Bind(R.id.list_view_contact)
    ListView listViewContact;

    @Bind(R.id.list_view_report_error)
    ListView listViewReport;

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

        listViewOption.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (HelpOption.getBy(position + 1).getId() == HelpOption.TERM.getId()) {
                    navigateTo(Term.class);
                } else if (HelpOption.getBy(position + 1).getId() == HelpOption.TUTORIAL.getId()) {
                    navigateTo(TutorialActivity.class);
                }
            }
        });

        listViewContact.setAdapter(new HelpAdapter(getActivity(), this, HelpContact.values()));

        listViewContact.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (HelpContact.getBy(position + 2).getId() == HelpContact.TWITTER.getId()) {
                    Intent i = new Intent(Intent.ACTION_VIEW);
                    i.setData(Uri.parse("https://twitter.com/minsaude"));
                    startActivity(i);
                } else if (HelpContact.getBy(position + 2).getId() == HelpContact.FACEBOOK.getId()) {
                    Intent i = new Intent(Intent.ACTION_VIEW);
                    i.setData(Uri.parse("https://www.facebook.com/minsaude"));
                    startActivity(i);
                }
            }
        });

        listViewReport.setAdapter(new HelpAdapter(getActivity(), this, HelpReport.values()));

        listViewReport.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (HelpReport.getBy(position + 1).getId() == HelpReport.REPORT.getId()) {
                    navigateTo(Report.class);
                }
            }
        });

        return view;
    }

    @Override
    public void onMenuSelect(IMenu menu) {

    }
}

package com.epitrack.guardioes.view.menu.profile;

import android.os.Bundle;
import android.view.MenuItem;
import android.widget.ListView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;
import com.epitrack.guardioes.view.IMenu;
import com.epitrack.guardioes.view.MenuListener;

import butterknife.Bind;

/**
 * @author Igor Morais
 */
public class InterestActivity extends BaseAppCompatActivity implements MenuListener {

    @Bind(R.id.list_view_category)
    ListView listViewCategory;

    @Bind(R.id.list_view_tag)
    ListView listViewTag;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.interest);

        listViewCategory.setAdapter(new InterestAdapter(this, this, InterestCategory.values()));

        listViewTag.setAdapter(new InterestAdapter(this, this, InterestTag.values()));
    }

    @Override
    public boolean onOptionsItemSelected(final MenuItem item) {

        if (item.getItemId() == android.R.id.home) {
            onBackPressed();

        } else {
            super.onOptionsItemSelected(item);
        }

        return true;
    }

    @Override
    public void onMenuSelect(final IMenu menu) {

    }
}

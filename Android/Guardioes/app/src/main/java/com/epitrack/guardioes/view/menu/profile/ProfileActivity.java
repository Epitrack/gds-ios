package com.epitrack.guardioes.view.menu.profile;

import android.os.Bundle;
import android.view.MenuItem;
import android.widget.ListView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.User;
import com.epitrack.guardioes.view.BaseAppCompatActivity;

import java.util.ArrayList;

import butterknife.Bind;
import butterknife.OnClick;

public class ProfileActivity extends BaseAppCompatActivity implements UserListener {

    @Bind(R.id.list_view)
    ListView listView;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.profile_activity);

        listView.setAdapter(new UserAdapter(this, new ArrayList<User>(), this));
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
    @OnClick(R.id.button_add)
    public void onAdd() {
        navigateTo(UserActivity.class);
    }

    @Override
    public void onEdit(final User user) {
        navigateTo(UserActivity.class);
    }

    @Override
    public void onDelete(final User user) {

    }
}

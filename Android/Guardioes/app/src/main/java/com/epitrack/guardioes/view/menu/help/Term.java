package com.epitrack.guardioes.view.menu.help;

import android.os.Bundle;
import android.view.MenuItem;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;

/**
 * @author Miquéias Lopes 30/09/15.
 */
public class Term extends BaseAppCompatActivity {

    @Override
    public void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.terms_of_use);
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
}

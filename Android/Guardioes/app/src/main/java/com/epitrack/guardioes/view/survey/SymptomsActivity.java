package com.epitrack.guardioes.view.survey;

import android.os.Bundle;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseActivity;

import butterknife.ButterKnife;

public class SymptomsActivity extends BaseActivity {

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.symptoms_activity);

        ButterKnife.inject(this);
    }
}

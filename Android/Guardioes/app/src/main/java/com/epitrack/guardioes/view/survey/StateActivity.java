package com.epitrack.guardioes.view.survey;

import android.os.Bundle;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseActivity;

import butterknife.ButterKnife;
import butterknife.OnClick;

public class StateActivity extends BaseActivity {

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.state_activity);

        ButterKnife.inject(this);
    }

    @OnClick(R.id.state_activity_text_view_state_good)
    public void onStateGood() {
        navigateTo(SymptomsActivity.class);
    }

    @OnClick(R.id.state_activity_text_view_state_bad)
    public void onStateBad() {
        navigateTo(SymptomsActivity.class);
    }
}

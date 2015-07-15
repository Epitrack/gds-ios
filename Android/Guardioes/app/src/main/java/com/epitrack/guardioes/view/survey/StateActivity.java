package com.epitrack.guardioes.view.survey;

import android.os.Bundle;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseAppCompatActivity;

import butterknife.ButterKnife;
import butterknife.OnClick;

public class StateActivity extends BaseAppCompatActivity {

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.state_activity);

        ButterKnife.bind(this);
    }

    @OnClick(R.id.state_activity_text_view_state_good)
    public void onStateGood() {
        navigateTo(SymptomActivity.class);
    }

    @OnClick(R.id.state_activity_text_view_state_bad)
    public void onStateBad() {
        navigateTo(SymptomActivity.class);
    }
}

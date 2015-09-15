package com.epitrack.guardioes.view.survey;

import android.os.Bundle;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;

import butterknife.OnClick;

/**
 * @author Igor Morais
 */
public class StateActivity extends BaseAppCompatActivity {

    String id;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        final boolean mainMember = getIntent().getBooleanExtra(Constants.Bundle.MAIN_MEMBER, false);

        if (mainMember) {
            SingleUser singleUser = SingleUser.getInstance();
            id = singleUser.getId();
        } else {
            id = getIntent().getStringExtra("id_user");
        }

        setContentView(R.layout.state);
    }

    @OnClick(R.id.text_view_state_good)
    public void onStateGood() {
        navigateTo(ShareActivity.class);
    }

    @OnClick(R.id.text_view_state_bad)
    public void onStateBad() {
        final Bundle bundle = new Bundle();

        bundle.putString("id_user", id);
        navigateTo(SymptomActivity.class, bundle);
    }
}

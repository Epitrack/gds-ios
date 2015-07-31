package com.epitrack.guardioes.view.survey;

import android.content.Intent;
import android.os.Bundle;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseActivity;
import com.epitrack.guardioes.view.MainActivity;

import butterknife.ButterKnife;
import butterknife.OnClick;

public class ShareActivity extends BaseActivity {

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.share_activity);

        ButterKnife.bind(this);
    }

    @Override
    public void onBackPressed() {
        navigateTo();
    }

    @OnClick(R.id.share_activity_button_confirm)
    public void onConfirm() {
        navigateTo();
    }

    private void navigateTo() {

        navigateTo(MainActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                       Intent.FLAG_ACTIVITY_NEW_TASK);
    }
}

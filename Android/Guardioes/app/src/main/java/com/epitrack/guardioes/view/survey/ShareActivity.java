package com.epitrack.guardioes.view.survey;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.utility.ViewUtility;
import com.epitrack.guardioes.view.BaseActivity;
import com.epitrack.guardioes.view.MainActivity;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class ShareActivity extends BaseActivity {

    private static final float MARGIN_TOP = 25;

    @Bind(R.id.share_activity_text_view_hospital_message_hint)
    TextView textViewHospitalMessage;

    @Bind(R.id.share_activity_text_view_social_message_hint)
    TextView textViewHSocialMessage;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.share_activity);

        ButterKnife.bind(this);

        final boolean hasBadState = getIntent().getBooleanExtra(Constants.Intent.HAS_BAD_STATE, false);

        if (hasBadState) {

            textViewHospitalMessage.setVisibility(View.VISIBLE);

            ViewUtility.setMarginTop(textViewHSocialMessage, ViewUtility.toPixel(this, MARGIN_TOP));
        }
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

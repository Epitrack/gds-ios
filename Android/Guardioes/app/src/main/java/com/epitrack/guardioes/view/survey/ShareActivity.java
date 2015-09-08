package com.epitrack.guardioes.view.survey;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.utility.ViewUtility;
import com.epitrack.guardioes.view.base.BaseActivity;
import com.epitrack.guardioes.view.HomeActivity;

import butterknife.Bind;
import butterknife.OnClick;

/**
 * @author Igor Morais
 */
public class ShareActivity extends BaseActivity {

    private static final float MARGIN_TOP = 25;

    @Bind(R.id.text_view_hospital_message_hint)
    TextView textViewHospitalMessage;

    @Bind(R.id.text_view_social_message_hint)
    TextView textViewHSocialMessage;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.share);

        final boolean hasBadState = getIntent().getBooleanExtra(Constants.Bundle.BAD_STATE, false);

        if (hasBadState) {

            textViewHospitalMessage.setVisibility(View.VISIBLE);

            ViewUtility.setMarginTop(textViewHSocialMessage, ViewUtility.toPixel(this, MARGIN_TOP));
        }
    }

    @Override
    public void onBackPressed() {
        navigateTo();
    }

    @OnClick(R.id.button_confirm)
    public void onConfirm() {
        navigateTo();
    }

    private void navigateTo() {

        navigateTo(HomeActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                       Intent.FLAG_ACTIVITY_NEW_TASK);
    }
}

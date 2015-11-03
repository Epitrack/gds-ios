package com.epitrack.guardioes.view.survey;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.afollestad.materialdialogs.MaterialDialog;
import com.epitrack.guardioes.R;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.utility.DialogBuilder;
import com.epitrack.guardioes.utility.SocialShare;
import com.epitrack.guardioes.utility.ViewUtility;
import com.epitrack.guardioes.view.base.BaseActivity;
import com.epitrack.guardioes.view.HomeActivity;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.MessageDialog;
import com.facebook.share.widget.ShareButton;
import com.facebook.share.widget.ShareDialog;
import com.twitter.sdk.android.tweetcomposer.TweetComposer;

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

    @Bind(R.id.share_facebook)
    Button buttonShareFacebook;

    @Bind(R.id.share_twitter)
    Button buttonShareTwitter;

    ShareButton shareButton;
    ShareDialog shareDialog;
    CallbackManager callbackManager;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.share);
        FacebookSdk.sdkInitialize(getApplicationContext());
        callbackManager = CallbackManager.Factory.create();
        //shareDialog = new ShareDialog(this);
        shareDialog = new ShareDialog(this);

        shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
            @Override
            public void onSuccess(Sharer.Result result) {

                Log.v("MyApp", "Share success!");
            }

            @Override
            public void onCancel() {

                Log.v("MyApp", "Share canceled");
            }

            @Override
            public void onError(FacebookException e) {

                Log.v("MyApp", "Share error: " + e.toString());
            }
        });

        final boolean hasBadState = getIntent().getBooleanExtra(Constants.Bundle.BAD_STATE, false);

        if (hasBadState) {

            textViewHospitalMessage.setVisibility(View.VISIBLE);

            ViewUtility.setMarginTop(textViewHSocialMessage, ViewUtility.toPixel(this, MARGIN_TOP));
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        callbackManager.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    public void onBackPressed() {
        navigateTo(HomeActivity.class);
    }

    @OnClick(R.id.button_confirm)
    public void onConfirm() {
        navigateTo();
    }

    private void navigateTo() {

        navigateTo(HomeActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                       Intent.FLAG_ACTIVITY_NEW_TASK);
    }

    @OnClick(R.id.share_facebook)
    public void shareFacebook() {

        ShareLinkContent content = new ShareLinkContent.Builder()
                .setContentDescription("Acabei de participar do Guardiões da Saúde, participe você também: www.guardioesdasaude.org")
                .setContentTitle("Guardiões da Saúde")
                .setContentUrl(Uri.parse("http://www.guardioesdasaude.org"))
                .build();

        shareDialog.show(content);
        SocialShare.getInstance().setIsShared(true);
    }

    @OnClick(R.id.share_twitter)
    public void sahreTwitter() {

        TweetComposer.Builder builder = new TweetComposer.Builder(this)
                .text("Acabei de participar do Guardiões da Saúde, participe você também: www.guardioesdasaude.org");
        builder.show();
        SocialShare.getInstance().setIsShared(true);

    }
}

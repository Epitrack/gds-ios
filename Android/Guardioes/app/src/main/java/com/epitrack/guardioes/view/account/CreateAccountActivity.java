package com.epitrack.guardioes.view.account;

import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseAppCompatActivity;
import com.epitrack.guardioes.view.MainActivity;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;

public class CreateAccountActivity extends BaseAppCompatActivity implements OnSocialAccountListener {

    private static final String TAG_SOCIAL_FRAGMENT = "social_fragment";

    @Bind(R.id.create_account_activity_linear_layout_social_login)
    LinearLayout linearLayoutSocialLogin;

    @Bind(R.id.create_account_activity_linear_layout_login)
    LinearLayout linearLayoutLogin;

    @Bind(R.id.create_account_activity_edit_text_mail)
    EditText editTextMail;

    @Bind(R.id.create_account_activity_edit_text_password)
    EditText editTextPassword;

    @Bind(R.id.create_account_activity_edit_text_repeat_password)
    EditText editTextRepeatPassword;

    @Bind(R.id.create_account_activity_edit_text_name)
    EditText editTextName;

    @Bind(R.id.create_account_activity_edit_text_birth_date)
    EditText editTextBirthDate;

    private boolean inCreateAccount;

    private SocialFragment socialFragment;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.create_account_activity);

        ButterKnife.bind(this);

        getSupportActionBar().setDisplayShowTitleEnabled(false);

        // TODO: Check play service
        // TODO: Register to GCM. Review soon..
        // startService(new Intent(this, RegisterService.class));

//        LocalBroadcastManager.getInstance(this).registerReceiver(mRegistrationBroadcastReceiver,
//                new IntentFilter(QuickstartPreferences.REGISTRATION_COMPLETE));
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.privacy_menu, menu);

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(final MenuItem item) {

        if (item.getItemId() == android.R.id.home) {

            if (inCreateAccount) {
                handlerAnimation();

            } else {
                return super.onOptionsItemSelected(item);
            }

        } else {
            return super.onOptionsItemSelected(item);
        }

        return true;
    }

    public void onPrivacy(final MenuItem item) {
        Toast.makeText(this, "Open dialog", Toast.LENGTH_SHORT).show();
    }

    @OnCheckedChanged(R.id.create_account_activity_check_box_term)
    public void onCheck(final boolean checked) {

        if (socialFragment == null) {
            socialFragment = (SocialFragment) getFragmentManager().findFragmentByTag(TAG_SOCIAL_FRAGMENT);
        }

        socialFragment.setEnable(checked);
    }

    @OnClick(R.id.create_account_activity_text_view_term)
    public void onTerm() {
        Toast.makeText(this, "Open terms", Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onBackPressed() {

        if (inCreateAccount) {
            handlerAnimation();

        } else {
            super.onBackPressed();
        }
    }

    @OnClick(R.id.create_account_activity_button_mail)
    public void onCreateAccountAnimation() {

        final Animation slideIn = AnimationUtils.loadAnimation(this, R.anim.slide_in_left);

        slideIn.setAnimationListener(new Animation.AnimationListener() {

            @Override
            public void onAnimationStart(final Animation animation) {

                if (linearLayoutLogin.getVisibility() == View.INVISIBLE) {
                    linearLayoutLogin.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onAnimationEnd(final Animation animation) {
                inCreateAccount = true;
            }

            @Override
            public void onAnimationRepeat(final Animation animation) {

            }
        });

        final Animation slideOut = AnimationUtils.loadAnimation(this, R.anim.slide_out_left);

        linearLayoutLogin.startAnimation(slideIn);
        linearLayoutSocialLogin.startAnimation(slideOut);
    }

    private void handlerAnimation() {

        final Animation slideIn = AnimationUtils.loadAnimation(this, R.anim.slide_in_right);

        slideIn.setAnimationListener(new Animation.AnimationListener() {

            @Override
            public void onAnimationStart(final Animation animation) {

            }

            @Override
            public void onAnimationEnd(final Animation animation) {
                inCreateAccount = false;
            }

            @Override
            public void onAnimationRepeat(final Animation animation) {

            }
        });

        final Animation slideOut = AnimationUtils.loadAnimation(this, R.anim.slide_out_right);

        linearLayoutSocialLogin.startAnimation(slideIn);
        linearLayoutLogin.startAnimation(slideOut);
    }

    @Override
    public void onError() {
        Toast.makeText(this, "Houston, we have a problem", Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onCancel() {
        Toast.makeText(this, "Cancel..", Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onSuccess() {

        navigateTo(MainActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                Intent.FLAG_ACTIVITY_NEW_TASK);
    }

    @OnClick(R.id.create_account_activity_button_create_account)
    public void onCreateAccount() {

        navigateTo(MainActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                Intent.FLAG_ACTIVITY_NEW_TASK);
    }
}

package com.epitrack.guardioes.view.account;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseAppCompatActivity;
import com.epitrack.guardioes.view.MainActivity;
import com.mobsandgeeks.saripaar.ValidationError;
import com.mobsandgeeks.saripaar.Validator;
import com.mobsandgeeks.saripaar.annotation.ConfirmPassword;
import com.mobsandgeeks.saripaar.annotation.Email;
import com.mobsandgeeks.saripaar.annotation.Length;
import com.mobsandgeeks.saripaar.annotation.NotEmpty;
import com.mobsandgeeks.saripaar.annotation.Password;

import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;

public class CreateAccountActivity extends BaseAppCompatActivity implements OnSocialAccountListener {

    private static final int MIN_CHAR_NICKNAME = 3;

    private static final String TAG_SOCIAL_FRAGMENT = "social_fragment";

    @Bind(R.id.create_account_activity_linear_layout_social_login)
    LinearLayout linearLayoutSocialLogin;

    @Bind(R.id.create_account_activity_linear_layout_login)
    LinearLayout linearLayoutLogin;

    @Email(messageResId = R.string.validation_mail)
    @Bind(R.id.create_account_activity_edit_text_mail)
    EditText editTextMail;

    @Password(messageResId = R.string.validation_password)
    @Bind(R.id.create_account_activity_edit_text_password)
    EditText editTextPassword;

    @ConfirmPassword(messageResId = R.string.validation_confirm_password)
    @Bind(R.id.create_account_activity_edit_text_confirm_password)
    EditText editTextConfirmPassword;

    @Length(min = MIN_CHAR_NICKNAME, trim = true, messageResId = R.string.validation_nickname)
    @Bind(R.id.create_account_activity_edit_text_nickname)
    EditText editTextNickname;

    @NotEmpty(messageResId = R.string.validation_not_empty)
    @Bind(R.id.create_account_activity_edit_text_birth_date)
    EditText editTextBirthDate;

    @Bind(R.id.create_account_activity_button_create_account)
    Button buttonCreateAccount;

    private boolean inCreateAccount;

    private SocialFragment socialFragment;

    private Validator validator;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.create_account_activity);

        ButterKnife.bind(this);

        final ActionBar actionBar = getSupportActionBar();

        if (actionBar == null) {
            throw new IllegalArgumentException("The actionBar is null.");
        }

        getSupportActionBar().setDisplayShowTitleEnabled(false);

        buttonCreateAccount.setEnabled(false);

        getSocialFragment().setEnable(false);

        validator = new Validator(this);
        validator.setValidationListener(new ValidationHandler());

        // TODO: Check play service
        // TODO: Register to GCM. Review soon..
        // startService(new Intent(this, RegisterService.class));

//        LocalBroadcastManager.getInstance(this).registerReceiver(mRegistrationBroadcastReceiver,
//                new IntentFilter(QuickstartPreferences.REGISTRATION_COMPLETE));
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_privacy, menu);

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

        buttonCreateAccount.setEnabled(checked);

        getSocialFragment().setEnable(checked);
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

    private SocialFragment getSocialFragment() {

        if (socialFragment == null) {
            socialFragment = (SocialFragment) getFragmentManager().findFragmentByTag(TAG_SOCIAL_FRAGMENT);
        }

        return socialFragment;
    }

    @Override
    public void onSuccess() {

        navigateTo(MainActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                       Intent.FLAG_ACTIVITY_NEW_TASK);
    }

    @OnClick(R.id.create_account_activity_button_create_account)
    public void onCreateAccount() {

        //validator.validate();

        navigateTo(MainActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                       Intent.FLAG_ACTIVITY_NEW_TASK);
    }

    private class ValidationHandler implements Validator.ValidationListener {

        @Override
        public void onValidationSucceeded() {

            // TODO: Make request

            navigateTo(MainActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                           Intent.FLAG_ACTIVITY_NEW_TASK);
        }

        @Override
        public void onValidationFailed(final List<ValidationError> errorList) {

            for (final ValidationError error : errorList) {

                final String message = error.getCollatedErrorMessage(CreateAccountActivity.this);

                final View view = error.getView();

                if (view instanceof EditText) {

                    ((EditText) view).setError(message);
                }
            }
        }
    }
}

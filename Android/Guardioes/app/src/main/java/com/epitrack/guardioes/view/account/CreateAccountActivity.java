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
import com.epitrack.guardioes.view.HomeActivity;
import com.epitrack.guardioes.view.NotifyDialog;
import com.mobsandgeeks.saripaar.ValidationError;
import com.mobsandgeeks.saripaar.Validator;
import com.mobsandgeeks.saripaar.annotation.ConfirmPassword;
import com.mobsandgeeks.saripaar.annotation.Email;
import com.mobsandgeeks.saripaar.annotation.Length;
import com.mobsandgeeks.saripaar.annotation.NotEmpty;
import com.mobsandgeeks.saripaar.annotation.Password;

import java.util.List;

import butterknife.Bind;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;

public class CreateAccountActivity extends BaseAppCompatActivity implements SocialAccountListener {

    private static final int MIN_CHAR_NICKNAME = 3;

    private static final String SOCIAL_FRAGMENT = "social_fragment";

    @Bind(R.id.linear_layout_social_account)
    LinearLayout linearLayoutSocial;

    @Bind(R.id.linear_layout_next)
    LinearLayout linearLayoutNext;

    @Bind(R.id.linear_layout_create)
    LinearLayout linearLayoutCreate;

    @Email(messageResId = R.string.validation_mail)
    @Bind(R.id.edit_text_mail)
    EditText editTextMail;

    @Password(messageResId = R.string.validation_password)
    @Bind(R.id.edit_text_password)
    EditText editTextPassword;

    @ConfirmPassword(messageResId = R.string.validation_confirm_password)
    @Bind(R.id.edit_text_confirm_password)
    EditText editTextConfirmPassword;

    @Length(min = MIN_CHAR_NICKNAME, trim = true, messageResId = R.string.validation_length)
    @Bind(R.id.edit_text_name)
    EditText editTextNickname;

    @NotEmpty(messageResId = R.string.validation_empty)
    @Bind(R.id.edit_text_birth_date)
    EditText editTextBirthDate;

    @Bind(R.id.button_mail)
    Button buttonMail;

    private SocialFragment socialFragment;

    private Validator validator;

    private State state = State.SOCIAL;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.create_account);

        final ActionBar actionBar = getSupportActionBar();

        if (actionBar == null) {
            throw new IllegalArgumentException("The actionBar is null.");
        }

        actionBar.setDisplayShowTitleEnabled(false);

        buttonMail.setEnabled(false);

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
    public boolean onCreateOptionsMenu(final Menu menu) {
        getMenuInflater().inflate(R.menu.privacy, menu);

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(final MenuItem item) {

        if (item.getItemId() == android.R.id.home) {

            if (state == State.SOCIAL) {
                return super.onOptionsItemSelected(item);

            } else {
                handlerState();
            }

        } else {
            return super.onOptionsItemSelected(item);
        }

        return true;
    }

    public void onPrivacy(final MenuItem item) {

        new NotifyDialog() {

            @Override
            public int getLayout() {
                return R.layout.privacy;
            }

            @Override
            public void findView(final View view) {
                super.findView(view);

                view.findViewById(R.id.image_button_close).setOnClickListener(new View.OnClickListener() {

                    @Override
                    public void onClick(final View view) {
                        dismiss();
                    }
                });
            }

        }.show(getFragmentManager(), NotifyDialog.TAG);
    }

    @OnCheckedChanged(R.id.check_box_term)
    public void onCheck(final boolean checked) {

        buttonMail.setEnabled(checked);

        getSocialFragment().setEnable(checked);
    }

    @OnClick(R.id.text_view_term)
    public void onTerm() {
        Toast.makeText(this, "Open terms", Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onBackPressed() {

        if (state == State.SOCIAL) {
            super.onBackPressed();

        } else {
            handlerState();
        }
    }

    private void previous() {
        state = State.getBy(state.getId() - 1);
    }

    private void next() {
        state = State.getBy(state.getId() + 1);
    }

    private void handlerState() {

        if (state == State.NEXT) {
            onPreviousAnimation(linearLayoutSocial, linearLayoutNext);

        } else if (state == State.CREATE) {
            onPreviousAnimation(linearLayoutNext, linearLayoutCreate);
        }
    }

    @OnClick(R.id.button_mail)
    public void onMail() {
        onNextAnimation(linearLayoutNext, linearLayoutSocial);
    }

    @OnClick(R.id.button_next)
    public void onNext() {
        onNextAnimation(linearLayoutCreate, linearLayoutNext);
    }

    private void onPreviousAnimation(final View visibleView, final View invisibleView) {

        final Animation slideIn = AnimationUtils.loadAnimation(this, R.anim.slide_in_right);

        slideIn.setAnimationListener(new Animation.AnimationListener() {

            @Override
            public void onAnimationStart(final Animation animation) {
                visibleView.setVisibility(View.VISIBLE);
            }

            @Override
            public void onAnimationEnd(final Animation animation) {
                previous();

                invisibleView.setVisibility(View.INVISIBLE);

                invisibleView.clearAnimation();
            }

            @Override
            public void onAnimationRepeat(final Animation animation) {

            }
        });

        final Animation slideOut = AnimationUtils.loadAnimation(this, R.anim.slide_out_right);

        visibleView.startAnimation(slideIn);

        invisibleView.startAnimation(slideOut);
    }

    private void onNextAnimation(final View visibleView, final View invisibleView) {

        final Animation slideIn = AnimationUtils.loadAnimation(this, R.anim.slide_in_left);

        slideIn.setAnimationListener(new Animation.AnimationListener() {

            @Override
            public void onAnimationStart(final Animation animation) {
                visibleView.setVisibility(View.VISIBLE);
            }

            @Override
            public void onAnimationEnd(final Animation animation) {
                next();

                invisibleView.setVisibility(View.INVISIBLE);

                invisibleView.clearAnimation();
            }

            @Override
            public void onAnimationRepeat(final Animation animation) {

            }
        });

        final Animation slideOut = AnimationUtils.loadAnimation(this, R.anim.slide_out_left);

        visibleView.startAnimation(slideIn);

        invisibleView.startAnimation(slideOut);
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
            socialFragment = (SocialFragment) getFragmentManager().findFragmentByTag(SOCIAL_FRAGMENT);
        }

        return socialFragment;
    }

    @Override
    public void onSuccess() {

        navigateTo(HomeActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                       Intent.FLAG_ACTIVITY_NEW_TASK);
    }

    @OnClick(R.id.button_create_account)
    public void onCreateAccount() {

        // TODO: Uncomment this to validate
        //validator.validate();

        navigateTo(HomeActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                       Intent.FLAG_ACTIVITY_NEW_TASK);
    }

    private class ValidationHandler implements Validator.ValidationListener {

        @Override
        public void onValidationSucceeded() {

            // TODO: Make request

            navigateTo(HomeActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
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

    enum State {

        SOCIAL (1), NEXT (2), CREATE (3);

        private final int id;

        State(final int id) {
            this.id = id;
        }

        public int getId() {
            return id;
        }

        public static State getBy(final int id) {

            for (final State state : State.values()) {

                if (state.getId() == id) {
                    return state;
                }
            }

            throw new IllegalArgumentException("The State has not found.");
        }
    }
}

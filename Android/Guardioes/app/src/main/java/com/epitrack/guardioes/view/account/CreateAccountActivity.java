package com.epitrack.guardioes.view.account;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseFragmentActivity;
import com.epitrack.guardioes.view.MainActivity;

import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;

public class CreateAccountActivity extends BaseFragmentActivity implements OnAccountListener {

    @InjectView(R.id.create_account_activity_edit_text_mail)
    EditText editTextMail;

    @InjectView(R.id.create_account_activity_edit_text_password)
    EditText editTextPassword;

    @InjectView(R.id.create_account_activity_edit_text_repeat_password)
    EditText editTextRepeatPassword;

    @InjectView(R.id.create_account_activity_edit_text_name)
    EditText editTextName;

    @InjectView(R.id.create_account_activity_edit_text_birth_date)
    EditText editTextBirthDate;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.create_account_activity);

        ButterKnife.inject(this);
    }

    @OnClick(R.id.create_account_activity_button_register)
    public void onEnter(final View view) {

        navigateTo(MainActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                       Intent.FLAG_ACTIVITY_NEW_TASK);
    }

    @Override
    public void onError() {

    }

    @Override
    public void onCancel() {

    }

    @Override
    public void onSuccess() {

        navigateTo(MainActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                       Intent.FLAG_ACTIVITY_NEW_TASK);
    }
}

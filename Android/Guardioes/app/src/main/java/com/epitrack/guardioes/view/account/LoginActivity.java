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

public class LoginActivity extends BaseFragmentActivity implements OnAccountListener {

    @InjectView(R.id.login_activity_edit_text_mail)
    EditText editTextMail;

    @InjectView(R.id.login_activity_edit_text_password)
    EditText editTextPassword;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.login_activity);

        ButterKnife.inject(this);

        // TODO: Check play service
        // TODO: Register to GCM. Review soon..
        // startService(new Intent(this, RegisterService.class));

//        LocalBroadcastManager.getInstance(this).registerReceiver(mRegistrationBroadcastReceiver,
//                new IntentFilter(QuickstartPreferences.REGISTRATION_COMPLETE));

    }

    @OnClick(R.id.login_activity_button_enter)
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

package com.epitrack.guardioes.view.menu.profile;

import android.os.Bundle;
import android.widget.Spinner;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseAppCompatActivity;

import butterknife.Bind;
import butterknife.OnClick;

public class UserActivity extends BaseAppCompatActivity {

    @Bind(R.id.spinner_gender)
    Spinner spinnerGender;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.user);
    }

    @OnClick(R.id.image_view_image)
    public void onPhoto() {
        navigateTo(AvatarActivity.class);
    }

    @OnClick(R.id.button_add)
    public void onAdd() {
        finish();
    }
}

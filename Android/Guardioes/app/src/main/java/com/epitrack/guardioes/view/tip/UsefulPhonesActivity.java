package com.epitrack.guardioes.view.tip;

import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;
import com.epitrack.guardioes.view.base.BaseFragment;
import com.epitrack.guardioes.view.base.BaseFragmentActivity;

public class UsefulPhonesActivity extends BaseAppCompatActivity {

    @Override
    public void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.useful_phones);

        int phoneId = Integer.parseInt(getIntent().getStringExtra("phone_id"));

        /*EMERGENCY       (1, R.string.emergency, ""),
        POLICE          (2, R.string.police, ""),
        FIREMAN         (3, R.string.fireman, ""),
        DEFENSE         (4, R.string.defense, "");*/

        if (phoneId == Phone.EMERGENCY.getId()) {

        } else if (phoneId == Phone.POLICE.getId()) {

        } else if (phoneId == Phone.FIREMAN.getId()) {

        } else if (phoneId == Phone.DEFENSE.getId()) {

        }
    }
}

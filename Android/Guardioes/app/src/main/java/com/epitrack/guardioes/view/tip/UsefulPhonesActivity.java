package com.epitrack.guardioes.view.tip;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;

import butterknife.Bind;
import butterknife.OnClick;

public class UsefulPhonesActivity extends BaseAppCompatActivity {
    int phoneId;

    @Bind(R.id.button_call)
    Button buttonCall;

    @Override
    public void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.useful_phones);

        phoneId = Integer.parseInt(getIntent().getStringExtra("phone_id"));
        ImageView imageView = (ImageView) findViewById(R.id.image_call);
        TextView textView = (TextView) findViewById(R.id.text_call);

        if (phoneId == Phone.EMERGENCY.getId()) {
            imageView.setImageResource(R.drawable.icon_samu);
            textView.setText("");
        } else if (phoneId == Phone.POLICE.getId()) {
            imageView.setImageResource(R.drawable.icon_police);
            textView.setText("");
        } else if (phoneId == Phone.FIREMAN.getId()) {
            imageView.setImageResource(R.drawable.icon_firefighter);
            textView.setText("");
        } else if (phoneId == Phone.DEFENSE.getId()) {
            imageView.setImageResource(R.drawable.icon_civildefense);
            textView.setText("");
        }
    }

    @OnClick(R.id.button_call)
    public void onClick() {
        Intent itent;
        Uri uri = null;

        if (phoneId == Phone.EMERGENCY.getId()) {
            uri = Uri.parse("192");
        } else if (phoneId == Phone.POLICE.getId()) {
            uri = Uri.parse("190");
        } else if (phoneId == Phone.FIREMAN.getId()) {
            uri = Uri.parse("193");
        } else if (phoneId == Phone.DEFENSE.getId()) {
            uri = Uri.parse("08006440199");
        }
        itent = new Intent(Intent.ACTION_DIAL, uri);
        startActivity(itent);
    }
}

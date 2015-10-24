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

        phoneId = getIntent().getIntExtra("phone_id", 1);
        ImageView imageView = (ImageView) findViewById(R.id.image_call);
        TextView textViewDesc = (TextView) findViewById(R.id.text_call_desc);
        TextView textViewTitle = (TextView) findViewById(R.id.text_call_title);
        TextView textViewNumber = (TextView) findViewById(R.id.text_call_number);

        if (phoneId == Phone.EMERGENCY.getId()) {
            imageView.setImageResource(R.drawable.icon_samu);
            textViewDesc.setText(R.string.emergence_text);
            textViewTitle.setText("SAMU");
            textViewNumber.setText("192");
        } else if (phoneId == Phone.POLICE.getId()) {
            imageView.setImageResource(R.drawable.icon_police);
            textViewTitle.setText(R.string.police_text);
            textViewNumber.setText("190");
            textViewDesc.setText("");
        } else if (phoneId == Phone.FIREMAN.getId()) {
            imageView.setImageResource(R.drawable.icon_firefighter);
            textViewTitle.setText(R.string.fireman_text);
            textViewNumber.setText("193");
            textViewDesc.setText("");
        } else if (phoneId == Phone.DEFENSE.getId()) {
            imageView.setImageResource(R.drawable.icon_civildefense);
            textViewTitle.setText(R.string.defense_text);
            textViewNumber.setText("0800 644 0199");
            textViewDesc.setText("");
        }
    }

    @OnClick(R.id.button_call)
    public void onClick() {
        Intent intent;
        Uri uri = null;

        if (phoneId == Phone.EMERGENCY.getId()) {
            uri = Uri.parse("tel:192");
        } else if (phoneId == Phone.POLICE.getId()) {
            uri = Uri.parse("tel:190");
        } else if (phoneId == Phone.FIREMAN.getId()) {
            uri = Uri.parse("tel:193");
        } else if (phoneId == Phone.DEFENSE.getId()) {
            uri = Uri.parse("tel:08006440199");
        }
        intent = new Intent(Intent.ACTION_DIAL);
        intent.setData(uri);
        startActivity(intent);
    }
}

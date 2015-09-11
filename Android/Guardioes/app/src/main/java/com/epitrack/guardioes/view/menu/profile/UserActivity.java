package com.epitrack.guardioes.view.menu.profile;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.design.widget.TextInputLayout;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.utility.BitmapUtility;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;

import butterknife.Bind;
import butterknife.OnClick;

/**
 * @author Igor Morais
 */
public class UserActivity extends BaseAppCompatActivity {

    @Bind(R.id.text_view_message)
    TextView textViewMessage;

    @Bind(R.id.edit_text_nickname)
    EditText editTextNickname;

    @Bind(R.id.image_view_image)
    ImageView imageViewImage;

    @Bind(R.id.spinner_gender)
    Spinner spinnerGender;

    @Bind(R.id.spinner_race)
    Spinner spinnerRace;

    @Bind(R.id.edit_text_birth_date)
    EditText editTextBirthDate;

    @Bind(R.id.text_layout_mail)
    TextInputLayout textLayoutMail;

    @Bind(R.id.edit_text_mail)
    EditText editTextMail;

    @Bind(R.id.linear_layout_password)
    LinearLayout linearLayoutPassword;

    @Bind(R.id.edit_text_password)
    EditText editTextPassword;

    @Bind(R.id.edit_text_confirm_password)
    EditText editTextConfirmPassword;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.user);

        final boolean mainMember = getIntent().getBooleanExtra(Constants.Bundle.MAIN_MEMBER, false);
        final String nick = getIntent().getStringExtra("nick");
        final String dob = getIntent().getStringExtra("dob");
        final String gender = getIntent().getStringExtra("gender");
        final String race = getIntent().getStringExtra("race");
        final String email = getIntent().getStringExtra("email");

        editTextNickname.setText(nick);
        editTextBirthDate.setText(dob);
        editTextMail.setText(email);

        if (race == "branco") {
            spinnerGender.setSelection(0);
        } else if (race == "preto") {
            spinnerGender.setSelection(1);
        } else if (race == "pardo") {
            spinnerGender.setSelection(2);
        } else if (race == "amarelo") {
            spinnerGender.setSelection(3);
        } else if (race == "indígeno") {
            spinnerGender.setSelection(4);
        }

        //spinnerGender.setSelection();

        if (gender == "M") {
            spinnerRace.setSelection(0);
        } else {
            spinnerRace.setSelection(1);
        }

        if (mainMember) {

            textViewMessage.setText(R.string.message_fields);

            textLayoutMail.setVisibility(View.VISIBLE);
            editTextMail.setVisibility(View.VISIBLE);

            linearLayoutPassword.setVisibility(View.VISIBLE);
        }
    }

    @OnClick(R.id.image_view_image)
    public void onImage() {
        navigateForResult(AvatarActivity.class, Constants.RequestCode.IMAGE);
    }

    @OnClick(R.id.button_add)
    public void onAdd() {

        // TODO: Make request to servers

        Toast.makeText(this, "Houston, we have a problem", Toast.LENGTH_SHORT).show();
    }

    @Override
    protected void onActivityResult(final int requestCode, final int resultCode, final Intent intent) {

        if (requestCode == Constants.RequestCode.IMAGE) {

            if (resultCode == RESULT_OK) {

                if (intent.hasExtra(Constants.Bundle.AVATAR)) {

                    final Avatar avatar = (Avatar) intent.getSerializableExtra(Constants.Bundle.AVATAR);

                    imageViewImage.setImageResource(avatar.getSmall());

                } else if (intent.hasExtra(Constants.Bundle.URI)) {

                    final Uri uri = intent.getParcelableExtra(Constants.Bundle.URI);

                    final int width = imageViewImage.getWidth();
                    final int height = imageViewImage.getHeight();

                    imageViewImage.setImageBitmap(BitmapUtility.scale(width, height, uri.getPath()));
                }
            }
        }
    }
}

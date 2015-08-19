package com.epitrack.guardioes.view.menu.profile;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.ImageView;
import android.widget.Spinner;
import android.widget.Toast;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.utility.BitmapUtility;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.view.BaseAppCompatActivity;

import butterknife.Bind;
import butterknife.OnClick;

public class UserActivity extends BaseAppCompatActivity {

    @Bind(R.id.image_view_image)
    ImageView imageViewImage;

    @Bind(R.id.spinner_gender)
    Spinner spinnerGender;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.user);
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

                if (intent.hasExtra(Constants.Intent.AVATAR)) {

                    final Avatar avatar = (Avatar) intent.getSerializableExtra(Constants.Intent.AVATAR);

                    imageViewImage.setImageResource(avatar.getSmall());

                } else if (intent.hasExtra(Constants.Intent.URI)) {

                    final Uri uri = intent.getParcelableExtra(Constants.Intent.URI);

                    final int width = imageViewImage.getWidth();
                    final int height = imageViewImage.getHeight();

                    imageViewImage.setImageBitmap(BitmapUtility.scale(width, height, uri.getPath()));
                }
            }
        }
    }
}

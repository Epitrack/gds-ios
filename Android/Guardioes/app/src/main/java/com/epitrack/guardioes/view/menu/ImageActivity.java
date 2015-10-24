package com.epitrack.guardioes.view.menu;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import com.edmodo.cropper.CropImageView;
import com.epitrack.guardioes.R;
import com.epitrack.guardioes.utility.BitmapUtility;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.utility.Extension;
import com.epitrack.guardioes.utility.FileUtility;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;

import java.util.Date;
import java.util.Random;

import butterknife.Bind;

/**
 * @author Igor Morais
 */
public class ImageActivity extends BaseAppCompatActivity {

    private static final String TAG = ImageActivity.class.getSimpleName();

    @Bind(R.id.crop_image_view)
    CropImageView cropImageView;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.image);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.avatar, menu);

        return true;
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {

        if (hasFocus) {

            final Uri uri = getIntent().getParcelableExtra(Constants.Bundle.URI);

            if (uri == null) {
                throw new IllegalStateException("The uri is null.");
            }

            final int width = cropImageView.getWidth();
            final int height = cropImageView.getHeight();

            cropImageView.setImageBitmap(BitmapUtility.scale(width, height, uri.getPath()));
        }
    }

    public void onSave(final MenuItem menuItem) {

        Random r = new Random();

        final String path = FileUtility.save(this,
                                             "GDS_" + r.nextInt(),
                                             Extension.JPG,
                                             cropImageView.getCroppedImage());

        final Intent intent = new Intent();

        intent.putExtra(Constants.Bundle.URI, Uri.parse(path));

        setResult(RESULT_OK, intent);

        finish();
    }
}

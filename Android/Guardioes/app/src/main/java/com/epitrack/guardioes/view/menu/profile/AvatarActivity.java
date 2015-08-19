package com.epitrack.guardioes.view.menu.profile;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.GridView;

import com.epitrack.guardioes.BuildConfig;
import com.epitrack.guardioes.R;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.utility.Extension;
import com.epitrack.guardioes.utility.Logger;
import com.epitrack.guardioes.utility.MediaUtility;
import com.epitrack.guardioes.view.BaseAppCompatActivity;
import com.epitrack.guardioes.view.menu.ImageActivity;

import java.io.File;

import butterknife.Bind;
import butterknife.OnClick;

public class AvatarActivity extends BaseAppCompatActivity implements AdapterView.OnItemClickListener {

    private static final String TAG = AvatarActivity.class.getSimpleName();

    @Bind(R.id.grid_view)
    GridView gridView;

    private File photoFile;

    private final SelectHandler handler = new SelectHandler();

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.avatar);

        gridView.setAdapter(new AvatarAdapter(this, Avatar.values()));

        gridView.setOnItemClickListener(this);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.avatar, menu);

        return true;
    }

    @Override
    public void onItemClick(final AdapterView<?> adapterView, final View view, final int position, final long id) {
        handler.update(view, (Avatar) adapterView.getItemAtPosition(position));
    }

    public void onSave(final MenuItem menuItem) {

        if (handler.getAvatar() == null) {

            // Mostrar messagem

        } else {

            final Intent intent = new Intent();

            intent.putExtra(Constants.Intent.AVATAR, handler.getAvatar());

            setResult(RESULT_OK, intent);

            finish();
        }
    }

    @OnClick(R.id.button_photo)
    public void onPhoto() {

        final Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

        intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(getPhotoFile()));

        startActivityForResult(intent, Constants.RequestCode.IMAGE);
    }

    @Override
    protected void onActivityResult(final int requestCode, final int resultCode, final Intent intent) {

        if (requestCode == Constants.RequestCode.IMAGE) {

            final Bundle bundle = new Bundle();

            bundle.putParcelable(Constants.Intent.URI, Uri.fromFile(getPhotoFile()));

            navigateTo(ImageActivity.class, Intent.FLAG_ACTIVITY_FORWARD_RESULT, bundle);

            finish();
        }
    }

    private File getPhotoFile() {

        // TODO: we need to put the name of the user.
        if (photoFile == null) {
            photoFile = MediaUtility.createTempFile("teste1", Extension.PNG, Environment.DIRECTORY_PICTURES);
        }

        return photoFile;
    }

    private class SelectHandler {

        private static final int COLOR_DESELECT = android.R.color.transparent;
        private static final int COLOR_SELECT = R.drawable.round_blue;

        private View view;
        private Avatar avatar;

        private void deselect() {

            if (view == null) {

                if (BuildConfig.DEBUG) {
                    Logger.logDebug(TAG, "The view is null.");
                }

            } else {

                view.setBackgroundResource(COLOR_DESELECT);
            }
        }

        private void select() {

            if (view == null) {

                if (BuildConfig.DEBUG) {
                    Logger.logDebug(TAG, "The view is null.");
                }

            } else {

                view.setBackgroundResource(COLOR_SELECT);
            }
        }

        public final Avatar getAvatar() {
            return avatar;
        }

        public final void update(final View view, final Avatar avatar) {

            deselect();

            this.view = view;
            this.avatar = avatar;

            select();
        }
    }
}

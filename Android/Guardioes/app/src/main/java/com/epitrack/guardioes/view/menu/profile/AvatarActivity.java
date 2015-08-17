package com.epitrack.guardioes.view.menu.profile;

import android.content.Intent;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.GridView;

import com.epitrack.guardioes.BuildConfig;
import com.epitrack.guardioes.R;
import com.epitrack.guardioes.utility.Logger;
import com.epitrack.guardioes.view.BaseAppCompatActivity;

import butterknife.Bind;
import butterknife.OnClick;

public class AvatarActivity extends BaseAppCompatActivity implements AdapterView.OnItemClickListener {

    private static final String TAG = AvatarActivity.class.getSimpleName();

    @Bind(R.id.grid_view)
    GridView gridView;

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

    public void onSave(final MenuItem menuItem) {

        if (handler.getAvatar() == null) {

        } else {

            setResult(RESULT_OK);
        }
    }

    @Override
    public void onItemClick(final AdapterView<?> adapterView, final View view, final int position, final long id) {
        handler.update(view, (Avatar) adapterView.getItemAtPosition(position));
    }

    @OnClick(R.id.button_photo)
    public void onPhoto() {
        startActivity(new Intent(MediaStore.ACTION_IMAGE_CAPTURE));
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

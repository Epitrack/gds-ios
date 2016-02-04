package com.epitrack.guardioes.view;

import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.service.AnalyticsApplication;
import com.epitrack.guardioes.utility.BitmapUtility;
import com.epitrack.guardioes.utility.DialogBuilder;
import com.epitrack.guardioes.utility.Extension;
import com.epitrack.guardioes.utility.FileUtility;
import com.epitrack.guardioes.utility.NetworkUtility;
import com.epitrack.guardioes.view.account.CreateAccountActivity;
import com.epitrack.guardioes.view.base.BaseFragment;
import com.epitrack.guardioes.view.diary.DiaryActivity;
import com.epitrack.guardioes.view.menu.profile.Avatar;
import com.epitrack.guardioes.view.menu.profile.ProfileActivity;
import com.epitrack.guardioes.view.survey.SelectParticipantActivity;
import com.epitrack.guardioes.view.tip.TipActivity;
import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * @author Igor Morais
 */
public class HomeFragment extends BaseFragment {

    @Bind(R.id.text_view_name)
    TextView textViewName;

    @Bind(R.id.image_view_photo)
    de.hdodenhof.circleimageview.CircleImageView imageViewPhoto;

    private Tracker mTracker;
    SingleUser singleUser = SingleUser.getInstance();

    @Override
    public void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        // [START shared_tracker]
        // Obtain the shared Tracker instance.
        AnalyticsApplication application = (AnalyticsApplication) getActivity().getApplication();
        mTracker = application.getDefaultTracker();
        // [END shared_tracker]

        setDisplayTitle(false);
        setDisplayLogo(true);
    }

    @Nullable
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup viewGroup, Bundle bundle) {

        final View view = inflater.inflate(R.layout.home_fragment, viewGroup, false);

        ButterKnife.bind(this, view);

        loadImageProfile();

        String text = getString(R.string.message_hello);
        text = text.replace("{0}", singleUser.getNick());
        textViewName.setText(text);

        return view;
    }

    private void loadImageProfile() {

        String picture = singleUser.getPicture();

        if (singleUser.getPicture().length() > 2) {

            Uri uri = Uri.parse(singleUser.getPicture());

            DisplayMetrics metrics = getResources().getDisplayMetrics();
            int densityDpi = (int) (metrics.density * 160f);
            int width = 0;
            int height = 0;

            if (densityDpi == DisplayMetrics.DENSITY_LOW) {
                width = 90;
                height = 90;
            } else if (densityDpi == DisplayMetrics.DENSITY_MEDIUM) {
                width = 120;
                height = 120;
            } else if (densityDpi == DisplayMetrics.DENSITY_HIGH) {
                width = 180;
                height = 180;
            } else if (densityDpi >= DisplayMetrics.DENSITY_XHIGH) {
                width = 240;
                height = 240;
            }
            imageViewPhoto.getLayoutParams().width = width;
            imageViewPhoto.getLayoutParams().height = height;

            File file = new File(singleUser.getPicture());

            if (!file.exists()) {
                imageViewPhoto.setImageURI(uri);
                Drawable drawable = imageViewPhoto.getDrawable();
                imageViewPhoto.setImageDrawable(drawable);

                if (drawable == null) {
                    setDefaultAvatar();
                }
            } else {
                imageViewPhoto.setImageURI(uri);

            }

        } else {

            if (singleUser.getPicture().equals("")) {
                singleUser.setPicture("0");
            }

            if (Integer.parseInt(singleUser.getPicture()) == 0) {
                setDefaultAvatar();
            } else {
                imageViewPhoto.setImageResource(Avatar.getBy(Integer.parseInt(singleUser.getPicture())).getLarge());
            }
        }
    }

    private void setDefaultAvatar() {
        DisplayMetrics metrics = getResources().getDisplayMetrics();
        int densityDpi = (int) (metrics.density * 160f);
        int width = 0;
        int height = 0;

        if (densityDpi == DisplayMetrics.DENSITY_LOW) {
            width = 90;
            height = 90;
        } else if (densityDpi == DisplayMetrics.DENSITY_MEDIUM) {
            width = 120;
            height = 120;
        } else if (densityDpi == DisplayMetrics.DENSITY_HIGH) {
            width = 180;
            height = 180;
        } else if (densityDpi >= DisplayMetrics.DENSITY_XHIGH) {
            width = 240;
            height = 240;
        }

        imageViewPhoto.getLayoutParams().width = width;
        imageViewPhoto.getLayoutParams().height = height;

        if (singleUser.getGender().equals("M")) {

            if (singleUser.getRace().equals("branco") || singleUser.getRace().equals("amarelo")) {
                imageViewPhoto.setImageResource(R.drawable.image_avatar_6);
            } else {
                imageViewPhoto.setImageResource(R.drawable.image_avatar_4);
            }
        } else {

            if (singleUser.getRace().equals("branco") || singleUser.getRace().equals("amarelo")) {
                imageViewPhoto.setImageResource(R.drawable.image_avatar_8);
            } else {
                imageViewPhoto.setImageResource(R.drawable.image_avatar_7);
            }
        }
    }

    public void onResume() {
        super.onResume();
        //mTracker.setScreenName("Home Screen - " + this.getClass().getSimpleName());
        //mTracker.send(new HitBuilders.ScreenViewBuilder().build());
        loadImageProfile();
    }

    @OnClick(R.id.image_view_photo)
    public void showProfile() {

        if (NetworkUtility.isOnline(getActivity().getApplication())) {

            navigateTo(ProfileActivity.class);

        } else {

            new DialogBuilder(getActivity()).load()
                    .title(R.string.attention)
                    .content(R.string.network_fail)
                    .positiveText(R.string.ok)
                    .show();
        }
    }

    @OnClick(R.id.text_view_notice)
    public void onNews() {
        mTracker.send(new HitBuilders.EventBuilder()
                .setCategory("Action")
                .setAction("Notice Button")
                .build());

        if (NetworkUtility.isOnline(getActivity().getApplication())) {

            navigateTo(NoticeActivity.class);

        } else {

            new DialogBuilder(getActivity()).load()
                    .title(R.string.attention)
                    .content(R.string.network_fail)
                    .positiveText(R.string.ok)
                    .show();
        }
    }

    @OnClick(R.id.text_view_map)
    public void onMap() {
        mTracker.send(new HitBuilders.EventBuilder()
                .setCategory("Action")
                .setAction("Notice Button")
                .build());

        if (NetworkUtility.isOnline(getActivity().getApplication())) {

            navigateTo(MapSymptomActivity.class);

        } else {

            new DialogBuilder(getActivity()).load()
                    .title(R.string.attention)
                    .content(R.string.network_fail)
                    .positiveText(R.string.ok)
                    .show();
        }
    }

    @OnClick(R.id.text_view_tip)
    public void onTip() {
        mTracker.send(new HitBuilders.EventBuilder()
                .setCategory("Action")
                .setAction("Tip Button")
                .build());

        navigateTo(TipActivity.class);
    }

    @OnClick(R.id.text_view_diary)
    public void onDiary() {
        mTracker.send(new HitBuilders.EventBuilder()
                .setCategory("Action")
                .setAction("Diary of Health Button")
                .build());

        if (NetworkUtility.isOnline(getActivity().getApplication())) {

            navigateTo(DiaryActivity.class);

        } else {

            new DialogBuilder(getActivity()).load()
                    .title(R.string.attention)
                    .content(R.string.network_fail)
                    .positiveText(R.string.ok)
                    .show();
        }

    }

    @OnClick(R.id.text_view_join)
    public void onJoin() {
        mTracker.send(new HitBuilders.EventBuilder()
                .setCategory("Action")
                .setAction("Survey Button")
                .build());

        if (NetworkUtility.isOnline(getActivity().getApplication())) {

            navigateTo(SelectParticipantActivity.class);

        } else {

            new DialogBuilder(getActivity()).load()
                    .title(R.string.attention)
                    .content(R.string.network_fail)
                    .positiveText(R.string.ok)
                    .show();
        }
    }
}
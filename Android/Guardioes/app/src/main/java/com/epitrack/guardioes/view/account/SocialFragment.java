package com.epitrack.guardioes.view.account;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.content.IntentSender.SendIntentException;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.utility.Constants;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.GoogleApiClient.ConnectionCallbacks;
import com.google.android.gms.common.api.GoogleApiClient.OnConnectionFailedListener;
import com.google.android.gms.plus.Plus;
import com.twitter.sdk.android.Twitter;
import com.twitter.sdk.android.core.Callback;
import com.twitter.sdk.android.core.Result;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.twitter.sdk.android.core.TwitterException;
import com.twitter.sdk.android.core.TwitterSession;
import com.twitter.sdk.android.core.identity.TwitterAuthClient;

import java.util.Arrays;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import io.fabric.sdk.android.Fabric;

public class SocialFragment extends Fragment {

    private static final int REQUEST_CODE_GOOGLE = 6667;
    private static final int REQUEST_CODE_TWITTER = 0; // TODO: See
    private static final int REQUEST_CODE_FACEBOOK = 64206;

    private static final String FACEBOOK_PERMISSION_PUBLIC_PROFILE = "public_profile";

    @Bind(R.id.fragment_button_facebook)
    Button buttonFaceBook;

    @Bind(R.id.button_google)
    Button buttonGoogle;

    @Bind(R.id.button_twitter)
    Button buttonTwitter;

    private GoogleApiClient authGoogle;
    private TwitterAuthClient authTwitter;

    private final CallbackManager listenerManager = CallbackManager.Factory.create();

    private OnSocialAccountListener listener;

    @Override
    public void onAttach(final Activity activity) {
        super.onAttach(activity);

        if (!(activity instanceof OnSocialAccountListener)) {

            throw new IllegalStateException("The " +
                    activity.getClass().getSimpleName() + " must implement OnSocialAccountListener.");
        }

        listener = (OnSocialAccountListener) activity;
    }

    @Nullable
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup viewGroup, final Bundle bundle) {

        final View view = inflater.inflate(R.layout.social, viewGroup, false);

        ButterKnife.bind(this, view);

        return view;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();

        ButterKnife.unbind(this);
    }

    @OnClick(R.id.button_google)
    public void onGoogle() {

        loadGoogle(getActivity());

        authGoogle.connect();
    }

    @OnClick(R.id.button_twitter)
    public void onTwitter() {

        loadTwitter(getActivity());

        authTwitter.authorize(getActivity(), new TwitterHandler());
    }

    @OnClick(R.id.fragment_button_facebook)
    public void onFaceBook() {

        loadFaceBook(getActivity());

        final LoginManager loginManager = LoginManager.getInstance();

        loginManager.logInWithReadPermissions(getActivity(),
                                              Arrays.asList(FACEBOOK_PERMISSION_PUBLIC_PROFILE));

        loginManager.registerCallback(listenerManager, new FaceBookHandler());
    }

    @Override
    public void onActivityResult(final int requestCode, final int resultCode, final Intent intent) {

        if (requestCode == REQUEST_CODE_GOOGLE) {
            authGoogle.connect();

        } else if (requestCode == REQUEST_CODE_TWITTER) {
            authTwitter.onActivityResult(requestCode, resultCode, intent);

        } else if (requestCode == REQUEST_CODE_FACEBOOK) {
            listenerManager.onActivityResult(requestCode, resultCode, intent);
        }
    }

    private void loadGoogle(final Context context) {

        if (authGoogle == null) {

            final GoogleHandler handler = new GoogleHandler();

            authGoogle = new GoogleApiClient.Builder(context).addConnectionCallbacks(handler)
                                                             .addOnConnectionFailedListener(handler)
                                                             .addApi(Plus.API)
                                                             .addScope(Plus.SCOPE_PLUS_LOGIN)
                                                             .build();
        }
    }

    private void loadTwitter(final Context context) {

        if (authTwitter == null) {

            Fabric.with(context, new Twitter(new TwitterAuthConfig(Constants.Twitter.KEY,
                                                                   Constants.Twitter.SECRET)));

            authTwitter = new TwitterAuthClient();
        }
    }

    private void loadFaceBook(final Context context) {

        FacebookSdk.sdkInitialize(context);
    }

    private class TwitterHandler extends Callback<TwitterSession> {

        @Override
        public void success(final Result<TwitterSession> session) {
            listener.onSuccess();
        }

        @Override
        public void failure(final TwitterException e) {
            listener.onError();
        }
    }

    private class GoogleHandler implements ConnectionCallbacks, OnConnectionFailedListener {

        @Override
        public void onConnected(final Bundle bundle) {
            listener.onSuccess();

            // TODO: Disconect..
        }

        @Override
        public void onConnectionSuspended(final int i) {
            authGoogle.connect();
        }

        @Override
        public void onConnectionFailed(final ConnectionResult connectionResult) {

            if (connectionResult.hasResolution()) {

                try {

                    connectionResult.startResolutionForResult(getActivity(), REQUEST_CODE_GOOGLE);

                } catch (SendIntentException e) {
                    authGoogle.connect();
                }

            } else {

                // TODO: SHOW dialog
            }
        }
    }

    private class FaceBookHandler implements FacebookCallback<LoginResult> {

        @Override
        public void onSuccess(final LoginResult loginResult) {
            listener.onSuccess();
        }

        @Override
        public void onCancel() {
            listener.onCancel();
        }

        @Override
        public void onError(FacebookException e) {
            listener.onError();
        }
    }

    public void setEnable(final boolean enable) {

        buttonTwitter.setEnabled(enable);
        buttonFaceBook.setEnabled(enable);
        buttonGoogle.setEnabled(enable);
    }
}

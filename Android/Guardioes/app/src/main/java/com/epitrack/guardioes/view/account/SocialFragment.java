package com.epitrack.guardioes.view.account;

import android.content.Context;
import android.content.Intent;
import android.content.IntentSender.SendIntentException;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.epitrack.guardioes.R;
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

import java.util.Arrays;

import butterknife.ButterKnife;
import butterknife.OnClick;

public class SocialFragment extends Fragment {

    private static final int REQUEST_CODE_GOOGLE = 6667;
    private static final int REQUEST_CODE_FACEBOOK = 64206;

    private static final String FACEBOOK_PERMISSION_PUBLIC_PROFILE = "public_profile";

    private boolean inProgress;

    private GoogleApiClient accountManager;

    private final CallbackManager listenerManager = CallbackManager.Factory.create();

    private OnAccountListener listener;

    @Override
    public void onActivityCreated(@Nullable final Bundle bundle) {
        super.onActivityCreated(bundle);

        if (getActivity() instanceof OnAccountListener) {

            listener = (OnAccountListener) getActivity();

        } else {

            throw new IllegalStateException("The Activity must implement OnAccountListener.");
        }
    }

    @Nullable
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup viewGroup, final Bundle bundle) {

        final View view = inflater.inflate(R.layout.social_fragment, viewGroup, false);

        ButterKnife.inject(this, view);

        return view;
    }

    @Override
    public void onStop() {
        super.onStop();


    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();

        ButterKnife.reset(this);
    }

    @OnClick(R.id.social_fragment_button_gmail)
    public void onGmail() {

        loadGoogle(getActivity());

        accountManager.connect();
    }

    @OnClick(R.id.social_fragment_button_twitter)
    public void onTwitter() {

    }

    @OnClick(R.id.social_fragment_button_facebook)
    public void onFaceBook() {

        loadFaceBook(getActivity());

        final LoginManager loginManager = LoginManager.getInstance();

        loginManager.logInWithReadPermissions(this,
                                              Arrays.asList(FACEBOOK_PERMISSION_PUBLIC_PROFILE));

        loginManager.registerCallback(listenerManager, new FaceBookHandler());
    }

    @Override
    public void onActivityResult(final int requestCode, final int resultCode, final Intent intent) {

        if (requestCode == REQUEST_CODE_GOOGLE) {
            accountManager.connect();

        } else if (requestCode == REQUEST_CODE_FACEBOOK) {
            listenerManager.onActivityResult(requestCode, resultCode, intent);
        }
    }

    public class GoogleHandler implements ConnectionCallbacks, OnConnectionFailedListener {

        @Override
        public void onConnected(final Bundle bundle) {
            listener.onSuccess();
        }

        @Override
        public void onConnectionSuspended(final int i) {
            accountManager.connect();
        }

        @Override
        public void onConnectionFailed(final ConnectionResult connectionResult) {

            if (connectionResult.hasResolution()) {

                try {

                    connectionResult.startResolutionForResult(getActivity(), REQUEST_CODE_GOOGLE);

                } catch (SendIntentException e) {
                    accountManager.connect();
                }

            } else {
                // TODO: SHOW dialog
            }
        }
    }

    public class TwitterHandler {

    }

    public class FaceBookHandler implements FacebookCallback<LoginResult> {

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

    private void loadGoogle(final Context context) {

        if (accountManager == null) {

            final GoogleHandler handler = new GoogleHandler();

            accountManager = new GoogleApiClient.Builder(context).addConnectionCallbacks(handler)
                                                                 .addOnConnectionFailedListener(handler)
                                                                 .addApi(Plus.API)
                                                                 .addScope(Plus.SCOPE_PLUS_LOGIN)
                                                                 .build();
        }
    }

    private void loadTwitter() {

    }

    private void loadFaceBook(final Context context) {

        FacebookSdk.sdkInitialize(context);
    }
}

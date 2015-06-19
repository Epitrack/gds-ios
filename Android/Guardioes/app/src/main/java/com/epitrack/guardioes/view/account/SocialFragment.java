package com.epitrack.guardioes.view.account;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.MainActivity;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;

import java.util.Arrays;

import butterknife.ButterKnife;
import butterknife.OnClick;

public class SocialFragment extends Fragment implements FacebookCallback<LoginResult>{

    private static final String FACEBOOK_PERMISSION_PUBLIC_PROFILE = "public_profile";

    private final CallbackManager listenerManager = CallbackManager.Factory.create();

    @Override
    public void onActivityCreated(@Nullable final Bundle bundle) {
        super.onActivityCreated(bundle);

        FacebookSdk.sdkInitialize(getActivity().getApplicationContext());
    }

    @Nullable
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup viewGroup, final Bundle bundle) {

        final View view = inflater.inflate(R.layout.social_fragment, viewGroup, false);

        ButterKnife.inject(this, view);

        return view;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();

        ButterKnife.reset(this);
    }

    @OnClick(R.id.social_fragment_button_gmail)
    public void onGmail() {

    }

    @OnClick(R.id.social_fragment_button_twitter)
    public void onTwitter() {

    }

    @OnClick(R.id.social_fragment_button_facebook)
    public void onFaceBook() {

        final LoginManager manager = LoginManager.getInstance();

        manager.logInWithReadPermissions(this,
                                         Arrays.asList(FACEBOOK_PERMISSION_PUBLIC_PROFILE));

        manager.registerCallback(listenerManager, this);
    }

    @Override
    public void onSuccess(final LoginResult loginResult) {

        final Intent intent = new Intent(getActivity(), MainActivity.class);

        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK |
                        Intent.FLAG_ACTIVITY_NEW_TASK);

        startActivity(intent);
    }

    @Override
    public void onCancel() {

    }

    @Override
    public void onError(FacebookException e) {

    }

    @Override
    public void onActivityResult(final int requestCode, final int resultCode, final Intent intent) {
        listenerManager.onActivityResult(requestCode, resultCode, intent);
    }
}

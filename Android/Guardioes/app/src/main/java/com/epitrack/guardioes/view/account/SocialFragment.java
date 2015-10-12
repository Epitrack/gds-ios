package com.epitrack.guardioes.view.account;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.content.IntentSender;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.DTO;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.view.Navigate;
import com.epitrack.guardioes.view.base.BaseFragment;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.GraphRequestAsyncTask;
import com.facebook.GraphResponse;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.plus.Plus;
import com.google.android.gms.plus.model.people.Person;
import com.twitter.sdk.android.Twitter;
import com.twitter.sdk.android.core.Callback;
import com.twitter.sdk.android.core.Result;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.twitter.sdk.android.core.TwitterException;
import com.twitter.sdk.android.core.TwitterSession;
import com.twitter.sdk.android.core.identity.TwitterAuthClient;

import org.json.JSONObject;

import java.util.Arrays;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import io.fabric.sdk.android.Fabric;

/**
 * @author Igor Morais
 */
public class SocialFragment extends BaseFragment {

    private static final int REQUEST_CODE_GOOGLE = 6667;
    private static final int REQUEST_CODE_TWITTER = 140; // TODO: See
    private static final int REQUEST_CODE_FACEBOOK = 64206;

    private static final String FACEBOOK_PERMISSION_PUBLIC_PROFILE = "public_profile";

    @Bind(R.id.fragment_button_facebook)
    Button buttonFaceBook;

    @Bind(R.id.button_google)
    Button buttonGoogle;

    @Bind(R.id.button_twitter)
    Button buttonTwitter;

    //@Bind(R.id.button_access_social)
    //Button buttonAccessSocial;
    private SocialAccountListener listener;

    @Override
    public void onAttach(final Activity activity) {
        super.onAttach(activity);

        if (!(activity instanceof SocialAccountListener)) {

            throw new IllegalStateException("The " +
                    activity.getClass().getSimpleName() + " must implement SocialAccountListener.");
        }

        listener = (SocialAccountListener) activity;
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

   //@OnClick(R.id.button_access_social)
    //public void onSocial() {
    //    navigateTo(SocialLoginActivity.class);
    //}

   @OnClick(R.id.button_google)
    public void onGoogle() {

        //loadGoogle(getActivity());
        //authGoogle.connect();

       DTO.object = Constants.Bundle.GOOGLE;
       navigateTo(SocialLoginActivity.class);
    }

    @OnClick(R.id.button_twitter)
    public void onTwitter() {

        //loadTwitter(getActivity().getApplicationContext());
        //authTwitter.authorize(getActivity(), new TwitterHandler());

        DTO.object = Constants.Bundle.TWITTER;
        navigateTo(SocialLoginActivity.class);
    }

    @OnClick(R.id.fragment_button_facebook)
    public void onFaceBook() {

        //loadFaceBook(getActivity());
        //final LoginManager loginManager = LoginManager.getInstance();
        //loginManager.logInWithReadPermissions(getActivity(),
        //        Arrays.asList(FACEBOOK_PERMISSION_PUBLIC_PROFILE));
        //loginManager.registerCallback(listenerManager, new FaceBookHandler());

        DTO.object = Constants.Bundle.FACEBOOK;
        navigateTo(SocialLoginActivity.class);

    }

   /* @Override
    public void onActivityResult(final int requestCode, final int resultCode, final Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        if (requestCode == REQUEST_CODE_GOOGLE) {
            authGoogle.connect();

        } else if (requestCode == REQUEST_CODE_TWITTER) {
            Fragment socialFragment = getChildFragmentManager().findFragmentByTag("social_fragment");
            if (socialFragment != null) {
                socialFragment.onActivityResult(requestCode, resultCode, intent);
            } else {
                authTwitter.onActivityResult(requestCode, resultCode, intent);
            }
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

    private void getDatabyGoogleApi() {
        try {

            if (authGoogle.isConnected()) {
                Person person = Plus.PeopleApi.getCurrentPerson(authGoogle);

                if (person != null) {

                    String personName = person.getDisplayName();
                    int genderInt = person.getGender();//0 for male, and 1 for female
                    String email = Plus.AccountApi.getAccountName(authGoogle);

                    singleUser.setEmail(email);
                    singleUser.setPassword(email);
                    singleUser.setNick(personName);
                    if (genderInt == 0) {
                        singleUser.setGender("M");
                    } else {
                        singleUser.setGender("F");
                    }
                    final Bundle bundle = new Bundle();

                    bundle.putString(Constants.Bundle.ACCESS_SOCIAL, Constants.Bundle.GOOGLE);
                    DTO.object = bundle;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void loadTwitter(final Context context) {

        if (authTwitter == null) {

            Fabric.with(context, new Twitter(new TwitterAuthConfig(Constants.Twitter.KEY,
                    Constants.Twitter.SECRET)));

            authTwitter = new TwitterAuthClient();

        }
    }

    private void getDataByTwitterApi() {

        twitterSession = Twitter.getSessionManager().getActiveSession();

        if (twitterSession != null) {

            singleUser.setNick(twitterSession.getUserName());

            TwitterAuthClient authClient = new TwitterAuthClient();
            authClient.requestEmail(twitterSession, new Callback<String>() {
                @Override
                public void success(Result<String> result) {
                    singleUser.setEmail(result.data);
                    singleUser.setPassword(result.data);
                }

                @Override
                public void failure(TwitterException e) {
                    Bundle dtoBundle = new Bundle();

                    dtoBundle.putString(Constants.Bundle.ACCESS_SOCIAL, Constants.Bundle.TWITTER);
                    DTO.object = dtoBundle;

                    listener.onError();
                }
            });
        }
    }

    private void loadFaceBook(final Context context) {

        FacebookSdk.sdkInitialize(context);
    }

    private class TwitterHandler extends Callback<TwitterSession> {

        @Override
        public void success(final Result<TwitterSession> session) {
            getDataByTwitterApi();
            listener.onSuccess();
        }

        @Override
        public void failure(final TwitterException e) {
            Bundle dtoBundle = new Bundle();

            dtoBundle.putString(Constants.Bundle.ACCESS_SOCIAL, Constants.Bundle.TWITTER);
            DTO.object = dtoBundle;

            listener.onError();
        }
    }

    private class GoogleHandler implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener {

        @Override
        public void onConnected(final Bundle bundle) {
            getDatabyGoogleApi();
            listener.onSuccess();
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

                } catch (IntentSender.SendIntentException e) {
                    authGoogle.connect();
                }

            } else {
                Bundle dtobundle = new Bundle();

                dtobundle.putString(Constants.Bundle.ACCESS_SOCIAL, Constants.Bundle.GOOGLE);
                DTO.object = dtobundle;
                listener.onError();
            }
        }
    }

    private void getDataByFacebook(LoginResult loginResult) {

        GraphRequestAsyncTask request = GraphRequest.newMeRequest(loginResult.getAccessToken(), new GraphRequest.GraphJSONObjectCallback() {
            @Override
            public void onCompleted(JSONObject objectUser, GraphResponse response) {
                if (objectUser != null) {
                    singleUser.setNick(objectUser.optString("name"));
                    singleUser.setEmail(objectUser.optString("email"));
                    singleUser.setPassword(objectUser.optString("email"));
                }
            }
        }).executeAsync();
    }

    private class FaceBookHandler implements FacebookCallback<LoginResult> {

        @Override
        public void onSuccess(final LoginResult loginResult) {
            getDataByFacebook(loginResult);
            listener.onSuccess();
        }

        @Override
        public void onCancel() {
            Bundle dtoBundle = new Bundle();

            dtoBundle.putString(Constants.Bundle.ACCESS_SOCIAL, Constants.Bundle.FACEBOOK);
            DTO.object = dtoBundle;

            listener.onError();
        }

        @Override
        public void onError(FacebookException e) {
            Bundle dtoBundle = new Bundle();

            dtoBundle.putString(Constants.Bundle.ACCESS_SOCIAL, Constants.Bundle.FACEBOOK);
            DTO.object = dtoBundle;

            listener.onError();
        }
    }*/

    public void setEnable(final boolean enable) {

        buttonTwitter.setEnabled(enable);
        buttonFaceBook.setEnabled(enable);
        buttonGoogle.setEnabled(enable);
        //buttonAccessSocial.setEnabled(enable);
    }
}

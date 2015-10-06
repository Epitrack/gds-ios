package com.epitrack.guardioes.view.account;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.content.IntentSender.SendIntentException;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Toast;

import com.afollestad.materialdialogs.MaterialDialog;
import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.model.User;
import com.epitrack.guardioes.request.Method;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.request.SimpleRequester;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.utility.DateFormat;
import com.epitrack.guardioes.utility.DialogBuilder;
import com.epitrack.guardioes.view.HomeActivity;
import com.epitrack.guardioes.view.base.BaseFragment;
import com.facebook.AccessToken;
import com.facebook.AccessTokenTracker;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.Profile;
import com.facebook.ProfileTracker;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.GoogleApiClient.ConnectionCallbacks;
import com.google.android.gms.common.api.GoogleApiClient.OnConnectionFailedListener;
import com.google.android.gms.plus.Plus;
import com.google.android.gms.plus.model.people.Person;
import com.twitter.sdk.android.Twitter;
import com.twitter.sdk.android.core.Callback;
import com.twitter.sdk.android.core.Result;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.twitter.sdk.android.core.TwitterException;
import com.twitter.sdk.android.core.TwitterSession;
import com.twitter.sdk.android.core.identity.TwitterAuthClient;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Arrays;
import java.util.concurrent.ExecutionException;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import io.fabric.sdk.android.Fabric;

/**
 * @author Igor Morais
 */
public class SocialFragment extends BaseFragment {

    private static final int REQUEST_CODE_GOOGLE = 6667;
    private static final int REQUEST_CODE_TWITTER = 0; // TODO: See
    private static final int REQUEST_CODE_FACEBOOK = 64206;

    private static final String FACEBOOK_PERMISSION_PUBLIC_PROFILE = "public_profile";

    private AccessTokenTracker accessTokenTracker;
    private AccessToken accessToken;
    private ProfileTracker profileTracker;

    SharedPreferences sharedPreferences = null;
    public static final String PREFS_NAME = "preferences_user_token";

    @Bind(R.id.fragment_button_facebook)
    Button buttonFaceBook;

    @Bind(R.id.button_google)
    Button buttonGoogle;

    @Bind(R.id.button_twitter)
    Button buttonTwitter;

    private GoogleApiClient authGoogle;
    private TwitterAuthClient authTwitter;

    private final CallbackManager listenerManager = CallbackManager.Factory.create();

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
        super.onActivityResult(requestCode, resultCode, intent);
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

    private void getDatabyGoogleApi() {
        try {

            if (authGoogle.isConnected()) {
                Person person = Plus.PeopleApi.getCurrentPerson(authGoogle);

                if (person != null) {

                    String personName = person.getDisplayName();
                    int genderInt = person.getGender();//0 for male, and 1 for female
                    String email = Plus.AccountApi.getAccountName(authGoogle);
                    User user = new User();

                    user.setEmail(email);
                    user.setPassword(email);
                    user.setNick(personName);
                    if (genderInt == 0) {
                        user.setGender("M");
                    } else {
                        user.setGender("F");
                    }
                    user.setDob("1997-01-01");
                    user.setGender("branco");

                    loginSocial(user);
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

        //if (authTwitter.)

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

            getDatabyGoogleApi();
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

                new DialogBuilder(getActivity().getApplicationContext()).load()
                        .title(R.string.attention)
                        .content(R.string.google_fail)
                        .positiveText(R.string.ok)
                        .show();
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

    private void loginSocial(User user) {

        JSONObject jsonObjectPut = new JSONObject();
        sharedPreferences = this.getActivity().getSharedPreferences(PREFS_NAME, 0);
        String prefUserToken = sharedPreferences.getString("preferences_user_token", "");

        try {

            if (!prefUserToken.equals("")) {
                SingleUser singleUser = SingleUser.getInstance();
                JSONObject jsonObject = new JSONObject();

                singleUser.setUser_token(prefUserToken);

                SimpleRequester sendPostRequest = new SimpleRequester();
                sendPostRequest.setUrl(Requester.API_URL + "user/lookup/");
                sendPostRequest.setJsonObject(jsonObject);
                sendPostRequest.setMethod(Method.GET);

                String jsonStr;

                jsonStr = sendPostRequest.execute(sendPostRequest).get();

                jsonObject = new JSONObject(jsonStr);

                if (jsonObject.get("error").toString() == "true") {
                    Toast.makeText(getActivity().getApplicationContext(), "Erro ao fazer o login. - " + jsonObject.get("message").toString(), Toast.LENGTH_SHORT).show();
                } else {

                    JSONObject jsonObjectUser = jsonObject.getJSONObject("data");

                    singleUser.setNick(jsonObjectUser.getString("nick").toString());
                    singleUser.setEmail(jsonObjectUser.getString("email").toString());
                    singleUser.setGender(jsonObjectUser.getString("gender").toString());
                    singleUser.setPicture(jsonObjectUser.getString("picture").toString());
                    singleUser.setId(jsonObjectUser.getString("id").toString());
                    singleUser.setRace(jsonObjectUser.getString("race").toString());
                    singleUser.setDob(jsonObjectUser.getString("dob").toString());
                    singleUser.setUser_token(jsonObjectUser.get("token").toString());

                    SharedPreferences settings = this.getActivity().getSharedPreferences(PREFS_NAME, 0);
                    SharedPreferences.Editor editor = settings.edit();
                    editor.putString("preferences_user_token", singleUser.getUser_token());
                    editor.commit();

                    navigateTo(HomeActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                            Intent.FLAG_ACTIVITY_NEW_TASK);
                }
            } else {
                jsonObjectPut.put("email", user.getEmail());
                jsonObjectPut.put("password", user.getPassword());
                jsonObjectPut.put("nick", user.getNick());
                jsonObjectPut.put("email", user.getEmail());
                jsonObjectPut.put("password", user.getPassword());
                jsonObjectPut.put("client", user.getClient());
                jsonObjectPut.put("dob", DateFormat.getDate(user.getDob()));
                jsonObjectPut.put("gender", user.getGender());
                jsonObjectPut.put("app_token", user.getApp_token());
                jsonObjectPut.put("race", user.getRace());
                jsonObjectPut.put("platform", user.getPlatform());

                SimpleRequester simpleRequester = new SimpleRequester();
                simpleRequester.setUrl(Requester.API_URL + "user/create");
                simpleRequester.setJsonObject(jsonObjectPut);
                simpleRequester.setMethod(Method.POST);

                String jsonStr = simpleRequester.execute(simpleRequester).get();

                JSONObject jsonObject = new JSONObject(jsonStr);

                if (jsonObject.get("error").toString() == "true") {
                    new DialogBuilder(getActivity().getApplicationContext()).load()
                            .title(R.string.attention)
                            .content(jsonObject.get("message").toString())
                            .positiveText(R.string.ok)
                            .show();
                } else {

                    jsonObject = new JSONObject();

                    jsonObject.put("email", user.getEmail());
                    jsonObject.put("password", user.getPassword());

                    SimpleRequester sendPostRequest = new SimpleRequester();
                    sendPostRequest.setUrl(Requester.API_URL + "user/login");
                    sendPostRequest.setJsonObject(jsonObject);
                    sendPostRequest.setMethod(Method.POST);

                    jsonStr = sendPostRequest.execute(sendPostRequest).get();

                    jsonObject = new JSONObject(jsonStr);

                    JSONObject jsonObjectUser = jsonObject.getJSONObject("user");

                    SingleUser singleUser = SingleUser.getInstance();
                    singleUser.setNick(jsonObjectUser.getString("nick").toString());
                    singleUser.setEmail(jsonObjectUser.getString("email").toString());
                    singleUser.setGender(jsonObjectUser.getString("gender").toString());
                    singleUser.setPicture(jsonObjectUser.getString("picture").toString());
                    singleUser.setId(jsonObjectUser.getString("id").toString());
                    singleUser.setRace(jsonObjectUser.getString("race").toString());
                    singleUser.setDob(jsonObjectUser.getString("dob").toString());
                    singleUser.setUser_token(jsonObject.get("token").toString());

                    sharedPreferences = this.getActivity().getSharedPreferences(PREFS_NAME, 0);
                    SharedPreferences.Editor editor = sharedPreferences.edit();

                    editor.putString("preferences_user_token", singleUser.getUser_token());
                    editor.commit();

                    navigateTo(HomeActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                            Intent.FLAG_ACTIVITY_NEW_TASK);
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
    }
}

package com.epitrack.guardioes.view;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.widget.Toast;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.manager.PrefManager;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.request.Method;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.request.SimpleRequester;
import com.epitrack.guardioes.service.AnalyticsApplication;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.view.base.BaseActivity;
import com.epitrack.guardioes.view.welcome.WelcomeActivity;
import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.concurrent.ExecutionException;

/**
 * @author Igor Morais
 */
public class SplashActivity extends BaseActivity implements Runnable {

    private static final long WAIT_TIME = 1500;

    private final Handler handler = new Handler();
    SharedPreferences sharedPreferences = null;

    private Tracker mTracker;
    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.splash);

        // [START shared_tracker]
        // Obtain the shared Tracker instance.
        AnalyticsApplication application = (AnalyticsApplication) getApplication();
        mTracker = application.getDefaultTracker();
        // [END shared_tracker]

        handler.postDelayed(this, WAIT_TIME);
    }

    @Override
    protected void onPause() {
        super.onPause();

        handler.removeCallbacks(this);
    }

    @Override
    public void onResume() {
        super.onResume();
        mTracker.setScreenName("Splash Screen - " + this.getClass().getSimpleName());
        mTracker.send(new HitBuilders.ScreenViewBuilder().build());
    }

    @Override
    public void run() {

        sharedPreferences = getSharedPreferences(Constants.Pref.PREFS_NAME, 0);
        String prefUserToken = sharedPreferences.getString(Constants.Pref.PREFS_NAME, "");

        if (!prefUserToken.equals("")) {

            SingleUser singleUser = SingleUser.getInstance();
            JSONObject jsonObject = new JSONObject();

            singleUser.setUser_token(prefUserToken);

            SimpleRequester sendPostRequest = new SimpleRequester();
            sendPostRequest.setUrl(Requester.API_URL + "user/lookup/");
            sendPostRequest.setJsonObject(jsonObject);
            sendPostRequest.setMethod(Method.GET);

            String jsonStr;
            try {
                jsonStr = sendPostRequest.execute(sendPostRequest).get();

                jsonObject = new JSONObject(jsonStr);

                if (jsonObject.get("error").toString() == "true") {
                    navigateTo(WelcomeActivity.class);
                } else {

                    JSONObject jsonObjectUser = jsonObject.getJSONObject("data");

                    singleUser.setNick(jsonObjectUser.getString("nick").toString());
                    singleUser.setEmail(jsonObjectUser.getString("email").toString());
                    singleUser.setGender(jsonObjectUser.getString("gender").toString());
                    singleUser.setId(jsonObjectUser.getString("id").toString());
                    singleUser.setRace(jsonObjectUser.getString("race").toString());
                    singleUser.setDob(jsonObjectUser.getString("dob").toString());
                    singleUser.setUser_token(jsonObjectUser.get("token").toString());

                    try {
                        singleUser.setPicture(jsonObjectUser.get("picture").toString());
                    } catch (Exception e) {
                        singleUser.setPicture("0");
                    }

                    singleUser.setHashtags(jsonObjectUser.getJSONArray("hashtags"));

                    SharedPreferences settings = getSharedPreferences(Constants.Pref.PREFS_NAME, 0);
                    SharedPreferences.Editor editor = settings.edit();
                    editor.putString(Constants.Pref.PREFS_NAME, singleUser.getUser_token());
                    editor.commit();

                    navigateTo(HomeActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                            Intent.FLAG_ACTIVITY_NEW_TASK);
                }
            } catch (InterruptedException e) {
                navigateTo(WelcomeActivity.class);
            } catch (ExecutionException e) {
                navigateTo(WelcomeActivity.class);
            } catch (JSONException e) {
                navigateTo(WelcomeActivity.class);
            }

        } else {
            navigateTo(WelcomeActivity.class);
        }
    }
}

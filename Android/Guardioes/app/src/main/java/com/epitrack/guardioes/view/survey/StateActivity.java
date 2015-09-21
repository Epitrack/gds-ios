package com.epitrack.guardioes.view.survey;

import android.os.Bundle;
import android.widget.Toast;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.model.User;
import com.epitrack.guardioes.request.Method;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.request.SimpleRequester;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.utility.LocationUtility;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.concurrent.ExecutionException;

import butterknife.OnClick;

/**
 * @author Igor Morais
 */
public class StateActivity extends BaseAppCompatActivity {

    String id;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        final boolean mainMember = getIntent().getBooleanExtra(Constants.Bundle.MAIN_MEMBER, false);

        if (mainMember) {
            SingleUser singleUser = SingleUser.getInstance();
            id = singleUser.getId();
        } else {
            id = getIntent().getStringExtra("id_user");
        }

        setContentView(R.layout.state);
    }

    @OnClick(R.id.text_view_state_good)
    public void onStateGood() {

        JSONObject jsonObject = new JSONObject();

        User user = new User();
        LocationUtility locationUtility = new LocationUtility(getApplicationContext());

        user.setId(id);
        user.setLat(locationUtility.getLatitude());
        user.setLon(locationUtility.getLongitude());

        try {
            jsonObject.put("user_id", user.getId());
            jsonObject.put("lat", user.getLat());
            jsonObject.put("lon", user.getLon());
            jsonObject.put("app_token", user.getApp_token());
            jsonObject.put("platform", user.getPlatform());
            jsonObject.put("client", user.getClient());
            jsonObject.put("no_symptom", "Y");


            SimpleRequester sendPostRequest = new SimpleRequester();
            sendPostRequest.setUrl(Requester.API_URL + "survey/create");
            sendPostRequest.setJsonObject(jsonObject);
            sendPostRequest.setMethod(Method.POST);

            String jsonStr = sendPostRequest.execute(sendPostRequest).get();

            jsonObject = new JSONObject(jsonStr);

            if (jsonObject.get("error").toString() == "true") {
                Toast.makeText(getApplicationContext(), jsonObject.get("message").toString(), Toast.LENGTH_SHORT).show();
            }
        } catch (JSONException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        navigateTo(ShareActivity.class);
    }

    @OnClick(R.id.text_view_state_bad)
    public void onStateBad() {
        final Bundle bundle = new Bundle();

        bundle.putString("id_user", id);
        navigateTo(SymptomActivity.class, bundle);
    }
}

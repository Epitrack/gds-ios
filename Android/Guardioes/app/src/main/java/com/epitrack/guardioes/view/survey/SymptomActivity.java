package com.epitrack.guardioes.view.survey;

import android.os.Bundle;
import android.text.InputType;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.afollestad.materialdialogs.MaterialDialog;
import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.model.Symptom;
import com.epitrack.guardioes.model.SymptomList;
import com.epitrack.guardioes.model.User;
import com.epitrack.guardioes.request.Method;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.request.SimpleRequester;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.utility.DialogBuilder;
import com.epitrack.guardioes.utility.LocationUtility;
import com.epitrack.guardioes.utility.SocialShare;
import com.epitrack.guardioes.view.HomeActivity;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import butterknife.Bind;
import butterknife.OnCheckedChanged;

/**
 * @author Igor Morais
 */
public class SymptomActivity extends BaseAppCompatActivity {

    boolean isExantematica = false;
    boolean isTravelLocation = false;
    String country = "";

    @Bind(R.id.list_view)
    ListView listView;

    List<SymptomList> symptomArray = new ArrayList<>();
    String id;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        id = getIntent().getStringExtra("id_user");

        setContentView(R.layout.symptom);

        final View footerView = LayoutInflater.from(this).inflate(R.layout.symptom_footer, null);

        footerView.findViewById(R.id.button_confirm).setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(final View view) {

                boolean isSelected = false;

                for (int i = 0; i < symptomArray.size(); i++) {
                    if (symptomArray.get(i).isSelected()) {
                        isSelected = true;
                    }
                }

                if (!isSelected) {
                    new DialogBuilder(SymptomActivity.this).load()
                            .title(R.string.attention)
                            .content(R.string.message_register_no_symptom)
                            .positiveText(R.string.ok)
                            .callback(new MaterialDialog.ButtonCallback() {

                            }).show();
                } else {

                    for (int i = 0; i < symptomArray.size(); i++) {
                        String symptomName = symptomArray.get(i).getCodigo();

                        if (symptomName.equals("hadTravelledAbroad")) {
                            isTravelLocation = true;
                            break;
                        }
                    }

                    if (isTravelLocation) {
                        isTravelLocation = false;
                        new DialogBuilder(SymptomActivity.this).load()
                                .title("Em qual país você esteve?")
                                .positiveText(R.string.ok)
                                .inputType(InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS)
                                .input("Ex: Estados Unidos", "", new MaterialDialog.InputCallback() {
                                    @Override

                                    public void onInput(MaterialDialog dialog, CharSequence input) {
                                        country = input.toString();
                                        confirmSendSymptons();
                                        new DialogBuilder(SymptomActivity.this).load()
                                                .title(R.string.app_name)
                                                .content(R.string.message_thanks_zika)
                                                .positiveText(R.string.ok)
                                                .show();
                                    }


                                }).negativeText("FECHAR")
                                .show();
                    } else {
                        confirmSendSymptons();
                    }
                }
            }
        });

        listView.addFooterView(footerView);

        SimpleRequester simpleRequester = new SimpleRequester();
        simpleRequester.setMethod(Method.GET);
        simpleRequester.setUrl(Requester.API_URL + "symptoms");
        simpleRequester.setJsonObject(null);

        try {
            String jsonStr = simpleRequester.execute(simpleRequester).get();
            JSONObject jsonObject = new JSONObject(jsonStr);

            if (jsonObject.get("error").toString() == "false") {

                JSONArray jsonArray = jsonObject.getJSONArray("data");

                if (jsonArray.length() > 0) {
                    for (int i = 0; i < jsonArray.length(); i++) {
                        JSONObject jsonObjectSymptoms = jsonArray.getJSONObject(i);
                        SymptomList symptomList = new SymptomList(jsonObjectSymptoms.get("code").toString(), jsonObjectSymptoms.get("name").toString());
                        symptomArray.add(symptomList);
                    }
                }
                symptomArray.add(new SymptomList("hadContagiousContact", "Tive contato com alguém com um desses sintomas"));
                symptomArray.add(new SymptomList("hadHealthCare", "Procurei um serviço de saúde"));
                symptomArray.add(new SymptomList("hadTravelledAbroad", "Estive fora do Brasil nos últimos 14 dias"));
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        }

        listView.setAdapter(new SymptomAdapter(this, symptomArray));
    }


    private void sendSymptom() throws JSONException, ExecutionException, InterruptedException {

        JSONObject jsonObject = new JSONObject();

        User user = new User();
        LocationUtility locationUtility = new LocationUtility(getApplicationContext());

        user.setId(id);
        user.setLat(locationUtility.getLatitude());
        user.setLon(locationUtility.getLongitude());

        SingleUser singleUser = SingleUser.getInstance();

        jsonObject.put("user_id", singleUser.getId());

        if (!(user.getId().equals(singleUser.getId()))) {
            jsonObject.put("household_id", user.getId());
        }
        jsonObject.put("lat", user.getLat());
        jsonObject.put("lon", user.getLon());
        jsonObject.put("app_token", user.getApp_token());
        jsonObject.put("platform", user.getPlatform());
        jsonObject.put("client", user.getClient());
        jsonObject.put("no_symptom", "N");
        jsonObject.put("token", singleUser.getUser_token());
        jsonObject.put("travelLocation", country);

        for (int i = 0; i < symptomArray.size(); i++) {

            String symptomName = symptomArray.get(i).getCodigo();

            if (symptomArray.get(i).isSelected()) {
                if(symptomName.equals("hadContagiousContact") || symptomName.equals("hadHealthCare") || symptomName.equals("hadTravelledAbroad")) {
                    jsonObject.put(symptomArray.get(i).getCodigo(), "true");
                } else {
                    jsonObject.put(symptomArray.get(i).getCodigo(), "Y");
                }
            }
        }

        SimpleRequester sendPostRequest = new SimpleRequester();
        sendPostRequest.setUrl(Requester.API_URL + "survey/create");
        sendPostRequest.setJsonObject(jsonObject);
        sendPostRequest.setMethod(Method.POST);

       String jsonStr = sendPostRequest.execute(sendPostRequest).get();

        jsonObject = new JSONObject(jsonStr);

        if (jsonObject.get("error").toString() == "true") {
            Toast.makeText(getApplicationContext(), jsonObject.get("message").toString(), Toast.LENGTH_SHORT).show();
        } else {
            if (jsonObject.get("exantematica").toString() == "true") {
                isExantematica = true;
            }
        }
    }

    @Override
    protected void onRestart() {
        super.onRestart();

        if (SocialShare.getInstance().isShared()) {
            new DialogBuilder(SymptomActivity.this).load()
                    .title(R.string.app_name)
                    .content(R.string.share_ok)
                    .positiveText(R.string.ok)
                    .callback(new MaterialDialog.ButtonCallback() {
                        @Override
                        public void onPositive(final MaterialDialog dialog) {
                            SocialShare.getInstance().setIsShared(false);
                            navigateTo(HomeActivity.class);
                        }
                    }).show();
        }
    }

    private void confirmSendSymptons() {
        new DialogBuilder(SymptomActivity.this).load()
                .title(R.string.attention)
                .content(R.string.message_register_info)
                .negativeText(R.string.no)
                .positiveText(R.string.yes)
                .callback(new MaterialDialog.ButtonCallback() {
                    @Override
                    public void onPositive(final MaterialDialog dialog) {
                    try {
                            sendSymptom();
                            if (isExantematica) {
                                navigateTo(ZikaActivity.class);
                            } else {
                                final Bundle bundle = new Bundle();
                                bundle.putBoolean(Constants.Bundle.BAD_STATE, true);
                                navigateTo(ShareActivity.class, bundle);
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        } catch (ExecutionException e) {
                            e.printStackTrace();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                }).show();
    }
}
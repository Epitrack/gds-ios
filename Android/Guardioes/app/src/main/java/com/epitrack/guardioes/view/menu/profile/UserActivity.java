package com.epitrack.guardioes.view.menu.profile;

import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.support.design.widget.TextInputLayout;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.afollestad.materialdialogs.MaterialDialog;
import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.model.User;
import com.epitrack.guardioes.request.Method;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.request.SimpleRequester;
import com.epitrack.guardioes.utility.BitmapUtility;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.utility.DateFormat;
import com.epitrack.guardioes.utility.DialogBuilder;
import com.epitrack.guardioes.view.HomeActivity;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.concurrent.ExecutionException;

import butterknife.Bind;
import butterknife.OnClick;

/**
 * @author Igor Morais
 */
public class UserActivity extends BaseAppCompatActivity {

    @Bind(R.id.text_view_message)
    TextView textViewMessage;

    @Bind(R.id.edit_text_nickname)
    EditText editTextNickname;

    @Bind(R.id.image_view_image)
    ImageView imageViewImage;

    @Bind(R.id.spinner_gender)
    Spinner spinnerGender;

    @Bind(R.id.spinner_race)
    Spinner spinnerRace;

    @Bind(R.id.edit_text_birth_date)
    EditText editTextBirthDate;

    @Bind(R.id.text_layout_mail)
    TextInputLayout textLayoutMail;

    @Bind(R.id.edit_text_mail)
    EditText editTextMail;

    @Bind(R.id.linear_layout_password)
    LinearLayout linearLayoutPassword;

    @Bind(R.id.edit_text_password)
    EditText editTextPassword;

    @Bind(R.id.edit_text_confirm_password)
    EditText editTextConfirmPassword;

    boolean socialNew;
    boolean newMenber;
    boolean mainMember;
    SingleUser singleUser = SingleUser.getInstance();

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        socialNew = getIntent().getBooleanExtra(Constants.Bundle.SOCIAL_NEW, false);
        newMenber = getIntent().getBooleanExtra(Constants.Bundle.NEW_MEMBER, false);
        mainMember = getIntent().getBooleanExtra(Constants.Bundle.MAIN_MEMBER, false);

        setContentView(R.layout.user);

        if (socialNew) {
            new DialogBuilder(UserActivity.this).load()
                    .title(R.string.attention)
                    .content(R.string.new_user_social_media)
                    .positiveText(R.string.ok)
                    .callback(new MaterialDialog.ButtonCallback() {
                        @Override
                        public void onPositive(final MaterialDialog dialog) {
                            loadUser();
                        }
                    }).show();
        } else {
            loadUser();
        }
    }

    private void loadUser() {
        String nick;
        String dob;
        String gender;
        String race;
        String email;

        if (socialNew) {
            nick = singleUser.getNick();
            dob = singleUser.getDob();
            gender = singleUser.getGender();
            race = singleUser.getRace();
            email = singleUser.getEmail();
        } else {
            nick = getIntent().getStringExtra("nick");
            dob = getIntent().getStringExtra("dob");
            gender = getIntent().getStringExtra("gender");
            race = getIntent().getStringExtra("race");
            email = getIntent().getStringExtra("email");
        }

        if (!newMenber || socialNew) {

            editTextNickname.setText(nick);

            if (dob != null) {
                editTextBirthDate.setText(DateFormat.getDate(dob, "dd/MM/yyyy"));
            }
            editTextMail.setText(email);

            if (race != null) {
                if (race.equals("branco")) {
                    spinnerRace.setSelection(0);
                } else if (race.equals("preto")) {
                    spinnerRace.setSelection(1);
                } else if (race.equals("pardo")) {
                    spinnerRace.setSelection(2);
                } else if (race.equals("amarelo")) {
                    spinnerRace.setSelection(3);
                } else if (race.equals("indígeno")) {
                    spinnerRace.setSelection(4);
                }
            }

            if (race == null) {
                race = "branco";
            }

            if (gender != null) {
                if (gender.equals("M")) {
                    spinnerGender.setSelection(0);
                } else {
                    spinnerGender.setSelection(1);
                }

                if (gender.equals("M")) {
                    if (race.equals("branco") || race.equals("amarelo")) {
                        imageViewImage.setImageResource(R.drawable.image_avatar_6);
                    } else {
                        imageViewImage.setImageResource(R.drawable.image_avatar_4);
                    }
                } else {

                    if (race.equals("branco") || race.equals("amarelo")) {
                        imageViewImage.setImageResource(R.drawable.image_avatar_8);
                    } else {
                        imageViewImage.setImageResource(R.drawable.image_avatar_7);
                    }
                }
            }

            if (mainMember) {
                textViewMessage.setText(R.string.message_fields);

                textLayoutMail.setVisibility(View.VISIBLE);
                editTextMail.setVisibility(View.VISIBLE);

                linearLayoutPassword.setVisibility(View.VISIBLE);
            } else if (socialNew) {
                if (singleUser.getEmail() == null) {
                    textLayoutMail.setVisibility(View.VISIBLE);
                    editTextMail.setVisibility(View.VISIBLE);
                    editTextMail.setEnabled(true);
                }
            }
        }
    }

    @OnClick(R.id.image_view_image)
    public void onImage() {
        navigateForResult(AvatarActivity.class, Constants.RequestCode.IMAGE);
    }

    @OnClick(R.id.button_add)
    public void onAdd() {
        //Miquéias Lopes
        User user = new User();

        //final boolean newMenber = getIntent().getBooleanExtra(Constants.Bundle.NEW_MEMBER, false);
        //final boolean mainMember = getIntent().getBooleanExtra(Constants.Bundle.MAIN_MEMBER, false);

        user.setNick(editTextNickname.getText().toString().trim());
        user.setDob(editTextBirthDate.getText().toString().trim().toLowerCase());
        String gender = spinnerGender.getSelectedItem().toString();
        gender = gender.substring(0, 1);
        user.setGender(gender.toUpperCase());
        user.setRace(spinnerRace.getSelectedItem().toString().toLowerCase());

        JSONObject jsonObject = new JSONObject();
        SimpleRequester simpleRequester = new SimpleRequester();

        try {
            jsonObject.put("nick", user.getNick());
            jsonObject.put("dob", DateFormat.getDate(user.getDob()));
            jsonObject.put("gender", user.getGender());
            jsonObject.put("race", user.getRace());
            jsonObject.put("client", user.getClient());
            jsonObject.put("race", user.getRace());

            if (!socialNew) {

                if (mainMember) {
                    String password = editTextPassword.getText().toString().trim();
                    String confirmPassword = editTextConfirmPassword.getText().toString().trim();

                    if (!password.equals("")) {
                        if (password.equals(confirmPassword)) {
                            user.setPassword(password);
                            jsonObject.put("password", user.getPassword());
                        }
                    }
                }

                if (newMenber) {
                    jsonObject.put("user", singleUser.getId());
                } else if (mainMember) {
                    jsonObject.put("id", singleUser.getId());
                } else {
                    jsonObject.put("id", getIntent().getStringExtra("id"));
                }

                if (newMenber) {
                    simpleRequester.setUrl(Requester.API_URL + "household/create");
                } else if (mainMember) {
                    simpleRequester.setUrl(Requester.API_URL + "user/update");
                } else {
                    simpleRequester.setUrl(Requester.API_URL + "household/update");
                }
            } else {
                jsonObject.put("password", singleUser.getPassword());
                jsonObject.put("app_token", user.getApp_token());
                jsonObject.put("platform", user.getPlatform());

                if (singleUser.getEmail() == null) {
                    jsonObject.put("email", editTextMail.getText().toString().toLowerCase());
                    jsonObject.put("password", editTextMail.getText().toString().toLowerCase());

                } else {
                    jsonObject.put("email", singleUser.getEmail());
                }

                simpleRequester.setUrl(Requester.API_URL + "user/create");
            }

            simpleRequester.setJsonObject(jsonObject);
            simpleRequester.setMethod(Method.POST);

            String jsonStr = simpleRequester.execute(simpleRequester).get();

            jsonObject = new JSONObject(jsonStr);

            if (jsonObject.get("error").toString() == "true") {
                Toast.makeText(getApplicationContext(), jsonObject.get("message").toString(), Toast.LENGTH_SHORT).show();
            } else {
                if (socialNew) {

                    JSONObject jsonObjectUser = jsonObject.getJSONObject("user");

                    singleUser.setNick(jsonObjectUser.getString("nick").toString());
                    singleUser.setEmail(jsonObjectUser.getString("email").toString());
                    singleUser.setGender(jsonObjectUser.getString("gender").toString());
                    singleUser.setPicture(jsonObjectUser.getString("picture").toString());
                    singleUser.setId(jsonObjectUser.getString("id").toString());
                    singleUser.setPassword(jsonObjectUser.getString("email").toString());
                    singleUser.setRace(jsonObjectUser.getString("race").toString());
                    singleUser.setDob(jsonObjectUser.getString("dob").toString());

                    SharedPreferences sharedPreferences = null;

                    jsonObject = new JSONObject();

                    jsonObject.put("email", singleUser.getEmail());
                    jsonObject.put("password", singleUser.getPassword());

                    simpleRequester = new SimpleRequester();
                    simpleRequester.setUrl(Requester.API_URL + "user/login");
                    simpleRequester.setJsonObject(jsonObject);
                    simpleRequester.setMethod(Method.POST);

                    jsonStr = simpleRequester.execute(simpleRequester).get();

                    jsonObject = new JSONObject(jsonStr);

                    if (jsonObject.get("error").toString() == "true") {
                        Toast.makeText(getApplicationContext(), "Erro - " + jsonObject.get("message").toString(), Toast.LENGTH_SHORT).show();
                    } else {
                        singleUser.setUser_token(jsonObject.get("token").toString());

                        sharedPreferences = getSharedPreferences(Constants.Pref.PREFS_NAME, 0);
                        SharedPreferences.Editor editor = sharedPreferences.edit();

                        editor.putString(Constants.Pref.PREFS_NAME, singleUser.getUser_token());
                        editor.commit();

                        sharedPreferences = getSharedPreferences(Constants.Pref.PREFS_SOCIAL, 0);
                        SharedPreferences.Editor editorSocial = sharedPreferences.edit();

                        editorSocial.putString(Constants.Pref.PREFS_NAME, "true");
                        editor.commit();
                    }


                    new DialogBuilder(UserActivity.this).load()
                            .title(R.string.attention)
                            .content(R.string.cadastro_sucesso)
                            .positiveText(R.string.ok)
                            .callback(new MaterialDialog.ButtonCallback() {
                                @Override
                                public void onPositive(final MaterialDialog dialog) {
                                    navigateTo(HomeActivity.class, Intent.FLAG_ACTIVITY_CLEAR_TASK |
                                            Intent.FLAG_ACTIVITY_NEW_TASK);
                                }
                            }).show();
                } else {
                    if (newMenber) {
                        Toast.makeText(getApplicationContext(), R.string.new_member_ok, Toast.LENGTH_SHORT).show();
                    } else if (mainMember) {
                        Toast.makeText(getApplicationContext(), R.string.generic_update_data_ok, Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(getApplicationContext(), R.string.generic_update_data_ok, Toast.LENGTH_SHORT).show();
                    }
                    navigateTo(ProfileActivity.class);
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

    @Override
    protected void onActivityResult(final int requestCode, final int resultCode, final Intent intent) {

        if (requestCode == Constants.RequestCode.IMAGE) {

            if (resultCode == RESULT_OK) {

                if (intent.hasExtra(Constants.Bundle.AVATAR)) {

                    final Avatar avatar = (Avatar) intent.getSerializableExtra(Constants.Bundle.AVATAR);

                    imageViewImage.setImageResource(avatar.getSmall());

                } else if (intent.hasExtra(Constants.Bundle.URI)) {

                    final Uri uri = intent.getParcelableExtra(Constants.Bundle.URI);

                    final int width = imageViewImage.getWidth();
                    final int height = imageViewImage.getHeight();

                    imageViewImage.setImageBitmap(BitmapUtility.scale(width, height, uri.getPath()));
                }
            }
        }
    }
}

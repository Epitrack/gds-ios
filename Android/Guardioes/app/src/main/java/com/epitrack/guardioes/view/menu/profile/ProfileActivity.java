package com.epitrack.guardioes.view.menu.profile;

import android.os.Bundle;
import android.view.MenuItem;
import android.widget.ListView;
import android.widget.Toast;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.model.User;
import com.epitrack.guardioes.request.Method;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.request.SimpleRequester;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.utility.DialogBuilder;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.concurrent.ExecutionException;

import butterknife.Bind;
import butterknife.OnClick;

/**
 * @author Igor Morais
 */
public class ProfileActivity extends BaseAppCompatActivity implements UserListener {

    @Bind(R.id.list_view)
    ListView listView;

    SingleUser singleUser = SingleUser.getInstance();

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.profile_activity);

        listView.setAdapter(new UserAdapter(this, new ArrayList<User>(), this));
    }

    @Override
    public boolean onOptionsItemSelected(final MenuItem item) {

        if (item.getItemId() == android.R.id.home) {
            onBackPressed();

        } else {
            super.onOptionsItemSelected(item);
        }
        return true;
    }

    @Override
    @OnClick(R.id.button_add)
    public void onAdd() {
        final Bundle bundle = new Bundle();

        bundle.putBoolean(Constants.Bundle.NEW_MEMBER, true);
        navigateTo(UserActivity.class, bundle);
    }

    @Override
    public void onEdit(final User user) {

        final Bundle bundle = new Bundle();

        bundle.putBoolean(Constants.Bundle.NEW_MEMBER, false);
        bundle.putString("nick", user.getNick());
        bundle.putString("dob", user.getDob());
        bundle.putString("gender", user.getGender());
        bundle.putString("race", user.getRace());
        bundle.putString("email", user.getEmail());
        bundle.putString("password", user.getPassword());
        bundle.putString("id", user.getId());

        // TODO: Check if is main member..
        if (singleUser.getId() == user.getId()) {
            bundle.putBoolean(Constants.Bundle.MAIN_MEMBER, true);
        }
        navigateTo(UserActivity.class, bundle);
    }

    @Override
    public void onDelete(final User user) {
        //Miquéias Lopes

        if (singleUser.getId() == user.getId()) {

            /*DialogBuilder dialogBuilder = new DialogBuilder(getApplicationContext());

            dialogBuilder.load().content(R.string.not_remove_member).build().show();*/

            Toast.makeText(getApplicationContext(), R.string.not_remove_member, Toast.LENGTH_SHORT).show();
        } else {

            SimpleRequester simpleRequester = new SimpleRequester();
            simpleRequester.setMethod(Method.GET);
            simpleRequester.setUrl(Requester.API_URL + "household/delete/" + user.getId() + "?client=api");
            simpleRequester.setJsonObject(null);

            try {
                String jsonStr = simpleRequester.execute(simpleRequester).get();

                JSONObject jsonObject = new JSONObject(jsonStr);

                if (jsonObject.get("error").toString() == "true") {
                    Toast.makeText(getApplicationContext(), R.string.generic_error, Toast.LENGTH_SHORT).show();

                    /*new DialogBuilder(ProfileActivity.this).load()
                            .title(R.string.attention)
                            .content(R.string.delete_user)
                            .positiveText(R.string.yes)
                            .show();*/

                } else {
                    Toast.makeText(getApplicationContext(), R.string.delete_user, Toast.LENGTH_SHORT).show();
                    listView.setAdapter(new UserAdapter(this, new ArrayList<User>(), this));
                }

            } catch (InterruptedException e) {
                Toast.makeText(getApplicationContext(), R.string.generic_error + " - " + e.getMessage(), Toast.LENGTH_SHORT).show();
            } catch (ExecutionException e) {
                Toast.makeText(getApplicationContext(), R.string.generic_error + " - " + e.getMessage(), Toast.LENGTH_SHORT).show();
            } catch (JSONException e) {
                Toast.makeText(getApplicationContext(), R.string.generic_error + " - " + e.getMessage(), Toast.LENGTH_SHORT).show();
            }
        }
    }
}

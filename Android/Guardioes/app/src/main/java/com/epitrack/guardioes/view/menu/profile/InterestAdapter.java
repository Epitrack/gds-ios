package com.epitrack.guardioes.view.menu.profile;

import android.content.Context;
import android.support.v7.widget.SwitchCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CompoundButton;
import android.widget.TextView;
import android.widget.Toast;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.request.Method;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.request.SimpleRequester;
import com.epitrack.guardioes.utility.Constants;
import com.epitrack.guardioes.view.IMenu;
import com.epitrack.guardioes.view.MenuListener;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.concurrent.ExecutionException;

/**
 * @author Igor Morais
 */
public class InterestAdapter extends ArrayAdapter<IMenu> {

    private final MenuListener listener;
    private Context context;
    JSONArray hashtags = SingleUser.getInstance().getHashtags();

    public InterestAdapter(final Context context, final MenuListener listener, final IMenu[] menuArray) {
        super(context, 0, menuArray);

        this.context = context;
        this.listener = listener;
    }

    public static class ViewHolder {

        TextView textViewName;
        SwitchCompat switchInterest;
    }

    @Override
    public View getView(final int position, final View convertView, final ViewGroup viewGroup) {
        View view = convertView;

        ViewHolder viewHolder;

        if (view == null) {

            view = LayoutInflater.from(viewGroup.getContext())
                                 .inflate(R.layout.interest_item, viewGroup, false);

            viewHolder = new ViewHolder();

            viewHolder.textViewName = (TextView) view.findViewById(R.id.text_view_name);
            viewHolder.switchInterest = (SwitchCompat) view.findViewById(R.id.switch_interest);

            viewHolder.switchInterest.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {

                    SimpleRequester simpleRequester = new SimpleRequester();

                    simpleRequester.setMethod(Method.POST);

                    JSONObject jsonObject = new JSONObject();

                    try {
                        String idHashtag = InterestTag.getBy(getItem(position).getId()).getIdApi();
                        jsonObject.put("hashtag_id", idHashtag);
                        String jsonStr;

                        if (isChecked) {
                            simpleRequester.setUrl(Requester.API_URL + "user/hashtags/add");
                            jsonStr = simpleRequester.execute(simpleRequester).get();
                            updateHashtagArray(idHashtag, Constants.General.ADD);
                        } else {
                            simpleRequester.setUrl(Requester.API_URL + "user/hashtags/remove");
                            jsonStr = simpleRequester.execute(simpleRequester).get();
                            updateHashtagArray(idHashtag, Constants.General.REMOVE);
                        }

                        jsonObject = new JSONObject(jsonStr);

                        if (jsonObject.get("error").toString().equals("false")) {
                            Toast.makeText(context, "Preferências atualizadas", Toast.LENGTH_SHORT).show();
                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    } catch (ExecutionException e) {
                        e.printStackTrace();
                    }
                }
            });

            view.setTag(viewHolder);

        } else {

            viewHolder = (ViewHolder) view.getTag();
        }

        if (hashtags.length() > 0) {
            for (int i = 0; i < hashtags.length(); i++) {
                try {
                    if (hashtags.getString(i) == InterestTag.getBy(getItem(position).getId()).getIdApi()) {
                        viewHolder.switchInterest.setSelected(true);
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }

        viewHolder.textViewName.setText(getItem(position).getName());

        return view;
    }

    private void updateHashtagArray(String idHashtag, String mode) {

        boolean exists = false;

        try {
            if (mode == Constants.General.ADD) {
                if (hashtags.length() > 0) {
                    for (int i = 0; i < hashtags.length(); i++) {
                        if (hashtags.getString(i).equals(idHashtag)) {
                            exists = true;
                        }
                    }
                }

                if (!exists) {
                    hashtags.put(idHashtag);
                }

            } else if (mode == Constants.General.REMOVE) {
                if (hashtags.length() > 0) {
                    for (int i = 0; i < hashtags.length(); i++) {
                        if (hashtags.getString(i).equals(idHashtag)) {
                            hashtags.remove(i);
                        }
                    }
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }
}

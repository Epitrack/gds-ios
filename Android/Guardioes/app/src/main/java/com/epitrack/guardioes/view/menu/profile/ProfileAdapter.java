package com.epitrack.guardioes.view.menu.profile;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.epitrack.guardioes.R;

public class ProfileAdapter extends ArrayAdapter<Profile> {

    public ProfileAdapter(final Context context, final Profile[] profileArray) {
        super(context, 0, profileArray);
    }

    public static class ViewHolder {

        TextView textViewName;
        TextView textViewMessage;
    }

    @Override
    public View getView(final int position, final View convertView, final ViewGroup viewGroup) {
        View view = convertView;

        ViewHolder viewHolder;

        if (view == null) {

            view = LayoutInflater.from(viewGroup.getContext())
                                 .inflate(R.layout.profile_item, viewGroup, false);

            viewHolder = new ViewHolder();

            viewHolder.textViewName = (TextView) view.findViewById(R.id.text_view_name);
            viewHolder.textViewMessage = (TextView) view.findViewById(R.id.text_view_message);

            view.setTag(viewHolder);

        } else {

            viewHolder = (ViewHolder) view.getTag();
        }

        final Profile profile = getItem(position);

        viewHolder.textViewName.setText(profile.getName());
        viewHolder.textViewMessage.setText(profile.getMessage());

        return view;
    }
}

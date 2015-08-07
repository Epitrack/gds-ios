package com.epitrack.guardioes.view.menu;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.kyleduo.switchbutton.SwitchButton;

public class SettingAdapter extends ArrayAdapter<Setting> {

    public SettingAdapter(final Context context, final Setting[] settingArray) {
        super(context, 0, settingArray);
    }

    public static class ViewHolder {

        TextView textViewName;
        SwitchButton switchButton;
    }

    @Override
    public View getView(final int position, final View convertView, final ViewGroup viewGroup) {
        View view = convertView;

        ViewHolder viewHolder;

        if (view == null) {

            view = LayoutInflater.from(viewGroup.getContext())
                                 .inflate(R.layout.item_setting, viewGroup, false);

            viewHolder = new ViewHolder();

            viewHolder.textViewName = (TextView) view.findViewById(R.id.setting_name);
            viewHolder.switchButton = (SwitchButton) view.findViewById(R.id.setting_switch_button);

            view.setTag(viewHolder);

        } else {

            viewHolder = (ViewHolder) view.getTag();
        }

        final String name = viewGroup.getContext().getString(getItem(position).getName());

        viewHolder.textViewName.setText(name);

        return view;
    }
}

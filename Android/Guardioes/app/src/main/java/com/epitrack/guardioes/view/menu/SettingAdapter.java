package com.epitrack.guardioes.view.menu;

import android.content.Context;
import android.support.v7.widget.SwitchCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.epitrack.guardioes.R;

/**
 * @author Igor Morais
 */
public class SettingAdapter extends ArrayAdapter<Setting> {

    public SettingAdapter(final Context context, final Setting[] settingArray) {
        super(context, 0, settingArray);
    }

    public static class ViewHolder {

        TextView textViewName;
        SwitchCompat switchSetting;
    }

    @Override
    public View getView(final int position, final View convertView, final ViewGroup viewGroup) {
        View view = convertView;

        ViewHolder viewHolder;

        if (view == null) {

            view = LayoutInflater.from(viewGroup.getContext())
                                 .inflate(R.layout.setting_item, viewGroup, false);

            viewHolder = new ViewHolder();

            viewHolder.textViewName = (TextView) view.findViewById(R.id.text_view_name);
            viewHolder.switchSetting = (SwitchCompat) view.findViewById(R.id.switch_setting);

            view.setTag(viewHolder);

        } else {

            viewHolder = (ViewHolder) view.getTag();
        }

        viewHolder.textViewName.setText(getItem(position).getName());

        return view;
    }
}

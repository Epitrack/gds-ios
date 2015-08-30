package com.epitrack.guardioes.view.menu.profile;

import android.content.Context;
import android.support.v7.widget.SwitchCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.IMenu;
import com.epitrack.guardioes.view.MenuListener;

/**
 * @author Igor Morais
 */
public class InterestAdapter extends ArrayAdapter<IMenu> {

    private final MenuListener listener;

    public InterestAdapter(final Context context, final MenuListener listener, final IMenu[] menuArray) {
        super(context, 0, menuArray);

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

            view.setTag(viewHolder);

        } else {

            viewHolder = (ViewHolder) view.getTag();
        }

        viewHolder.textViewName.setText(getItem(position).getName());

        return view;
    }
}

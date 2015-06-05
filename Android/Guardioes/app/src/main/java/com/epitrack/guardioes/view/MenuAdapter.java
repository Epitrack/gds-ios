package com.epitrack.guardioes.view;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.epitrack.guardioes.R;

public class MenuAdapter extends ArrayAdapter<Screen> {

    public MenuAdapter(final Context context, final Screen[] screenArray) {
        super(context, 0, screenArray);
    }

    static class ViewHolder {
        TextView name;
        ImageView icon;
    }

    @Override
    public View getView(final int position, final View convertView, final ViewGroup parent) {
        View view = convertView;

        ViewHolder viewHolder;

        if (view == null) {

            final LayoutInflater inflater = (LayoutInflater) getContext().getSystemService(
                    Context.LAYOUT_INFLATER_SERVICE);

            view = inflater.inflate(R.layout.menu_item, parent, false);

            viewHolder = new ViewHolder();

            viewHolder.name = (TextView) view.findViewById(R.id.menu_text_view_name);
            viewHolder.icon = (ImageView) view.findViewById(R.id.menu_image_view_icon);

            view.setTag(viewHolder);

        } else {

            viewHolder = (ViewHolder) view.getTag();
        }

        final Screen screen = getItem(position);

        viewHolder.name.setText(getContext().getResources().getString(screen.getName()));
        viewHolder.icon.setImageResource(screen.getIcon());

        return view;
    }
}

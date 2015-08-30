package com.epitrack.guardioes.view.menu.profile;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;

import com.epitrack.guardioes.R;

/**
 * @author Igor Morais
 */
public class AvatarAdapter extends ArrayAdapter<Avatar> {

    public AvatarAdapter(final Context context, final Avatar[] avatarArray) {
        super(context, 0, avatarArray);
    }

    class ViewHolder {
        ImageView imageViewAvatar;
    }

    @Override
    public View getView(final int position, final View convertView, final ViewGroup viewGroup) {
        View view = convertView;

        ViewHolder viewHolder;

        if (view == null) {

            view = LayoutInflater.from(viewGroup.getContext())
                                 .inflate(R.layout.avatar_item, viewGroup, false);

            viewHolder = new ViewHolder();

            viewHolder.imageViewAvatar = (ImageView) view.findViewById(R.id.image_view_avatar);

            view.setTag(viewHolder);

        } else {

            viewHolder = (ViewHolder) view.getTag();
        }

        viewHolder.imageViewAvatar.setImageResource(getItem(position).getLarge());

        return view;
    }
}

package com.epitrack.guardioes.view.menu.profile;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.User;

import java.util.List;

/**
 * @author Igor Morais
 */
public class UserAdapter extends ArrayAdapter<User> {

    private final UserListener listener;

    public UserAdapter(final Context context, final List<User> userList, final UserListener listener) {
        super(context, 0, userList);

        // TODO: Stub

        userList.add(new User(R.drawable.image_avatar_small_2, "Aninha", "Você"));
        userList.add(new User(R.drawable.image_avatar_small_6, "Carol", "Membro do domicílio"));
        userList.add(new User(R.drawable.image_avatar_small_8, "Dudu", "Membro do domicílio"));
        userList.add(new User(R.drawable.image_avatar_small_8, "Dudu", "Membro do domicílio"));
        userList.add(new User(R.drawable.image_avatar_small_8, "Dudu", "Membro do domicílio"));
        userList.add(new User(R.drawable.image_avatar_small_8, "Dudu", "Membro do domicílio"));
        userList.add(new User(R.drawable.image_avatar_small_8, "Dudu", "Membro do domicílio"));
        userList.add(new User(R.drawable.image_avatar_small_8, "Dudu", "Membro do domicílio"));
        userList.add(new User(R.drawable.image_avatar_small_8, "Dudu", "Membro do domicílio"));
        userList.add(new User(R.drawable.image_avatar_small_8, "Dudu", "Membro do domicílio"));
        userList.add(new User(R.drawable.image_avatar_small_8, "Dudu", "Membro do domicílio"));
        userList.add(new User(R.drawable.image_avatar_small_8, "Dudu", "Membro do domicílio"));

        this.listener = listener;
    }

    class ViewHolder {

        TextView textViewName;
        TextView textViewType;
        ImageView imageViewImage;
    }

    @Override
    public View getView(final int position, final View convertView, final ViewGroup viewGroup) {
        View view = convertView;

        ViewHolder viewHolder;

        if (view == null) {

            view = LayoutInflater.from(viewGroup.getContext())
                                 .inflate(R.layout.user_item, viewGroup, false);

            viewHolder = new ViewHolder();

            viewHolder.textViewName = (TextView) view.findViewById(R.id.text_view_name);
            viewHolder.textViewType = (TextView) view.findViewById(R.id.text_view_type);
            viewHolder.imageViewImage = (ImageView) view.findViewById(R.id.image_view_image);

            view.findViewById(R.id.linear_layout).setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(final View itemView) {
                    listener.onEdit(getItem(position));
                }
            });

            view.findViewById(R.id.image_view_trash).setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(final View itemView) {
                    listener.onDelete(getItem(position));
                }
            });

            view.setTag(viewHolder);

        } else {

            viewHolder = (ViewHolder) view.getTag();
        }

        final User user = getItem(position);

        viewHolder.textViewName.setText(user.getNick());
        viewHolder.textViewType.setText(user.getType());
        viewHolder.imageViewImage.setImageResource(user.getImage());

        return view;
    }
}

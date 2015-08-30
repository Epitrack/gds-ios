package com.epitrack.guardioes.view.survey;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.epitrack.guardioes.R;

import java.util.ArrayList;
import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * @author Igor Morais
 */
public class ParentAdapter extends RecyclerView.Adapter<ParentAdapter.ViewHolder> {

    private final ParentListener listener;

    private List<Parent> parentList = new ArrayList<>();

    public ParentAdapter(final ParentListener listener, final List<Parent> parentList) {

        if (listener == null) {
            throw new IllegalArgumentException("The listener cannot be null.");
        }

        this.listener = listener;
        this.parentList = parentList;

        // TODO: Remove this.. Stub only

        final Parent parent1 = new Parent();
        parent1.name = "Aninha";
        parent1.age = 15;

        final Parent parent2 = new Parent();
        parent2.name = "Gui";
        parent2.age = 21;

        final Parent parent3 = new Parent();
        parent3.name = "Peu";
        parent3.age = 9;

        final Parent parent4 = new Parent();
        parent4.name = "Cadu";
        parent4.age = 28;

        final Parent parent5 = new Parent();
        parent5.name = "Cah";
        parent5.age = 25;

        final Parent parent6 = new Parent();
        parent6.name = "Gui";
        parent6.age = 22;

        final Parent parent7 = new Parent();
        parent7.name = "Ju";
        parent7.age = 18;

        parentList.add(parent1);
        parentList.add(parent2);
        parentList.add(parent3);
        parentList.add(parent4);
        parentList.add(parent5);
        parentList.add(parent6);
        parentList.add(parent7);
    }

    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        @Bind(R.id.text_view_name)
        TextView textViewName;

        @Bind(R.id.text_view_age)
        TextView textViewAge;

        @Bind(R.id.image_view_photo)
        ImageView imageViewPhoto;

        public ViewHolder(final View view) {
            super(view);

            ButterKnife.bind(this, view);

            view.setOnClickListener(this);
        }

        @Override
        public void onClick(final View view) {

            listener.onParentSelect();
        }
    }

    @Override
    public ViewHolder onCreateViewHolder(final ViewGroup viewGroup, final int viewType) {

        final View view = LayoutInflater.from(viewGroup.getContext())
                                        .inflate(R.layout.parent_item, viewGroup, false);

        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final ViewHolder viewHolder, final int position) {

        final Parent parent = parentList.get(position);

        viewHolder.textViewName.setText(parent.name);
        viewHolder.textViewAge.setText(parent.age + " Anos");

        if (position == 0 ) {
            viewHolder.imageViewPhoto.setImageResource(R.drawable.image_avatar_1);

        } else if (position == 1) {
            viewHolder.imageViewPhoto.setImageResource(R.drawable.image_avatar_2);

        } else if (position == 2) {
            viewHolder.imageViewPhoto.setImageResource(R.drawable.image_avatar_3);

        } else if (position == 3) {
            viewHolder.imageViewPhoto.setImageResource(R.drawable.image_avatar_4);

        } else if (position == 4) {
            viewHolder.imageViewPhoto.setImageResource(R.drawable.image_avatar_5);

        } else if (position == 5) {
            viewHolder.imageViewPhoto.setImageResource(R.drawable.image_avatar_6);

        } else if (position == 6) {
            viewHolder.imageViewPhoto.setImageResource(R.drawable.image_avatar_7);
        }
    }

    @Override
    public int getItemCount() {
        return parentList.size();
    }

    // TODO: Remove this.. Stub only

    public class Parent {

        public String name;
        public int age;
    }
}

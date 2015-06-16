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

import butterknife.ButterKnife;
import butterknife.InjectView;

public class ParentAdapter extends RecyclerView.Adapter<ParentAdapter.ViewHolder> {

    private final OnParentListener listener;

    private List<Parent> parentList = new ArrayList<>();

    public ParentAdapter(final OnParentListener listener) {

        if (listener == null) {
            throw new IllegalArgumentException("The listener cannot be null.");
        }

        this.listener = listener;

        // TODO: Remove this.. Stub only

        final Parent parent1 = new Parent();
        parent1.name = "Dudu";
        parent1.age = 11;

        final Parent parent2 = new Parent();
        parent2.name = "Igor";
        parent2.age = 26;

        final Parent parent3 = new Parent();
        parent3.name = "Igor";
        parent3.age = 26;

        final Parent parent4 = new Parent();
        parent4.name = "Igor";
        parent4.age = 26;

        final Parent parent5 = new Parent();
        parent5.name = "Igor";
        parent5.age = 26;

        final Parent parent6 = new Parent();
        parent6.name = "Igor";
        parent6.age = 26;

        final Parent parent7 = new Parent();
        parent7.name = "Igor";
        parent7.age = 26;

        final Parent parent8 = new Parent();
        parent8.name = "Igor";
        parent8.age = 26;

        final Parent parent9 = new Parent();
        parent9.name = "Igor";
        parent9.age = 26;

        final Parent parent10 = new Parent();
        parent10.name = "Igor";
        parent10.age = 26;

        parentList.add(parent1);
        parentList.add(parent2);
        parentList.add(parent3);
        parentList.add(parent4);
        parentList.add(parent5);
        parentList.add(parent6);
        parentList.add(parent7);
        parentList.add(parent8);
        parentList.add(parent9);
        parentList.add(parent10);
    }

    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        @InjectView(R.id.parent_text_view_name)
        TextView textViewName;

        @InjectView(R.id.parent_text_view_age)
        TextView textViewAge;

        @InjectView(R.id.parent_image_view_photo)
        ImageView imageViewPhoto;

        public ViewHolder(final View view) {
            super(view);

            ButterKnife.inject(this, view);

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
        viewHolder.imageViewPhoto.setImageResource(R.drawable.user_tumb);
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

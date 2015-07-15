package com.epitrack.guardioes.view.survey;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.widget.ImageView;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseAppCompatActivity;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class SelectParticipantActivity extends BaseAppCompatActivity implements OnParentListener {

    @Bind(R.id.select_participant_activity_text_view_name)
    TextView textViewName;

    @Bind(R.id.select_participant_activity_text_view_age)
    TextView textViewAge;

    @Bind(R.id.select_participant_activity_image_view_photo)
    ImageView imageViewPhoto;

    @Bind(R.id.select_participant_activity_recycler_view_parent)
    RecyclerView recyclerView;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.select_participant_activity);

        ButterKnife.bind(this);

        // TODO: Get content from Intent

        if (true) {

            textViewName.setText("Someone");
            textViewAge.setText("26 Anos");

            recyclerView.setHasFixedSize(true);

            recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));

            recyclerView.setAdapter(new ParentAdapter(this));
        }
    }

    @OnClick(R.id.select_participant_activity_image_view_photo)
    public void onUserSelect() {
        navigateTo(StateActivity.class);
    }

    @Override
    public void onParentSelect() {
        navigateTo(StateActivity.class);
    }
}

package com.epitrack.guardioes.view.survey;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.widget.ImageView;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.BaseAppCompatActivity;

import java.util.ArrayList;
import java.util.List;

import butterknife.Bind;
import butterknife.OnClick;

/**
 * @author Igor Morais
 */
public class SelectParticipantActivity extends BaseAppCompatActivity implements ParentListener {

    @Bind(R.id.text_view_name)
    TextView textViewName;

    @Bind(R.id.text_view_age)
    TextView textViewAge;

    @Bind(R.id.image_view_photo)
    ImageView imageViewAvatar;

    @Bind(R.id.recycler_view)
    RecyclerView recyclerView;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.select_participant);

        // TODO: Get content from Intent

        if (true) {

            textViewName.setText("Dudu");
            textViewAge.setText("24 Anos");

            recyclerView.setHasFixedSize(true);

            recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));

            // TODO: Need take real data
            final List<ParentAdapter.Parent> parentList = new ArrayList<>();

            recyclerView.setAdapter(new ParentAdapter(this, parentList));
        }
    }

    @OnClick(R.id.image_view_photo)
    public void onUserSelect() {
        navigateTo(StateActivity.class);
    }

    @Override
    public void onParentSelect() {
        navigateTo(StateActivity.class);
    }
}

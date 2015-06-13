package com.epitrack.guardioes.view.survey;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.Symptom;
import com.epitrack.guardioes.view.BaseAppCompatActivity;

import butterknife.ButterKnife;
import butterknife.InjectView;

public class SymptomActivity extends BaseAppCompatActivity {

    @InjectView(R.id.symptom_activity_recycler_view_symptom)
    RecyclerView recyclerView;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.symptom_activity);

        ButterKnife.inject(this);

        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        recyclerView.setAdapter(new SymptomAdapter(Symptom.values()));
    }
}

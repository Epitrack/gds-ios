package com.epitrack.guardioes.view.diary;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.User;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;
import com.epitrack.guardioes.view.survey.ParentListener;

import java.util.ArrayList;
import java.util.List;

import butterknife.Bind;

/**
 * @author Igor Morais
 */
public class DiaryActivity extends BaseAppCompatActivity implements ParentListener {

    @Bind(R.id.text_view_participation)
    TextView textViewParticipation;

    @Bind(R.id.text_view_good_percentage)
    TextView textViewGoodPercentage;

    @Bind(R.id.text_view_good_report)
    TextView textViewGoodReport;

    @Bind(R.id.text_view_bad_percentage)
    TextView textViewBadPercentage;

    @Bind(R.id.text_view_bad_report)
    TextView textViewBadReport;

    @Bind(R.id.text_view_day)
    TextView textViewDay;

    @Bind(R.id.text_view_date)
    TextView textViewDate;

    @Bind(R.id.text_view_symptom)
    TextView textViewSymptom;

    @Bind(R.id.recycler_view)
    RecyclerView recyclerView;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.diary);

        recyclerView.setHasFixedSize(true);

        recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));

        // TODO: Need take real data
        final List<MemberAdapter.Parent> parentList = new ArrayList<>();

        recyclerView.setAdapter(new MemberAdapter(this, parentList));

        // TODO: Stub
        setupView();
    }

    private void setupView() {

        // TODO: Stub

        textViewParticipation.setText("162 Participações");

        textViewGoodPercentage.setText("68% Bem");
        textViewGoodReport.setText("48.452 Relatórios");

        textViewBadPercentage.setText("32% Mal");
        textViewBadReport.setText("22.800 Relatórios");

        textViewDay.setText("Sexta-feira");
        textViewDate.setText("15 de maio");
        textViewSymptom.setText("7 Sintomas");
    }

    @Override
    public void onParentSelect(String id) {

    }
}

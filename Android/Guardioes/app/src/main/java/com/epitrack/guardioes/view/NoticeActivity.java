package com.epitrack.guardioes.view;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.epitrack.guardioes.R;

import butterknife.Bind;

public class NoticeActivity extends BaseAppCompatActivity implements NoticeListener {

    @Bind(R.id.recycler_view)
    RecyclerView recyclerView;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.notice);

        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        recyclerView.setAdapter(new NoticeAdapter(this));
    }

    @Override
    public void onNoticeSelect() {

    }
}

package com.epitrack.guardioes.view;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.epitrack.guardioes.R;

import butterknife.Bind;
import butterknife.ButterKnife;

public class NoticeActivity extends BaseAppCompatActivity implements OnNoticeListener {

    @Bind(R.id.news_activity_recycler_view_news)
    RecyclerView recyclerView;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.notice_activity);

        ButterKnife.bind(this);

        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        recyclerView.setAdapter(new NoticeAdapter(this));
    }

    @Override
    public void onNoticeSelect() {

    }
}

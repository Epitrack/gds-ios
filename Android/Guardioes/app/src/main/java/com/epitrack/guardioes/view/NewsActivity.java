package com.epitrack.guardioes.view;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.epitrack.guardioes.R;

import butterknife.ButterKnife;
import butterknife.InjectView;

public class NewsActivity extends BaseAppCompatActivity implements OnNewsListener {

    @InjectView(R.id.news_activity_recycler_view_news)
    RecyclerView recyclerView;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.news_activity);

        ButterKnife.inject(this);

        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        recyclerView.setAdapter(new NewsAdapter(this));
    }

    @Override
    protected void onResume() {
        super.onResume();

        getSupportActionBar().setTitle(R.string.news_activity_title);
    }

    @Override
    public void onNewsSelect() {

    }
}

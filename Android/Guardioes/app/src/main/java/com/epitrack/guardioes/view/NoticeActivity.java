package com.epitrack.guardioes.view;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.design.widget.CollapsingToolbarLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ImageView;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.Notice;

import java.util.ArrayList;
import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * @author Igor Morais
 */
public class NoticeActivity extends AppCompatActivity implements NoticeListener {

    @Bind(R.id.collapsing_toolbar)
    CollapsingToolbarLayout toolbarLayout;

    @Bind(R.id.toolbar)
    Toolbar toolbar;

    @Bind(R.id.text_view_title)
    TextView textViewTitle;

    @Bind(R.id.text_view_source)
    TextView textViewSource;

    @Bind(R.id.text_view_date)
    TextView textViewDate;

    @Bind(R.id.image_view_image)
    ImageView imageView;

    @Bind(R.id.recycler_view)
    RecyclerView recyclerView;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.notice);

        ButterKnife.bind(this);

        setSupportActionBar(toolbar);

        getSupportActionBar().setHomeButtonEnabled(true);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        // TODO: Need take data from server
        final List<Notice> noticeList = new ArrayList<>();

        setupHeader(new Notice());

        recyclerView.setHasFixedSize(true);

        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        recyclerView.setAdapter(new NoticeAdapter(this, noticeList));
    }

    @Override
    public boolean onCreateOptionsMenu(final Menu menu) {
        getMenuInflater().inflate(R.menu.notice, menu);

        return true;
    }

    public void onPrivacy(final MenuItem item) {

    }

    private void setupHeader(final Notice notice) {

        // TODO: Stub only
        notice.setTitle("Campanha de vacinação contra gripe começa em 4 de maio, diz ministro.");
        notice.setSource("saude.estadao.com.br");
        notice.setPublicationDate("10:20");

        textViewTitle.setText(notice.getTitle());
        textViewSource.setText(notice.getSource());
        textViewDate.setText(notice.getPublicationDate());
        imageView.setImageResource(R.drawable.stub_notice);
    }

    @Override
    public void onNoticeSelect(final Notice notice) {
        startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.google.com")));
    }
}

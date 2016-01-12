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
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.afollestad.materialdialogs.MaterialDialog;
import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.Notice;
import com.epitrack.guardioes.request.Method;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.request.SimpleRequester;
import com.epitrack.guardioes.service.AnalyticsApplication;
import com.epitrack.guardioes.utility.DialogBuilder;
import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

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

    private Tracker mTracker;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.notice);

        // [START shared_tracker]
        // Obtain the shared Tracker instance.
        AnalyticsApplication application = (AnalyticsApplication) getApplication();
        mTracker = application.getDefaultTracker();
        // [END shared_tracker]

        ButterKnife.bind(this);

        setSupportActionBar(toolbar);

        getSupportActionBar().setHomeButtonEnabled(true);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        setupHeader(new Notice());

        recyclerView.setHasFixedSize(true);

        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        recyclerView.setAdapter(new NoticeAdapter(this, getNoticeList()));

        getSupportActionBar().setTitle(R.string.notice);

    }

    private List<Notice> getNoticeList() {

        List<Notice> noticeList = new ArrayList<>();

        SimpleRequester simpleRequester = new SimpleRequester();
        simpleRequester.setMethod(Method.GET);
        simpleRequester.setUrl(Requester.API_URL + "news/get");

        try {
            String jsonStr = simpleRequester.execute(simpleRequester).get();
            JSONArray jsonArray = new JSONObject(jsonStr).getJSONObject("data").getJSONArray("statuses");

            if (jsonArray.length() > 0) {
                for (int i = 0; i < jsonArray.length(); i++) {
                    JSONObject jsonObject = jsonArray.getJSONObject(i);

                    Notice notice = new Notice();

                    notice.setTitle(jsonObject.get("text").toString());
                    notice.setSource("via @minsaude");

                    notice.setDrawable(R.drawable.stub1);
                    notice.setLink("https://twitter.com/minsaude/status/" + jsonObject.get("id_str").toString());

                    noticeList.add(notice);
                }
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return noticeList;
    }

    @Override
    public void onResume() {
        super.onResume();
        mTracker.setScreenName("Notice Screen - " + this.getClass().getSimpleName());
        mTracker.send(new HitBuilders.ScreenViewBuilder().build());
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
        imageView.setImageResource(R.drawable.img_news);
    }

    @Override
    public void onNoticeSelect(final Notice notice) {

        mTracker.send(new HitBuilders.EventBuilder()
                .setCategory("Action")
                .setAction("Show Notice")
                .build());

        new DialogBuilder(NoticeActivity.this).load()
                .title(R.string.attention)
                .content(R.string.open_link)
                .positiveText(R.string.yes)
                .negativeText(R.string.no)
                .callback(new MaterialDialog.ButtonCallback() {

                    @Override
                    public void onNegative(final MaterialDialog dialog) {

                    }

                    @Override
                    public void onPositive(final MaterialDialog dialog) {
                        startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(notice.getLink())));
                    }
                }).show();
    }
}

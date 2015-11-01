package com.epitrack.guardioes.view;

import android.app.SearchManager;
import android.app.SearchableInfo;
import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.support.v7.widget.SearchView;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.afollestad.materialdialogs.MaterialDialog;
import com.cocosw.bottomsheet.BottomSheet;
import com.epitrack.guardioes.R;
import com.epitrack.guardioes.manager.Loader;
import com.epitrack.guardioes.model.Point;
import com.epitrack.guardioes.request.Method;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.request.SimpleRequester;
import com.epitrack.guardioes.utility.DialogBuilder;
import com.epitrack.guardioes.utility.LocationUtility;
import com.epitrack.guardioes.view.base.AbstractBaseMapActivity;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mikephil.charting.charts.PieChart;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.PieData;
import com.github.mikephil.charting.data.PieDataSet;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.sothree.slidinguppanel.SlidingUpPanelLayout;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import butterknife.Bind;
import butterknife.OnClick;

/**
 * @author Igor Morais
 */
public class MapSymptomActivity extends AbstractBaseMapActivity implements SearchView.OnQueryTextListener {

    @Bind(R.id.text_view_city)
    TextView textViewCity;

    @Bind(R.id.text_view_state)
    TextView textViewState;

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

    @Bind(R.id.text_view_percentage_1)
    TextView textViewPercentage1;

    @Bind(R.id.progress_bar_1)
    ProgressBar progressBar1;

    @Bind(R.id.text_view_percentage_2)
    TextView textViewPercentage2;

    @Bind(R.id.progress_bar_2)
    ProgressBar progressBar2;

    @Bind(R.id.text_view_percentage_3)
    TextView textViewPercentage3;

    @Bind(R.id.progress_bar_3)
    ProgressBar progressBar3;

    @Bind(R.id.sliding_panel)
    SlidingUpPanelLayout slidingPanel;

    @Bind(R.id.pie_chart_diary)
    PieChart pieChart;

    @Bind(R.id.syndromes)
    TextView txtSyndromes;

    private MarkerOptions badMarkerOption;
    private MarkerOptions goodMarkerOption;
    private LocationUtility locationUtility;
    private SearchView searchVieww;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.map_symptom);

        locationUtility = new LocationUtility(getApplicationContext());

        if (locationUtility.getLocation() == null) {
            new DialogBuilder(MapSymptomActivity.this).load()
                    .title(R.string.attention)
                    .content(R.string.network_disable)
                    .positiveText(R.string.ok)
                    .callback(new MaterialDialog.ButtonCallback() {

                        @Override
                        public void onPositive(final MaterialDialog dialog) {
                            navigateTo(HomeActivity.class);
                        }

                    }).show();
        } else {

            final MapFragment mapFragment = (MapFragment) getFragmentManager()
                    .findFragmentById(R.id.fragment_map);

            mapFragment.getMapAsync(this);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(final Menu menu) {
        getMenuInflater().inflate(R.menu.map, menu);

        MenuItem searchItem = menu.findItem(R.id.search_survey);
        searchVieww = (SearchView) searchItem.getActionView();
        setupSearchView(searchItem);

        return true;
    }

    private void setupSearchView(MenuItem searchItem) {

        if (isAlwaysExpanded()) {
            searchVieww.setIconifiedByDefault(false);
        } else {
            searchItem.setShowAsActionFlags(MenuItem.SHOW_AS_ACTION_IF_ROOM
                    | MenuItem.SHOW_AS_ACTION_COLLAPSE_ACTION_VIEW);
        }

        SearchManager searchManager = (SearchManager) getSystemService(Context.SEARCH_SERVICE);
        if (searchManager != null) {
            List<SearchableInfo> searchables = searchManager.getSearchablesInGlobalSearch();

            SearchableInfo info = searchManager.getSearchableInfo(getComponentName());
            for (SearchableInfo inf : searchables) {
                if (inf.getSuggestAuthority() != null
                        && inf.getSuggestAuthority().startsWith("applications")) {
                    info = inf;
                }
            }
            searchVieww.setSearchableInfo(info);
        }

        searchVieww.setOnQueryTextListener(this);
    }

    public void onShare(final MenuItem menuItem) {

        new BottomSheet.Builder(this).sheet(R.menu.share)
                                     .grid()
                                     .show();
    }

    @OnClick(R.id.syndromes)
    public void onSyndromes() {

        new DialogBuilder(MapSymptomActivity.this).load()
                .title(R.string.attention)
                .content(R.string.syndromes_desc)
                .positiveText(R.string.ok)
                .show();
    }

    @OnClick(R.id.button_expand)
    public void onExpand() {

        if (slidingPanel.getPanelState() == SlidingUpPanelLayout.PanelState.COLLAPSED) {
            slidingPanel.setPanelState(SlidingUpPanelLayout.PanelState.EXPANDED);

        } else {
            slidingPanel.setPanelState(SlidingUpPanelLayout.PanelState.COLLAPSED);
        }
    }

    @Override
    public void onMapReady(final GoogleMap map) {
        super.onMapReady(map);

        if (locationUtility.getLocation() != null) {
            load();
            setupView();
        }
    }

    private void load() {

        Loader.with().getHandler().post(new Runnable() {

            @Override
            public void run() {

                try {

                    final List<Point> pointList = new ArrayList<Point>();

                    SimpleRequester simpleRequester = new SimpleRequester();
                    simpleRequester.setJsonObject(null);
                    simpleRequester.setMethod(Method.GET);
                    simpleRequester.setUrl(Requester.API_URL + "surveys/l?lon=" + locationUtility.getLongitude() + "&lat=" + locationUtility.getLatitude());

                    String jsonStr = simpleRequester.execute(simpleRequester).get();

                    JSONObject jsonObject = new JSONObject(jsonStr);

                    if (jsonObject.get("error").toString() == "true") {
                        Toast.makeText(getApplicationContext(), "Erro: " + jsonObject.get("message").toString(), Toast.LENGTH_SHORT).show();
                    } else {

                        JSONArray jsonArray = jsonObject.getJSONArray("data");

                        for (int i = 0; i < jsonArray.length(); i++) {

                            Point point = new Point();

                            if (jsonArray.getJSONObject(i).get("no_symptom").equals("Y")) {
                                point.setSympton(false);
                            } else {
                                point.setSympton(true);
                            }

                            point.setLongitude(Double.parseDouble(jsonArray.getJSONObject(i).get("lon").toString()));
                            point.setLatitude(Double.parseDouble(jsonArray.getJSONObject(i).get("lat").toString()));

                            pointList.add(point);
                        }
                    }

                    if (pointList.size() > 0) {
                        new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {

                            @Override
                            public void run() {
                                addMarker(pointList);
                            }

                        }, 2000);
                    }

                } catch (InterruptedException e) {
                    e.printStackTrace();
                } catch (ExecutionException e) {
                    e.printStackTrace();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    private void addMarker(final List<Point> pointList) {

        final Handler handler = new Handler(Looper.getMainLooper());

        for (int i = 0; i < pointList.size(); i++) {

            final int count = i;

            final Point point = pointList.get(i);

            handler.post(new Runnable() {

                @Override
                public void run() {

                    final LatLng latLng = new LatLng(point.getLatitude(), point.getLongitude());

                    if (!point.isSympton()) {
                        getMap().addMarker(loadGoodMarkerOption().position(latLng));

                    } else {
                        getMap().addMarker(loadBadMarkerOption().position(latLng));
                    }
                }
            });
        }
    }

    private void setupView() {

        SimpleRequester simpleRequester = new SimpleRequester();
        simpleRequester.setUrl(Requester.API_URL + "surveys/summary/?lon=" + locationUtility.getLongitude() + "&lat=" + locationUtility.getLatitude());
        simpleRequester.setJsonObject(null);
        simpleRequester.setMethod(Method.GET);

        try {
            String jsonStr = simpleRequester.execute(simpleRequester).get();

            JSONObject jsonObject = new JSONObject(jsonStr);

            if (jsonObject.get("error").toString() == "true") {
                Toast.makeText(getApplicationContext(), "Erro: " + jsonObject.get("message").toString(), Toast.LENGTH_SHORT).show();
            } else {
                JSONObject jsonObjectData = jsonObject.getJSONObject("data");
                JSONObject jsonObjectLocation = jsonObjectData.getJSONObject("location");

                textViewCity.setText(jsonObjectLocation.get("city").toString());
                textViewState.setText(jsonObjectLocation.get("state").toString());
                textViewParticipation.setText(jsonObjectData.get("total_surveys").toString() + " Participações essa semana.");

                double totalNoSympton = Double.parseDouble(jsonObjectData.get("total_no_symptoms").toString());
                double goodPercent = 0;

                if (totalNoSympton > 0) {
                    goodPercent = (totalNoSympton / Double.parseDouble(jsonObjectData.get("total_surveys").toString()));
                }

                textViewGoodPercentage.setText((int)(goodPercent * 100) + "% Bem");
                textViewGoodReport.setText(jsonObjectData.get("total_no_symptoms").toString() + " Relatórios");

                double totalSympton = Double.parseDouble(jsonObjectData.get("total_symptoms").toString());
                double badPercent = 0;

                if (totalNoSympton > 0) {
                    badPercent = (totalSympton / Double.parseDouble(jsonObjectData.get("total_surveys").toString()));
                }

                textViewBadPercentage.setText((int)(badPercent * 100) + "% Mal");
                textViewBadReport.setText(jsonObjectData.get("total_symptoms").toString() + " Relatórios");

                JSONObject jsonObjectDiseases = jsonObjectData.getJSONObject("diseases");

                textViewPercentage1.setText(jsonObjectDiseases.get("diarreica").toString() + "%");
                progressBar1.setProgress(Integer.parseInt(jsonObjectDiseases.get("diarreica").toString()));

                textViewPercentage2.setText(jsonObjectDiseases.get("exantematica").toString() + "%");
                progressBar2.setProgress(Integer.parseInt(jsonObjectDiseases.get("exantematica").toString()));

                textViewPercentage3.setText(jsonObjectDiseases.get("respiratoria").toString() + "%");
                progressBar3.setProgress(Integer.parseInt(jsonObjectDiseases.get("respiratoria").toString()));

                //Pie Char Config
                pieChart.setUsePercentValues(false);
                pieChart.setDescription("");
                pieChart.setDrawCenterText(false);
                pieChart.setDrawSliceText(false);
                pieChart.setDrawHoleEnabled(false);
                pieChart.setHoleColorTransparent(false);
                pieChart.setHoleRadius(7);
                pieChart.setTransparentCircleRadius(10);
                pieChart.setRotationAngle(0);
                pieChart.setClickable(false);
                pieChart.setRotationEnabled(false);

                setData(badPercent, goodPercent);
            }

            } catch (InterruptedException e) {
                e.printStackTrace();
            } catch (ExecutionException e) {
                e.printStackTrace();
            } catch (JSONException e){
                e.printStackTrace();
            }
        }

    private void setData(double badPercent, double goodPercent) {

        float[] yData = { (int)(badPercent * 100), (int)(goodPercent * 100)};
        String[] xData = { "Mal", "Bem" };

        ArrayList<Entry> yVals1 = new ArrayList<Entry>();

        for (int i = 0; i < yData.length; i++)
            yVals1.add(new Entry(yData[i], i));

        ArrayList<String> xVals = new ArrayList<String>();

        for (int i = 0; i < xData.length; i++)
            xVals.add(xData[i]);

        PieDataSet dataSet = new PieDataSet(yVals1, "");
        dataSet.setSliceSpace(2);
        dataSet.setSelectionShift(2);

        int colors[] = {Color.parseColor("#FF0000"),Color.parseColor("#CCCC00")};

        dataSet.setColors(colors);

        PieData data = new PieData(xVals, dataSet);
        data.setDrawValues(false);
        data.setHighlightEnabled(false);

        pieChart.setData(data);
        pieChart.invalidate();
    }

    private MarkerOptions loadBadMarkerOption() {

        if (badMarkerOption == null) {
            badMarkerOption = new MarkerOptions().icon(BitmapDescriptorFactory.fromResource(R.drawable.icon_bad_small));
        }

        return badMarkerOption;
    }

    private MarkerOptions loadGoodMarkerOption() {

        if (goodMarkerOption == null) {
            goodMarkerOption = new MarkerOptions().icon(BitmapDescriptorFactory.fromResource(R.drawable.icon_good_small));
        }

        return goodMarkerOption;
    }

    @Override
    public boolean onMarkerClick(final Marker marker) {
        return true;
    }

    @Override
    public boolean onQueryTextSubmit(String query) {
        return false;
    }

    @Override
    public boolean onQueryTextChange(String newText) {
        return false;
    }

    protected boolean isAlwaysExpanded() {
        return false;
    }
}

package com.epitrack.guardioes.view;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.cocosw.bottomsheet.BottomSheet;
import com.epitrack.guardioes.R;
import com.epitrack.guardioes.manager.Loader;
import com.epitrack.guardioes.model.Point;
import com.epitrack.guardioes.request.Method;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.request.SimpleRequester;
import com.epitrack.guardioes.utility.LocationUtility;
import com.epitrack.guardioes.view.base.AbstractBaseMapActivity;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
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
public class MapSymptomActivity extends AbstractBaseMapActivity {

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

    private MarkerOptions badMarkerOption;
    private MarkerOptions goodMarkerOption;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.map_symptom);

        final MapFragment mapFragment = (MapFragment) getFragmentManager()
                .findFragmentById(R.id.fragment_map);

        mapFragment.getMapAsync(this);
    }

    @Override
    public boolean onCreateOptionsMenu(final Menu menu) {
        getMenuInflater().inflate(R.menu.map, menu);

        return true;
    }

    public void onShare(final MenuItem menuItem) {

        new BottomSheet.Builder(this).sheet(R.menu.share)
                                     .grid()
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

        load();

        setupView();
    }

    private void load() {

        Loader.with().getHandler().post(new Runnable() {

            @Override
            public void run() {

                try {

                    final List<Point> pointList = new ArrayList<Point>();
                    LocationUtility locationUtility = new LocationUtility(getApplicationContext());

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

                    //final InputStream inputStream = getAssets().open("upas.json");

                    //final List<Point> pointList = new ObjectMapper().readValue(inputStream, new TypeReference<List<Point>>() {
                    //});

                    if (pointList.size() > 0) {
                       new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {

                            @Override
                            public void run() {
                                addMarker(pointList);
                            }

                        }, 2000);
                    }

                }/* catch (IOException e) {
                    e.printStackTrace();
                } */catch (InterruptedException e) {
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

        // TODO: Stub

        textViewCity.setText("Recife");
        textViewState.setText("Pernambuco");
        textViewParticipation.setText("71.253 Participações essa semana");

        textViewGoodPercentage.setText("68% Bem");
        textViewGoodReport.setText("48.452 Relatórios");

        textViewBadPercentage.setText("32% Mal");
        textViewBadReport.setText("22.800 Relatórios");

        textViewPercentage1.setText("47%");
        progressBar1.setProgress(47);

        textViewPercentage2.setText("34%");
        progressBar2.setProgress(34);

        textViewPercentage3.setText("80%");
        progressBar3.setProgress(80);
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
}

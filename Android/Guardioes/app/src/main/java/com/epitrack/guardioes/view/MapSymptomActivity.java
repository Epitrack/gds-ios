package com.epitrack.guardioes.view;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.Menu;
import android.view.MenuItem;

import com.cocosw.bottomsheet.BottomSheet;
import com.epitrack.guardioes.R;
import com.epitrack.guardioes.manager.Loader;
import com.epitrack.guardioes.model.Point;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class MapSymptomActivity extends AbstractBaseMapActivity {

    private MarkerOptions badMarkerOption;
    private MarkerOptions goodMarkerOption;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.activity_map_symptom);

        final MapFragment mapFragment = (MapFragment) getFragmentManager()
                .findFragmentById(R.id.map_activity_fragment_map_symptom);

        mapFragment.getMapAsync(this);

        getSupportActionBar().setTitle(R.string.map_symptom_activity_title);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_map, menu);

        return true;
    }

    public void onShare(final MenuItem menuItem) {

        new BottomSheet.Builder(this).sheet(R.menu.menu_share)
                                     .grid()
                                     .show();
    }

    @Override
    public void onMapReady(final GoogleMap map) {
        super.onMapReady(map);

        load();
    }

    // TODO: Temporary
    private void load() {

        Loader.with().getHandler().post(new Runnable() {

            @Override
            public void run() {

                try {

                    final InputStream inputStream = getAssets().open("upas.json");

                    final List<Point> pointList = new ObjectMapper().readValue(inputStream, new TypeReference<List<Point>>() {
                    });

                    new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {

                        @Override
                        public void run() {
                            addMarker(pointList);
                        }

                    }, 2000);

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    // TODO: Stub..
    private void addMarker(final List<Point> pointList) {

        final Handler handler = new Handler(Looper.getMainLooper());

        for (int i = 0; i < pointList.size(); i++) {

            final int count = i;

            final Point point = pointList.get(i);

            handler.post(new Runnable() {

                @Override
                public void run() {

                    final LatLng latLng = new LatLng(point.getLatitude(), point.getLongitude());

                    if (count % 2 == 0) {
                        getMap().addMarker(loadGoodMarkerOption().position(latLng));

                    } else {
                        getMap().addMarker(loadBadMarkerOption().position(latLng));
                    }
                }
            });
        }
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

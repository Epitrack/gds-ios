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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MapSymptomActivity extends AbstractBaseMapActivity {

    private MarkerOptions markerOptionBad;
    private MarkerOptions markerOption;

    private final Map<Marker, Point> pointMap = new HashMap<>();

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.activity_map_symptom);

        final MapFragment mapFragment = (MapFragment) getFragmentManager()
                .findFragmentById(R.id.map_activity_fragment_map_symptom);

        mapFragment.getMapAsync(this);

        getSupportActionBar().setTitle(R.string.home_fragment_map);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_map, menu);

        return true;
    }

    public void onShare(final MenuItem menuItem) {

        new BottomSheet.Builder(this).sheet(R.menu.menu_share).grid().show();
    }

    @Override
    public void onMapReady(final GoogleMap map) {
        super.onMapReady(map);

        load();
    }

    // Temporary
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

    private void addMarker(final List<Point> pointList) {

        final Handler handler = new Handler(Looper.getMainLooper());

        for (final Point point : pointList) {

            handler.post(new Runnable() {

                @Override
                public void run() {

                    final LatLng latLng = new LatLng(point.getLatitude(), point.getLongitude());

                    final Marker marker = getMap().addMarker(loadMarkerOption().position(latLng));

                    pointMap.put(marker, point);
                }
            });
        }
    }

    private MarkerOptions loadMarkerOption() {

        if (markerOption == null) {
            markerOption = new MarkerOptions().icon(BitmapDescriptorFactory.fromResource(R.drawable.icon_bad_small));
        }

        return markerOption;
    }

    @Override
    public boolean onMarkerClick(final Marker marker) {
        return false;
    }
}

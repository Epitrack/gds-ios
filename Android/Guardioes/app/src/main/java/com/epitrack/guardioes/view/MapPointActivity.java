package com.epitrack.guardioes.view;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.LinearLayout;
import android.widget.TextView;

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

import butterknife.Bind;
import butterknife.ButterKnife;

public class MapPointActivity extends AbstractBaseMapActivity {

    @Bind(R.id.linear_layout)
    LinearLayout linearLayoutPoint;

    @Bind(R.id.text_view_name)
    TextView textViewName;

    @Bind(R.id.text_view_address)
    TextView textViewAddress;

    private MarkerOptions markerOption;

    private final Map<Marker, Point> pointMap = new HashMap<>();

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.map_point);

        ButterKnife.bind(this);

        final MapFragment mapFragment = (MapFragment) getFragmentManager()
                .findFragmentById(R.id.fragment_map);

        mapFragment.getMapAsync(this);

        getSupportActionBar().setTitle(R.string.map_point_activity_hospital_title);
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

                    final Marker marker = getMap().addMarker(getMarkerOption().position(latLng));

                    pointMap.put(marker, point);
                }
            });
        }
    }

    private MarkerOptions getMarkerOption() {

        if (markerOption == null) {
            markerOption = new MarkerOptions().icon(BitmapDescriptorFactory.fromResource(R.drawable.icon_hospital));
        }

        return markerOption;
    }

    @Override
    public boolean onMarkerClick(final Marker marker) {

        final Point point = pointMap.get(marker);

        textViewName.setText(point.getName());
        textViewAddress.setText(formatAddress(point));

        final Animation animation = AnimationUtils.loadAnimation(this, R.anim.slide_in_top);

        animation.setAnimationListener(new Animation.AnimationListener() {

            @Override
            public void onAnimationStart(final Animation animation) {

                if (linearLayoutPoint.getVisibility() == View.INVISIBLE) {
                    linearLayoutPoint.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onAnimationEnd(final Animation animation) {

            }

            @Override
            public void onAnimationRepeat(final Animation animation) {

            }
        });

        linearLayoutPoint.startAnimation(animation);

        return true;
    }

    private String formatAddress(final Point point) {
        return point.getLogradouro() + ", " + point.getNumero();
    }
}

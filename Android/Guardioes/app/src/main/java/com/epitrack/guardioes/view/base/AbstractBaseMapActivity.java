package com.epitrack.guardioes.view.base;

import android.location.Location;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.manager.LocationListener;
import com.epitrack.guardioes.manager.LocationManager;
import com.epitrack.guardioes.utility.LocationUtility;
import com.epitrack.guardioes.utility.Logger;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

/**
 * @author Igor Morais
 */
public abstract class AbstractBaseMapActivity extends BaseAppCompatActivity implements OnMapReadyCallback, GoogleMap.OnMarkerClickListener, LocationListener {

    private static final String TAG = AbstractBaseMapActivity.class.getSimpleName();

    private static final long DEFAULT_ZOOM = 12;

    private MarkerOptions markerOption;
    private Marker userMarker;

    private GoogleMap map;

    private LocationManager locationHandler;

    @Override
    public void onMapReady(final GoogleMap map) {
        setMap(map);

        locationHandler = new LocationManager(this, this);
    }

    @Override
    public void onLastLocation(final Location location) {

        final LatLng latLng = LocationUtility.toLatLng(location);

        getMap().animateCamera(CameraUpdateFactory.newLatLngZoom(latLng, DEFAULT_ZOOM), new GoogleMap.CancelableCallback() {

            @Override
            public void onFinish() {
                userMarker = getMap().addMarker(loadMarkerOption().position(latLng));
            }

            @Override
            public void onCancel() {

            }
        });
    }

    @Override
    public void onLocation(final Location location) {

        if (userMarker == null) {
            Logger.logDebug(TAG, "The user marker is null.");

        } else {
            userMarker.setPosition(LocationUtility.toLatLng(location));
        }
    }

    private MarkerOptions loadMarkerOption() {

        if (markerOption == null) {
            markerOption = new MarkerOptions().icon(BitmapDescriptorFactory.fromResource(R.drawable.icon));
        }

        return markerOption;
    }

    private void setMap(final GoogleMap map) {

        map.setOnMarkerClickListener(this);

        this.map = map;
    }

    public final GoogleMap getMap() {
        return map;
    }

    public final Marker getUserMarker() {
        return userMarker;
    }
}

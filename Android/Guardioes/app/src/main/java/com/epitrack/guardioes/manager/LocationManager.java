package com.epitrack.guardioes.manager;

import android.content.Context;
import android.location.Location;
import android.os.Bundle;
import android.os.Handler;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.GoogleApiClient.ConnectionCallbacks;
import com.google.android.gms.common.api.GoogleApiClient.OnConnectionFailedListener;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;


public class LocationManager extends BaseManager implements ConnectionCallbacks, OnConnectionFailedListener, LocationListener {

    private static final long INTERVAL = 1000;
    private static final long FASTESET_INTERVAL = 5000;
    private static final int  PRIORITY = LocationRequest.PRIORITY_HIGH_ACCURACY;

    private static final LocationRequest LOCATION_REQUEST = new LocationRequest().setInterval(INTERVAL)
                                                                                 .setFastestInterval(FASTESET_INTERVAL)
                                                                                 .setPriority(PRIORITY);

    private final Handler handler = new Handler();

    private GoogleApiClient locationManager;

    private final OnLocationListener listener;

    public LocationManager(final Context context, final OnLocationListener listener) {
        super(context);

        if (listener == null) {
            throw new IllegalArgumentException("The listener cannot be null.");
        }

        this.listener = listener;

        load();
    }

    private void load() {

        locationManager = new GoogleApiClient.Builder(getContext()).addConnectionCallbacks(this)
                                                                   .addOnConnectionFailedListener(this)
                                                                   .addApi(LocationServices.API)
                                                                   .build();

        locationManager.connect();
    }

    @Override
    public void onConnected(final Bundle bundle) {

        handler.post(new Runnable() {

            @Override
            public void run() {

                final Location location = LocationServices.FusedLocationApi.getLastLocation(locationManager);

                listener.onLastLocation(location);
            }
        });

        LocationServices.FusedLocationApi.requestLocationUpdates(locationManager, LOCATION_REQUEST, this);
    }

    @Override
    public void onConnectionSuspended(final int i) {
        locationManager.connect();
    }

    @Override
    public void onConnectionFailed(final ConnectionResult connectionResult) {

    }

    @Override
    public void onLocationChanged(final Location location) {

        handler.post(new Runnable() {

            @Override
            public void run() {

                listener.onLocation(location);
            }
        });
    }

    public final GoogleApiClient getLocationManager() {
        return locationManager;
    }
}

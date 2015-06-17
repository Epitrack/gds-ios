package com.epitrack.guardioes.manager;

import android.content.Context;
import android.location.Location;
import android.os.Bundle;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.GoogleApiClient.ConnectionCallbacks;
import com.google.android.gms.common.api.GoogleApiClient.OnConnectionFailedListener;
import com.google.android.gms.location.LocationServices;

public class LocationManager extends BaseManager implements ConnectionCallbacks, OnConnectionFailedListener {

    private GoogleApiClient locationManager;

    private final OnLocationListener listener;

    private LocationManager(final Context context, final OnLocationListener listener) {
        super(context);

        if (listener == null) {
            throw new IllegalArgumentException("The listener cannot be null.");
        }

        this.listener = listener;

        build();
    }

    @Override
    public void onConnected(final Bundle bundle) {

        final Location location = LocationServices.FusedLocationApi.getLastLocation(locationManager);

        listener.onLocationFound(location);
    }

    @Override
    public void onConnectionSuspended(final int i) {
        locationManager.connect();
    }

    @Override
    public void onConnectionFailed(final ConnectionResult connectionResult) {

    }

    private GoogleApiClient build() {

        if (locationManager == null) {

            locationManager = new GoogleApiClient.Builder(getContext()).addConnectionCallbacks(this)
                                                                       .addOnConnectionFailedListener(this)
                                                                       .addApi(LocationServices.API)
                                                                       .build();
        }

        return locationManager;
    }
}

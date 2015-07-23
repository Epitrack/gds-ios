package com.epitrack.guardioes.utility;

import android.location.Location;

import com.google.android.gms.maps.model.LatLng;

/**
 * Created by IgorMorais on 7/22/15.
 */
public final class LocationUtility {

    private LocationUtility() {

    }

    public static LatLng toLatLng(final Location location) {
        return new LatLng(location.getLatitude(), location.getLongitude());
    }
}

package com.epitrack.guardioes.manager;

import android.location.Location;

/**
 * @author Igor Morais
 */
public interface LocationListener {

    void onLastLocation(Location location);

    void onLocation(Location location);
}

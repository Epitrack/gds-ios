package com.epitrack.guardioes.manager;

import android.location.Location;

public interface LocationListener {

    void onLastLocation(Location location);

    void onLocation(Location location);
}

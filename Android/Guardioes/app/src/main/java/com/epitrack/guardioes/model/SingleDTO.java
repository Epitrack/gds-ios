package com.epitrack.guardioes.model;

import com.google.android.gms.maps.model.LatLng;

/**
 * @author Mmiquéias Lopes on
 */
public class SingleDTO {

    private static SingleDTO instance;
    private String dto;
    private LatLng latLng;

    private SingleDTO() {

    }

    public static synchronized SingleDTO getInstance() {

        if (instance == null) {
            instance = new SingleDTO();
            return instance;
        } else {
            return instance;
        }
    }

    public String getDto() {
        return dto;
    }

    public void setDto(String dto) {
        this.dto = dto;
    }

    public LatLng getLatLng() {
        return latLng;
    }

    public void setLatLng(LatLng latLng) {
        this.latLng = latLng;
    }
}

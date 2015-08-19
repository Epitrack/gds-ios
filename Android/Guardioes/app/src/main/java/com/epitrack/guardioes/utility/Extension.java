package com.epitrack.guardioes.utility;

public enum Extension {

    JPG(".jpg"), PNG(".png"), BITMAP(".bmp");

    private final String name;

    Extension(final String name) {
        this.name = name;
    }

    public final String getName() {
        return name;
    }
}

package com.epitrack.guardioes.model;

import android.net.Uri;

/**
 * @author Miqueias Lopes on 11/01/16.
 */
public class ProfileImage {

    private static ProfileImage instance;

    private String avatar;
    private android.net.Uri uri;

    private ProfileImage() {

    }

    public static synchronized ProfileImage getInstance() {

        if (instance == null) {
            instance = new ProfileImage();
            return instance;
        } else {
            return instance;
        }
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Uri getUri() {
        return uri;
    }

    public void setUri(Uri uri) {
        this.uri = uri;
    }
}

package com.epitrack.guardioes.model;

public class User {

    // TODO: This is for stub only.

    private int image;
    private String name;
    private String type;

    public User(final int image, final String name, final String type) {
        this.image = image;
        this.name = name;
        this.type = type;
    }

    public int getImage() {
        return image;
    }

    public void setImage(int image) {
        this.image = image;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}

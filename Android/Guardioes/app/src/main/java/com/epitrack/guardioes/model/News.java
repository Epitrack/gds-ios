package com.epitrack.guardioes.model;

public class News {

    private String title;
    private String source;
    private String date;

    public final String getTitle() {
        return title;
    }

    public final void setTitle(final String title) {
        this.title = title;
    }

    public final String getSource() {
        return source;
    }

    public final void setSource(final String source) {
        this.source = source;
    }

    public final String getDate() {
        return date;
    }

    public final void setDate(final String date) {
        this.date = date;
    }
}

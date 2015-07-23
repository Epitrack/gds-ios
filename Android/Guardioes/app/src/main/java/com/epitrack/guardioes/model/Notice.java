package com.epitrack.guardioes.model;

public class Notice {

    private String title;
    private String source;
    private String publicationDate;

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

    public final String getPublicationDate() {
        return publicationDate;
    }

    public final void setPublicationDate(final String publicationDate) {
        this.publicationDate = publicationDate;
    }
}

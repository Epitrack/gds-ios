package com.epitrack.guardioes.request;

/**
 * @author Igor Morais
 */
enum Header {

    ACCEPT ("Accept"),
    AUTHORIZATION ("Authorization"),
    CONTENT_LENGTH ("Content-Length"),
    CONTENT_TYPE ("Content-Type");

    private final String value;

    Header(final String value) {
        this.value = value;
    }

    public final String getValue() {
        return value;
    }
}

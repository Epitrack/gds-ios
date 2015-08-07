package com.epitrack.guardioes.request;

public enum ContentType implements IHeader {

    JSON ("application/json", Header.CONTENT_TYPE),
    URL_ENCODED ("application/x-www-form-urlencoded", Header.CONTENT_TYPE);

    private final String value;
    private final Header header;

    ContentType(final String value, final Header header) {
        this.value = value;
        this.header = header;
    }

    @Override
    public String getValue() {
        return value;
    }

    @Override
    public Header getHeader() {
        return header;
    }
}

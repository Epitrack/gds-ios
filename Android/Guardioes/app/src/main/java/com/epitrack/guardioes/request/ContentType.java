package com.epitrack.guardioes.request;

/**
 * @author Igor Morais
 */
enum ContentType implements IHeader {

    JSON ("application/json", Header.CONTENT_TYPE),
    URL_ENCODED ("application/x-www-form-urlencoded", Header.CONTENT_TYPE);

    private final String value;
    private final Header header;

    ContentType(final String value, final Header header) {
        this.value = value;
        this.header = header;
    }

    @Override
    public final String getValue() {
        return value;
    }

    @Override
    public final Header getHeader() {
        return header;
    }
}

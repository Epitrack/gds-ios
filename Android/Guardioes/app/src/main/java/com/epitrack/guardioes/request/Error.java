package com.epitrack.guardioes.request;

import java.nio.charset.Charset;
import java.util.Map;

public class Error {

    private StatusCode code;
    private String content;
    private Map<String, String> headerArray;

    public Error() {

    }

    public Error(final int code,
                 final byte[] content,
                 final Map<String, String> headerArray) {

        this.code = StatusCode.getBy(code);
        this.content = new String(content, Charset.defaultCharset());
        this.headerArray = headerArray;
    }

    public Error(final StatusCode code,
                 final String content,
                 final Map<String, String> headerArray) {

        this.code = code;
        this.content = content;
        this.headerArray = headerArray;
    }

    public final StatusCode getStatusCode() {
        return code;
    }

    public final void setStatusCode(final int code) {
        this.code = StatusCode.getBy(code);
    }

    public final void setStatusCode(final StatusCode code) {
        this.code = code;
    }

    public final String getContent() {
        return content;
    }

    public final void setContent(final byte[] content) {
        this.content = new String(content, Charset.defaultCharset());
    }

    public final void setContent(final String content) {
        this.content = content;
    }

    public final Map<String, String> getHeaderArray() {
        return headerArray;
    }

    public final void setHeaderArray(final Map<String, String> headerArray) {
        this.headerArray = headerArray;
    }
}

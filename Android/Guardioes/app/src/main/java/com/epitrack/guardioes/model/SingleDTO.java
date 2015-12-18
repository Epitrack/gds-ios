package com.epitrack.guardioes.model;

/**
 * @author Mmiquéias Lopes on
 */
public class SingleDTO {

    private static SingleDTO instance;
    private String dto;

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
}

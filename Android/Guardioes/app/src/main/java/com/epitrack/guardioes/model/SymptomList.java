package com.epitrack.guardioes.model;

/**
 * @author Miquéias Lopes on 14/09/15.
 */
public class SymptomList {

    private String codigo;
    private String nome;
    private boolean selected;

    public SymptomList() {

    }

    public SymptomList(String codigo, String nome) {
        this.codigo = codigo;
        this.nome = nome;
    }

    public SymptomList(String codigo, String nome, boolean selected) {
        this.codigo = codigo;
        this.nome = nome;
        this.selected = selected;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public boolean isSelected() {
        return selected;
    }

    public void setSelected(boolean selected) {
        this.selected = selected;
    }
}

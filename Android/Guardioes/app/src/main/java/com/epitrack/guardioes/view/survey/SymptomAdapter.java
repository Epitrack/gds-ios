package com.epitrack.guardioes.view.survey;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.TextView;
import android.widget.Toast;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.Symptom;
import com.epitrack.guardioes.model.SymptomList;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Igor Morais
 */
public class SymptomAdapter extends ArrayAdapter<SymptomList> {

    private static final int VIEW_TYPE_ITEM = 1;
    private static final int VIEW_TYPE_OTHER = 2;

    private static final int VIEW_TYPE_AMOUNT = 2;

    private static final int POSITION_VIEW_TYPE_OTHER = 11;

    final private List<SymptomList> symptomArray;

    public SymptomAdapter(final Context context, final List<SymptomList> symptomArray) {
        super(context, 0, symptomArray);

        this.symptomArray = symptomArray;
    }

    public static class ViewHolder {
        CheckBox checkBoxSymptom;
        TextView textViewName;
    }

    @Override
    public int getCount() {
        return symptomArray.size() + 1;
    }

    @Override
    public int getViewTypeCount() {
        return VIEW_TYPE_AMOUNT;
    }

    @Override
    public int getItemViewType(final int position) {
        return (position == POSITION_VIEW_TYPE_OTHER ? VIEW_TYPE_OTHER: VIEW_TYPE_ITEM) - 1;
    }

    @Override
    public View getView(final int position, final View convertView, final ViewGroup viewGroup) {
        View view = convertView;

        if (getItemViewType(position) == VIEW_TYPE_OTHER - 1) {

            return LayoutInflater.from(viewGroup.getContext())
                                 .inflate(R.layout.symptom_other, viewGroup, false);

        } else {

            ViewHolder viewHolder;

            if (view == null) {

                view = LayoutInflater.from(viewGroup.getContext())
                                     .inflate(R.layout.symptom_item, viewGroup, false);

                viewHolder = new ViewHolder();

                viewHolder.checkBoxSymptom = (CheckBox) view.findViewById(R.id.check_box_symptom);
                viewHolder.textViewName = (TextView) view.findViewById(R.id.text_view_name);

                viewHolder.checkBoxSymptom.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {

                    @Override
                    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                        int getPosition = (Integer) buttonView.getTag();  // Here we get the position that we have set for the checkbox using setTag.
                        symptomArray.get(getPosition).setSelected(buttonView.isChecked()); // Set the value of checkbox to maintain its state.
                    }
                });

                view.setTag(viewHolder);
                view.setTag(R.id.check_box_symptom, viewHolder.checkBoxSymptom);

            } else {
                viewHolder = (ViewHolder) view.getTag();
            }

            final SymptomList symptomList = position > POSITION_VIEW_TYPE_OTHER ? this.symptomArray.get(position - 1) : this.symptomArray.get(position);

            if (position > POSITION_VIEW_TYPE_OTHER) {
                viewHolder.checkBoxSymptom.setTag(position - 1);
            } else {
                viewHolder.checkBoxSymptom.setTag(position);
            }

            viewHolder.textViewName.setText(symptomList.getNome());
            viewHolder.checkBoxSymptom.setChecked(symptomList.isSelected());
            return view;
        }
    }
}

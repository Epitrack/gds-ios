package com.epitrack.guardioes.view;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.Notice;

import java.util.ArrayList;
import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * @author Igor Morais
 */
public class NoticeAdapter extends RecyclerView.Adapter<NoticeAdapter.ViewHolder> {

    private final NoticeListener listener;

    private List<Notice> noticeList = new ArrayList<>();

    public NoticeAdapter(final NoticeListener listener, final List<Notice> noticeList) {

        if (listener == null) {
            throw new IllegalArgumentException("The listener cannot be null.");
        }

        this.listener = listener;
        this.noticeList = noticeList;

        // TODO: STUB

        final Notice news1 = new Notice();

        news1.setTitle("É possivel pegar mais de uma gripe ao mesmo tempo?");
        news1.setSource("mundoestranho.abril.com.br");
        news1.setPublicationDate("2 dias atrás");

        final Notice news2 = new Notice();

        news2.setTitle("Ministério da Saúde convoca população para fazer teste da hepatite C");
        news2.setSource("agenciabrasil.ebc.com.br/");
        news2.setPublicationDate("4 dias atrás");

        final Notice news3 = new Notice();

        news3.setTitle("Vacinação contra gripe é estendida em Bauru e Marília");
        news3.setSource("g1.globo.com");
        news3.setPublicationDate("4 dias atrás");

        final Notice news4 = new Notice();

        news4.setTitle("Gripe aviária se espalha pela África; ONU teme contágio humano");
        news4.setSource("g1.globo.com");
        news4.setPublicationDate("5 dias atrás");

        final Notice news5 = new Notice();

        news5.setTitle("Aluno ganha medalha por remédio contra gripe à base de acerola e caju");
        news5.setSource("g1.globo.com");
        news5.setPublicationDate("6 dias atrás");

        final Notice news6 = new Notice();

        news6.setTitle("Cientistas criam vacina experimental que gera anticorpos do HIV em roedor");
        news6.setSource("g1.globo.com");
        news6.setPublicationDate("7 dias atrás");

        final Notice news7 = new Notice();

        news7.setTitle("Qual é a diferença entre gripe e resfriado?");
        news7.setSource("mundoestranho.abril.com.br");
        news7.setPublicationDate("8 dias atrás");

        final Notice news8 = new Notice();

        news8.setTitle("Qual a diferença entre febre amarela, dengue e malária?");
        news8.setSource("super.abril.com.br");
        news8.setPublicationDate("10 dias atrás");

        final Notice news9 = new Notice();

        news9.setTitle("Fio cruz inova em estudo de vacina contra a leishmaniose");
        news9.setSource("blog.saude.gov.br");
        news9.setPublicationDate("11 dias atrás");

        noticeList.add(news1);
        noticeList.add(news2);
        noticeList.add(news3);
        noticeList.add(news4);
        noticeList.add(news5);
        noticeList.add(news6);
        noticeList.add(news7);
        noticeList.add(news8);
        noticeList.add(news9);
    }

    public class ViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.text_view_title)
        TextView textViewTitle;

        @Bind(R.id.text_view_source)
        TextView textViewSource;

        @Bind(R.id.text_view_date)
        TextView textViewDate;

        @Bind(R.id.image_view_image)
        ImageView imageViewImage;

        public ViewHolder(final View view) {
            super(view);

            ButterKnife.bind(this, view);
        }
    }

    @Override
    public NoticeAdapter.ViewHolder onCreateViewHolder(final ViewGroup viewGroup, final int viewType) {
        
        final View view = LayoutInflater.from(viewGroup.getContext())
                                        .inflate(R.layout.notice_item, viewGroup, false);

        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final NoticeAdapter.ViewHolder viewHolder, final int position) {

        final Notice notice = noticeList.get(position);

        viewHolder.textViewTitle.setText(notice.getTitle());
        viewHolder.textViewSource.setText(notice.getSource());
        viewHolder.textViewDate.setText(notice.getPublicationDate());
        viewHolder.imageViewImage.setImageResource(R.drawable.stub1);
    }

    @Override
    public int getItemCount() {
        return noticeList.size();
    }
}
